#Ghaida Azzahra
#Data Wrangling Week 5: Dimensionality Reduction Techniques
#original source: https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt

#read files
hd <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#structure, dimension, and summary
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

#renaming variables
library(dplyr)
hd <- rename(hd, Life.Exp= "Life.Expectancy.at.Birth", 
             Edu.Exp = "Expected.Years.of.Education", 
             GNI = "Gross.National.Income..GNI..per.Capita",
             hdi.index = "Human.Development.Index..HDI.",
             mye = "Mean.Years.of.Education",
             gni.hdi = "GNI.per.Capita.Rank.Minus.HDI.Rank")
gii <- rename(gii, Mat.Mor="Maternal.Mortality.Ratio", 
              Ado.Birth="Adolescent.Birth.Rate", 
              Parli.F= "Percent.Representation.in.Parliament", 
              Edu2.F = "Population.with.Secondary.Education..Female.", 
              Edu2.M = "Population.with.Secondary.Education..Male.", 
              Labo.F="Labour.Force.Participation.Rate..Female.", 
              Labo.M="Labour.Force.Participation.Rate..Male.",
              gii.index = "Gender.Inequality.Index..GII.")

#mutating gii
gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M, 
              Labo.FM= Labo.F/Labo.M)

#joining datasets
human <- inner_join(gii, hd, by = "Country", suffix = c(".gii", ".hd"))
dim(human)
#it has 195 observations and 19 variables

#write dataset
write.csv(human, file = "human.csv", row.names = FALSE)

#read dataset
human <- read.csv("human.csv")
dim(human)
#this data is about Human Development Index (HDI), 
#Gender Inequality Index,
#and the variables related to those indices
#it has 19 variables from 195 observations
str(human)
#the 19 variables are:
#GII.Rank: country's Gender Inequality Index rank
#Country: country name
#gii.index: Gender Inequality Index score
#Mat.Mor: maternal mortality
#Ado.Birth: adolescent birth rate
#Parli.F: female share of parliamentary seats
#Edu2.F: proportion of female with at least secondary education
#Edu2.M: proportion of male with at least secondary education
#Labo.F: female labor participation rate
#Labo.M: male labor participation rate
#Edu2.FM: ratio of female/male proportion with at least secondary education
#Labo.FM: ratio of female/male labor participation rate
#HDI.Rank: country's Human Development Index rank
#hdi.index: country's Human Development Index score
#Life.Exp: life expectancy at birth
#Edu.Exp: expected years of schooling
#mye: mean years of schooling
#GNI: Gross National Income
#gni.hdi: GNI rank - HDI rank

#transform the Gross National Income (GNI) variable to numeric
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()

#Exclude unneeded variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep))

#Remove all rows with missing values
human$comp <-  complete.cases(human)
human <- filter(human, comp == TRUE)
human <- select(human, -comp)

#Remove the observations which relate to regions instead of countries
last <- nrow(human) - 7
human <- human[1:last,]

#Define the row names of the data by the country names and remove the country name column from the data
rownames(human) <- human$Country
human <- select(human, -Country)

#Save the human data
saveRDS(human, "human.rds")
