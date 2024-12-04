# Advanced Data Manipulation: Practice
# Name:
# Created by: Anna Longenbaugh
# Date:

# Goal of the practice: Show whether there is significance relationship between species richness and county human population

# Load/Install Necessary Libraries
install.packages("readr") 
install.packages("tidyr")
install.packages("dplyr")

library(readr)
library(tidyr)
library(dplyr) 

# LOAD AND TIDY DATA

# 1a. Load data
Biodiversity_NY <- read.csv("Data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")


# 1b. Tidy Data
# First Filter for County, Category, and Common.name
# Second Filter to include only Animals



# 1c. Filter further and remove Common.Name column
# Doing this will make it easy in further steps to create numeric data
# Hint: Use same method as in the previous step


# FURTHER MANIPULATION USING ADDITIONAL DATA

# 2a. Install package that allows for County data
install.packages("tigris")
library(tigris)


# 2b. Load US county data
# Load the US counties shapefile using tigris


# 2c. Filter for only NY counties 
# Include only New York counties since that is where our biodiversity data is taken from


# 2d. Combine ny_counties with biodiversity_NY_final
# Merge with the county shapefile based on the county name


# ADJUSTING DATA AND RUNNING LINEAR MODEL

# 3a. Making Sense of the Data
# What are your thoughts on the cleaned data? Is there anything else you believe should be done?


# 3b. Creating Numerical Data
# Since we want the amount of species per county you will have to create a new dataset that has the counties and the number of species
# In step 1c we filtered to only include the county and category, this means we can simply filter for the amount of "Animals" per county
species_count <- (this is whatever you named your cleaned data) %>%
  filter(Category == "Animal") %>%         # Filter rows for "Animal"
  group_by(County) %>%                     # Group by County
  summarise(Species_Count = n())           # Count number of Animals 


# View Data
print(species_count)


# 3c. Linear Model Using Final Data
# While we could do a linear model with simply the counties and the amount of at risk species they have, you should want
# to incorporate a entity that will create a more in-depth analysis of why a county might have more at risk species. 
# For our case I will add the county areas, this is an extra step that is not needed, and takes outside research but is beneficial
# if you want a better model outcome
# Here is the data for NY county human populations:
# Albany (316659), Allegany (46651), Bronx (1356476), Broome (196077), Cattaraugus (75600), Cayuga (74485), Chautauqua (124891), Chemung (81325), 
# Chenango (45920), Clinton (78115), Columbia (60470), Cortland (45752), Delaware (44410), Dutchess (297150), Erie (946147), Essex (36775), 
# Franklin (46502), Fulton (52234), Genesee (57529), Greene (47062), Hamilton (5082), Herkimer (59484), Jefferson (114787), Kings (2561225), 
# Lewis (26548), Livingston (61158), Madison (66921), Monroe (748482), Montgomery (49368), Nassau (1381715), New York (1597451), Niagara (209457), 
# Oneida (227555), Onondaga (467873), Ontario (112494), Orange (407470), Orleans (39124), Oswego (118162), Otsego (60126), Putnam (98060), 
# Queens (2252196), Rensselaer (159305), Richmond (490687), Rockland (340807), Saratoga (238711), Schenectady (159902), Schoharie (30105), Schuyler (17507), 
# Seneca (32349), St. Lawrence (106940), Steuben (92162), Suffolk (1523170), Sullivan (79920), Tioga (47715), Tompkins (103558), Ulster (182333), 
# Warren (65380), Washington (60047), Wayne (90829), Westchester (990817), Wyoming (39532), Yates (24472)
county_population <- data.frame(
  County = c("Albany", "Allegany", "Bronx", "Broome", "Cattaraugus", "Cayuga", "Chautauqua", "Chemung", "Chenango", "Clinton", "Columbia", "Cortland",
             "Delaware", "Dutchess", "Erie", "Essex", "Franklin", "Fulton", "Genesee", "Greene", "Hamilton", "Herkimer", "Jefferson", "Kings", "Lewis", 
             "Livingston", "Madison", "Monroe", "Montgomery", "Nassau", "New York", "Niagara", "Oneida", "Onondaga", "Ontario", "Orange", "Orleans", "Oswego", 
             "Otsego", "Putnam", "Queens", "Rensselaer", "Richmond", "Rockland", "Saratoga", "Schenectady", "Schoharie", "Schuyler", "Seneca", "St. Lawrence",
             "Steuben", "Suffolk", "Sullivan", "Tioga", "Tompkins", "Ulster", "Warren", "Washington", "Wayne", "Westchester", "Wyoming", "Yates"),
  Population = c())
# You must add the population manually 


# Merge species_count with county_population


# 3d. Run Linear model
# Since we want to know the relationship between species richness per county and population of said county, we will use function
# lm, which will give us the coefficients, R-squared value, and p-value


# Summary of linear model
# How do you interpret the values? Is the relationship significant? 
