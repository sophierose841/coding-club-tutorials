# Coding Club Edi University
# Tutorial - Working Efficiently with Large Datasets
# Unfinished.

getwd()

install.packages("readr")
install.packages("tidyr")
install.packages("dplyr")
install.packages("broom")
install.packages("ggplot2")
install.packages("ggExtra")
install.packages("maps")
install.packages("RColorBrewer")

library(readr)
library(tidyr)
library(dplyr)
library(broom)
library(ggplot2)
library(ggExtra)
library(maps)
library(RColorBrewer)

# Loading data - not .csv.
# .RData file easier for larger datasets.

load("LPIdata_Feb2016.RData")
load("puffin_GBIF.RData")

# 1. Formatting and tidying data usinf tidyr.
# Checking if data is tidy.
View(head(LPIdata_Feb2016))

# Tidying year columns at end of dataset.
LPI_long <- gather(data = LPIdata_Feb2016, 
                   key = "year", value = "pop", 26:70)

# Columns coded as characters due to "X".
# Changing to numeric variables.
LPI_long$year <- parse_number(LPI_long$year)

# Checking names
names(LPI_long)
# Some names include "." instead of "_".

# Changing names for consistency.
names(LPI_long) <- gsub(".", "_", names(LPI_long), fixed = TRUE)

# Changing names to lower case.
names(LPI_long) <- tolower(names(LPI_long))

# To group by species, have to group by species and genus.
# Avoids species with similar names.
# Making new column with genus/species together.
LPI_long$genus_species_id <- paste(LPI_long$genus, LPI_long$species, LPI_long$id, sep = "_")

# Sample of contents to check variables are displayed properly.
View(LPI_long[c(1:5,500:505,1000:1005),])
# You can use [] to subset data frames [rows, columns]
# If you want all rows/columns, add a comma in the row/column location

# country_list and biome have , and / to separate entities.
# Using gsub() to correct.
LPI_long$country_list <- gsub(",", "", LPI_long$country_list, fixed = TRUE)
LPI_long$biome <- gsub("/", "", LPI_long$biome, fixed = TRUE)

# 2.Efficiently manipulating data using dplyr.
# Checking for duplicate rows.
LPI_long <- distinct(LPI_long)

# Remove rows with missing or infinite data.
LPI_long_fl <- filter(LPI_long, is.finite(pop))

# Only want to use populations with 5 years > data.
# Scale data, some species present in high abundanecs.
# Bit confusing here. Too much going on.

LPI_long <- LPI_long_fl %>%
  group_by(genus_species_id) %>%  # group rows so that each group is one population
  mutate(maxyear = max(year), minyear = min(year),  # Create columns for the first and most recent years that data was collected
         lengthyear = maxyear-minyear,  # Create a column for the length of time data available
         scalepop = (pop-min(pop))/(max(pop)-min(pop))) %>%  # Scale population trend data so that all values are between 0 and 1
  filter(is.finite(scalepop),  # remove NAs
         lengthyear > 5) %>%  # Only keep rows with more than 5 years of data
  ungroup()  # Remove any groupings you've greated in the pipe

# Checking summary of data.
LPI_biome_summ <- LPI_long %>%
  group_by(biome) %>%  # Group by biome
  summarise(populations = n(),   # Create columns, number of populations
            mean_study_length_years = mean(lengthyear),  # mean study length
            max_lat = max(decimal_latitude),  # max latitude
            min_lat = min(decimal_latitude),  # max longitude
            dominant_sampling_method = names(which.max(table(sampling_method))),  # modal sampling method
            dominant_units = names(which.max(table(units))))  # modal unit type

View(LPI_biome_summ)

# 3. Automating data manipulation using lapply(), loops and pipes.
# Cba doing this section, only used one method from tutorial, pipe method.
LPI_models_pipes <- LPI_long %>%
  group_by(genus_species_id, lengthyear) %>% 
  do(mod = lm(scalepop ~ year, data = .)) %>%  # Create a linear model for each group
  mutate(n = df.residual(mod),  # Create columns: degrees of freedom
         intercept = summary(mod)$coeff[1],  # intercept coefficient
         slope = summary(mod)$coeff[2],  # slope coefficient
         intercept_se = summary(mod)$coeff[3],  # standard error of intercept
         slope_se = summary(mod)$coeff[4],  # standard error of slope
         intercept_p = summary(mod)$coeff[7],  # p value of intercept
         slope_p = summary(mod)$coeff[8]) %>%  # p value of slope
  ungroup() %>%
  mutate(lengthyear = lengthyear) %>%  # adding back the duration column, otherwise it won't be saved in the object
  filter(n > 5) # Remove rows where degrees of freedom <5

# Saving data frame.
save(LPI_models_pipes, file = "LPI_models_pipes.RData")

LPI_models_pipes_mod <- LPI_models_pipes %>% select(-mod)  # Remove `mod`, which is a column of lists (... META!)
write.csv(LPI_models_pipes_mod, file="LPI_models_pipes.csv", )  # This takes a long time to save, don't run it unless you have time to wait.

# 4.Automating data visualization using 

# Making theme for graphs
theme_LPI <- function(){
  theme_bw() +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title.x = element_text(size = 14, face = "plain"),
          axis.title.y = element_text(size = 14, face = "plain"),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0.5),
          legend.text = element_text(size = 12, face = "italic"),
          legend.title = element_blank(),
          legend.position = c(0.9, 0.9))
}

# Making a histogram of changing populations in different biomes, using slope estimates
install.packages("colourpicker")

# Picking colours "#BFEFFF", "#E6E6FA", "#FFF0F5"
