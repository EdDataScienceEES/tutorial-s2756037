# Advanced Data Manipulation: The Many Ways that Data can be Changed to Fit Your Needs
# Created by: Anna Longenbaugh
# Start Date: 26/11/24
# End Data: 28/11/24

# Load/Install Necessary Libraries
install.packages("readr")
install.packages("tidyr")
install.packages("dplyr")

library(readr)
library(tidyr)
library(dplyr) 

# 1a. Load Data
# When loading data you want to make sure that you know the "path" to the data or else you will get error messages
# saying that the data does not exist. This can be frustrating when you are first starting out but Github makes to easy
# by being able to copy the path by pressing the three dots in the top right hand corner of the window.
Biodiversity_NY <- read.csv("Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")
# If you tried to run this line of code you will get an error message, this is because I didn't add the folder name where
# the data is stored
Biodiversity_NY <- read.csv("Data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")
# This code should now run smoothly since I have added "Data/" before the csv name, which tells R where exactly the data is located

# 1b. Tidying Data
# The importance of tidying data is to make it easier when creating plots, running a linear model, etc. It allows for you to
# select which data you actually want to analyze.
# In the case of our data we want to only include to include County, Category (Animals), Taxonomic Group, Common name, and Federal status
# There are multiple ways to tidy data, I have used three methods here.
# 1st I used setdiff which allows me to say which columns I want to remove from the main dataset
Biodiversity_NY_cleaned <- Biodiversity_NY[, setdiff(names(Biodiversity_NY), c("Taxonomic.Subgroup", "Scientific.Name", "Year.Last.Documented", "NY.Listing.Status", "State.Conservation.Rank", "Global.Conservation.Rank", "Distribution.Status"))] %>%
  # 2nd I renamed one of the columns to make it easier to understand
  rename(Status = Federal.Listing.Status) %>%
  # 3rd I filtered to only include the organisms that were "Endangered" or "Threatened"
  filter(Status == c('Endangered', 'Threatened')) %>% #Include only endangered and threatened animals since they are most at risk 
  # Finally I filtered again to only include the animals, no plants
  filter(Category == c('Animal')) 

# View cleaned data
print(Biodiversity_NY_cleaned)
# Based on the cleaned data we now have a dataset that has been reduced from 20507 objects to 89, and from 12 variables to 5

# 1c. Filter data further to only include County, Common name, and Status
# Now that our original data has been become more selective, we can get rid of the two addition unneeded columns
# which are Category and Taxonomic Group, this can be done the same way as before but using the new dataset
Biodiversity_NY_final <- Biodiversity_NY_cleaned[ , setdiff(names(Biodiversity_NY_cleaned), c("Category", "Taxonomic.Group"))]

# View Final data
print(Biodiversity_NY_final)
# Based on the final cleaned data we now have a dataset that has been reduced from 5 variables to 3

# 2a. Install package that allows for County data
install.packages("tigris")
library(tigris)
# This package allows us to access data from the US Census Bureau

# 2b. Load US county data
# Load the US counties shapefile using tigris
us_counties <- counties(cb = TRUE, resolution = "20m")
# During this will create a dataset with all 3222 US counties along with their state location and other information 
# including their geographic signature and government number

# 2c. Filter for only NY counties 
# Include only New York counties since that is where our biodiversity data is taken from
ny_counties <- us_counties[us_counties$STUSPS == "NY", ]  # Filter for New York
# This will create a dataset called ny_counties that has 62 counties and the same additional information as the full d
# dataset had

# 2d. Combine ny_counties with biodiversity_NY_final
# Merge with the county shapefile based on the county name
combined_data <- ny_counties %>%
  left_join(Biodiversity_NY_final, by = c("NAME" = "County"))
# the left_join function combines rows/columns from two datasets based on a common variable, keeping all rows from the left dataset.
# As such the same can be done if you want to keep all the rows/columns from the right dataset

# View combined data
print(combined_data)
# We can now see that the columns "Common.name" and "Status" have been added to the ny_counties data. This dataset would be useful
# if you were to make a map with the data since it has geographical location information for the counties.

