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
Biodiversity_NY_cleaned <- Biodiversity_NY[, setdiff(names(Biodiversity_NY), c("Taxonomic.Subgroup", "Scientific.Name", "Year.Last.Documented", 
                                                                               "NY.Listing.Status", "State.Conservation.Rank", "Global.Conservation.Rank", 
                                                                               "Distribution.Status"))] %>%
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
  left_join(Biodiversity_NY_final, by = c("NAME" = "County")) %>%
  rename(County = NAME)
# the left_join function combines rows/columns from two datasets based on a common variable, keeping all rows from the left dataset.
# As such the same can be done if you want to keep all the rows/columns from the right dataset

# View combined data
print(combined_data)
# We can now see that the columns "Common.name" and "Status" have been added to the ny_counties data. This dataset would be useful
# if you were to make a map with the data since it has geographical location information for the counties.

# 3a. Making Sense of the Data
# When looking at the data it's clear that while some counties have no endangered or threatened species, some have more than one,
# so in order to create data that can be used for a linear model we will need to change some of that data from logical to numarical
combined_data <- combined_data %>%
  mutate(Status = ifelse(Status %in% c("Threatened", "Endangered"), "At Risk", Status)) 
# Doing this changed combined the two entities ("Threatened" and "Endangered") in the Status column and created a new entity called 
# "At Risk", doing this will allow you to create numerical data for the amount of "At Risk" species per county.

# 3b. Creating Numerical Data
combined_data <- combined_data[ , setdiff(names(combined_data), c("Common.Name"))]

# Create a dataset that has the Counties plus the amount of "At Risk" species they have
at_risk_counts <- combined_data %>%
  filter(Status == "At Risk") %>%  # Filter rows where species are 'At Risk'
  group_by(County) %>%                     # Group by county
  summarise(At_Risk_Count = n())           # Count number of 'At Risk' species
# As we can see from the new dataset, it only includes the counties that had "At Risk" species and did not also include 
# the ones who had NA listed, we can fix this so that all counties are included

# Create a list of all counties (including those with NA counts for "At Risk" species)
all_counties <- unique(combined_data$County)

# Create a data frame for all counties with 0 "At Risk" species 
all_counties_df <- data.frame(
  County = all_counties,
  At_Risk_Count = 0,
  stringsAsFactors = FALSE)
# This creates a data frame with a column for counties and a column for 0

# Merge the "At Risk" counts with the list of all counties, including those with 0
final_county_data <- merge(all_counties_df, at_risk_counts, by = "County", all.x = TRUE)

# Remove the At Risk count data that was added during the merge which has only 0
final_county_data <- final_county_data[ , setdiff(names(final_county_data), c("At_Risk_Count.x"))] %>%
  rename(At_Risk_Count = At_Risk_Count.y)
  mutate(At_Risk_Count = ifelse(is.na(At_Risk_Count), 0, At_Risk_Count))
  # This changes the value of NA to 0 so that it is now numeric
  
# View Data
print(final_county_data)
# Now we have a dataset that can be used for linear modeling to show the distribution of at risk species among NY Counties

# 3c. Linear Model Using Final Data
# While we could do a linear model with simply the counties and the amount of at risk species they have, you should want
# to incorporate a entity that will create a more in-depth analysis of why a county might have more at risk species. 
# For our case I will add the county areas, this is an extra step that is not needed, and takes outside research but is beneficial
# if you want a better model outcome
county_area <- data.frame(
  County = c("Albany", "Allegany", "Bronx", "Broome", "Cattaraugus", "Cayuga", "Chautauqua", "Chemung", "Chenango", "Clinton", "Columbia", "Cortland",
             "Delaware", "Dutchess", "Erie", "Essex", "Franklin", "Fulton", "Genesee", "Greene", "Hamilton", "Herkimer", "Jefferson", "Kings", "Lewis", 
             "Livingston", "Madison", "Monroe", "Montgomery", "Nassau", "New York", "Niagara", "Oneida", "Onondaga", "Ontario", "Orange", "Orleans", "Oswego", 
             "Otsego", "Putnam", "Queens", "Rensselaer", "Richmond", "Rockland", "Saratoga", "Schenectady", "Schoharie", "Schuyler", "Seneca", "St. Lawrence",
             "Steuben", "Suffolk", "Sullivan", "Tioga", "Tompkins", "Ulster", "Warren", "Washington", "Wayne", "Westchester", "Wyoming", "Yates"),
  Area_Sq_Miles = c(522, 1045, 42, 705, 1310, 864, 1070, 407, 894, 1047, 645, 498, 1445, 801, 1046, 1975, 1533, 533, 498, 663, 1735, 1460, 
                    1268, 69, 1214, 634, 662, 1367, 413, 284, 23, 526, 1213, 819, 653, 819, 813, 978, 1000, 246, 108, 653, 57, 174, 813, 210, 627, 335, 
                    315, 2821, 1391, 2373, 968, 523, 476, 1161, 868, 847, 603, 450, 593, 1141))

# Merge Final_county_data with county_area
Final_data_area <- merge(county_area, final_county_data, by = "County", all.x = TRUE)
# This is the final dataset that we will use to run the linear model

# Run Linear model
# Since we want to know the relationship between the number of "At Risk" species per county and area of said county, we will use function
# lm, which will give us the coefficients, R-squared value, and p-value
model <- lm(At_Risk_Count ~ Area_Sq_Miles, data = Final_data_area)

# Summary of linear model
summary(model)
