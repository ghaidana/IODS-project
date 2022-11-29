#read files
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#structure, dimension, and summary
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

#renaming variables
library(dplyr)
hd <- rename(hd, Life.Exp= "Life Expectancy at Birth", 
             Edu.Exp = "Expected Years of Education", 
             GNI = "Gross National Income (GNI) per Capita")
gii <- rename(gii, Mat.Mor="Maternal Mortality Ratio", 
              Ado.Birth="Adolescent Birth Rate", 
              Parli.F= "Percent Representation in Parliament", 
              Edu2.F = "Population with Secondary Education (Female)", 
              Edu2.M = "Population with Secondary Education (Male)", 
              Labo.F="Labour Force Participation Rate (Female)", 
              Labo.M="Labour Force Participation Rate (Male)")

#mutating gii
gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M, 
              Labo.FM= Labo.F/Labo.M)

#joining datasets
human <- inner_join(gii, hd, by = "Country", suffix = c(".gii", ".hd"))
dim(human)
#it has 195 observations and 19 variables

#write dataset
write.csv(human, file = "human.csv", row.names = FALSE)