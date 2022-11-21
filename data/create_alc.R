#Name: Ghaida Azzahra
#Date: 21 November 2022
#Assignment 3 Data Wrangling, data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Read the files
setwd("D:/Helsinki/Lectures/Year 1 - period 2/Open Data Science/IODS-project/data")
math <- read.csv("student-mat.csv", sep = ";", header=TRUE)
por <- read.csv("student-por.csv", sep = ";", header=TRUE)

#Checking the structure and dimensions of the data
str(math)
dim(math)
#it has 33 variables (that is either integer or character) and 395 observations
str(por)
dim(por)
#it has 33 variables (that is either integer or character) and 649 observations

library(dplyr)
# Columns that vary in the datasets
free_cols <- c("failures","paid","absences","G1","G2","G3")

# Identifier variables
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols)

# Explore the structure and dimensions of the joined data
str(math_por)
dim(math_por)
# it has 39 variables (either character or integers) and 370 observations

# Get rid of duplicate records
# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

#create alc_use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
#create high_use
alc <- mutate(alc, high_use = alc_use > 2)

# glimpse at the new modified data
glimpse(alc)
# it has 35 variables and 370 observations

# save the joined and modified data
library(tidyverse)
write.csv(alc, file = "alc.csv", row.names=FALSE)
