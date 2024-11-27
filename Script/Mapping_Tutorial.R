# Mapping Continued: Incorporating Intricate Details into Data Visualization
# Created by: Anna Longenbaugh
# Start Date: 26/11/24
# End Data: 28/11/24

# Load/Install Necessary Libraries
install.packages("readr")
install.packages("tidyr")
install.packages("dplyr")
install.packages("broom")
install.packages("ggplot2")
install.packages("ggExtra")
install.packages("maps")
install.packages("RColorBrewer")
install.packages("raster")
install.packages("rworldmap")

library(readr)
library(broom)
library(ggplot2) 
library(ggExtra)
library(dplyr) 
library(raster)  
library(rworldmap)  
library(RColorBrewer)
library(maps)

# Load Data
Biodiversity_NY <- read.csv("Data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")

# Tidying Data
# Want to include Country, Project name, Species, and Hectares
Biodiversity_NY_cleaned <- Biodiversity_NY[, setdiff(names(Biodiversity_NY), c("Taxonomic.Subgroup", "Scientific.Name", "Year.Last.Documented", "NY.Listing.Status", "State.Conservation.Rank", "Global.Conservation.Rank", "Distribution.Status"))]

             