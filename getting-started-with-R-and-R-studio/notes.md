# Notes - Getting Started with R and R Studio
## 1. Begin to write script.
At the beginning of each script, it's useful to write the date, time, what you are doing.

```
# Coding Club Workshop 1 - R Basics
# Learning how to import and explore data, and make graphs about Edinburgh's biodiversity
# Written by Gergana Daskalova 06/11/2016 University of Edinburgh
```

It's also useful to install and download the packages you will be using. The packages need installed only once, however need downloaded each time they are used within a script.
```
install.packages("dplyr")
library(dplyr)
# Note that there are quotation marks when installing a package, but not when loading it
# and remember that hashtags let you add useful notes to your code! 
```


Setting a working directory is crucial in determining where R Studio will look to access data.
First you must check where the working directory is using the code below. You can then set the working directory if it's not were you'd like it to be upon initial checks.
```
getwd()
```

```
setwd("C:/User/CC-1-RBasics-master")
# This is an example filepath, alter to your own filepath
```

## 2. Import and Check Data
#### Importing
When importing data, make sure working directory is correct first. ```Edidiv``` is the name given to the imported data. It is then stored as an object.

```
object_name <- read.csv(data)
```
Here is an example...
```
edidiv <- read.csv("C:/Users/user/Desktop/Intro_to_R/edidiv.csv")  # This is the file path based on where I saved the data, your filepath will be different
```
#### Checking Data
Once data is importaint it's a good idea to make some check to understand the data's internal structure.
```
head(edidiv)                # Displays the first few rows
tail(edidiv)                # Displays the last rows
str(edidiv)                 # Tells you whether the variables are continuous, integers, categorical or characters
```

#### Accessing Columns and Changing Variable Type
If you want to check data for one column only, R allows the use of $ to segregate. To use; $ then following column name.
```
head(edidiv$taxonGroup)     # Displays the first few rows of this column only
class(edidiv$taxonGroup)    # Tells you what type of variable we're dealing with: it's character now but we want it to be a factor
```
To change variable type within a column, use code below.
```
edidiv$taxonGroup <- as.factor(edidiv$taxonGroup)
```
Other data exploration tools include...
```
# More exploration
dim(edidiv)                 # Displays number of rows and columns
summary(edidiv)             # Gives you a summary of the data
summary(edidiv$taxonGroup)  # Gives you a summary of that particular variable (column) in your dataset
```
