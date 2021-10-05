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
