# Sophie Rose - s1739832@ed.ac.uk
# Coding Club Tutorial - Webscraping

# Checking wd
getwd()
setwd("C:/Users/sophi/OneDrive/Documents/R/coding-club-tutorials/retrieving-useful-information-from-webpages")

# installing rvest
install.packages("rvest")

library(rvest)
library(dplyr)

# importing .html into R
Penguin_html <- readLines("Aptenodytes forsteri (Emperor Penguin).html")

# finding anchor
grep("Scientific Name:", Penguin_html)

# searching for species name
Penguin_html[131:135]

# Double check the line containing the scienific name.
grep("Scientific Name:", Penguin_html)
Penguin_html[131:135]
Penguin_html[133]

# Isolate line in new vector
species_line <- Penguin_html[133]

## Use pipes to grab the text and get rid of unwanted information like html tags
species_name <- species_line %>%
  gsub("<td class=\"sciName\"><span class=\"notranslate\"><span class=\"sciname\">", "", .) %>%  # Remove leading html tag
  gsub("</span></span></td>", "", .) %>%  # Remove trailing html tag
  gsub("^\\s+|\\s+$", "", .)  # Remove whitespace and replace with nothing
species_name

grep("Common Name", Penguin_html)
Penguin_html[130:160]
Penguin_html[150:160]
Penguin_html[151]

common_name <- Penguin_html[151] %>%
  gsub("<td>", "", .) %>%
  gsub("</td>", "", .) %>%
  gsub("^\\s+|\\s+$", "", .)
common_name

grep("Red List Category", Penguin_html)
Penguin_html[179:185]
Penguin_html[182]

red_cat <- gsub("^\\s+|\\s+$", "", Penguin_html[182])
red_cat

grep("Date Assessed:", Penguin_html)
Penguin_html[192:197]
Penguin_html[196]

date_assess <- Penguin_html[196] %>%
  gsub("<td>", "",.) %>%
  gsub("</td>", "",.) %>%
  gsub("\\s", "",.)
date_assess

# creating the start of our data frame by concatenating the vectors
iucn <- data.frame(species_name, common_name, red_cat, date_assess)

# importing multiple webpages
search_html <- readLines("Search Results.html")

# search for lines containing links to species pages
line_list <- grep("<a href=\"/details", search_html)  # Create a vector of line numbers in `search_html` that contain species links
link_list <- search_html[line_list]  # Isolate those lines and place in a new vector

# clean up lines so only full URL is left
species_list <- link_list %>%
  gsub('<a href=\"', "http://www.iucnredlist.org", .) %>%  # Replace the leading html tag with a URL prefix
  gsub('\".*', "", .) %>%  # Remove everything after the `"`
  gsub('\\s', "",.)  # Remove any white space

file_list_grep <- link_list %>%
  gsub('.*sciname\">', "", .) %>% # Remove everything before `sciname\">`
  gsub('</span></a>.*', ".html", .) # Replace everything after `</span></a>` with `.html`
file_list_grep

mapply(function(x,y) download.file(x,y), species_list, file_list_grep)

penguin_html_list <- lapply(file_list_grep, readLines)

sci_name_list_rough <- lapply(penguin_html_list, grep, pattern="Scientific Name:")
sci_name_list_rough
penguin_html_list[[2]][133]

# convert list into simple vector, gives line containing actual species name rather than scientific
sci_name_unlist_rough <- unlist(sci_name_list_rough) + 1

# retrieving lines containing scientific names from each .html file and store as vector
sci_name_line <- mapply('[', penguin_html_list, sci_name_unlist_rough)

# remove html tags and whitespace around each entry
## Clean html
sci_name <- sci_name_line %>%
  gsub("<td class=\"sciName\"><span class=\"notranslate\"><span class=\"sciname\">", "", .) %>%
  gsub("</span></span></td>", "", .) %>%
  gsub("^\\s+|\\s+$", "", .)

# Find common name
## Isolate line
common_name_list_rough <- lapply(penguin_html_list, grep, pattern = "Common Name")
common_name_list_rough #146
penguin_html_list[[1]][151]

common_name_unlist_rough <- unlist(common_name_list_rough) + 5

common_name_line <- mapply('[', penguin_html_list, common_name_unlist_rough)

common_name <- common_name_line %>%
  gsub("<td>", "", .) %>%
  gsub("</td>", "", .) %>%
  gsub("^\\s+|\\s+$", "", .)

# red list category
red_cat_list_rough <- lapply(penguin_html_list, grep, pattern = "Red List Category")
red_cat_list_rough
penguin_html_list[[16]][186]

red_cat_unlist_rough <- unlist(red_cat_list_rough) + 2
red_cat_unlist_rough
penguin_html_list[[2]][187]

red_cat_line <- mapply(`[`, penguin_html_list, red_cat_unlist_rough)
red_cat <- gsub("^\\s+|\\s+$", "", red_cat_line)

# date assessed
date_list_rough <- lapply(penguin_html_list, grep, pattern = "Date Assessed:")
date_list_rough  # Different locations
penguin_html_list[[18]][200]
date_unlist_rough <- unlist(date_list_rough) + 1

date_line <- mapply('[', penguin_html_list, date_unlist_rough)

date <- date_line %>%
  gsub("<td>", "",.) %>%
  gsub("</td>", "",.) %>%
  gsub("\\s", "",.)

# combine vectors into dataframe
penguin_df <- data.frame(sci_name, common_name, red_cat, date)
penguin_df
