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
