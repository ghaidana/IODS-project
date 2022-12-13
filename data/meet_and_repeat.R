#Ghaida Azzahra
#Assignment 6: Data Wrangling
#Source: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt
# https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

#Load data sets
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

names(BPRS)
head(BPRS)
str(BPRS)
summary(BPRS)

names(RATS)
head(RATS)
str(RATS)
summary(RATS)

#convert to factor
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#convert into long form. add week var to BPRS and time var to RATS
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) %>%
  mutate(week = as.integer(substr(weeks, 5, 5)))

RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>%
  arrange(Time)

#compare them with their wide form versions
names(BPRS)
head(BPRS)
str(BPRS)
summary(BPRS)

names(RATS)
head(RATS)
str(RATS)
summary(RATS)
#the wide form records data from each subject/observation in one row
#in the wide form, each measurement is recorded as a variable
#in the long form, the data from all measurements/time is gathered as a single variable,
#and the measurement is recorded as categories in a variable
#the observation is also recorded as categories in a variable
#it is easier to do analysis to the long form because the variable of interest
#is not fragmented into several variables

#write wrangled data sets
setwd("D:/Helsinki/Lectures/Year 1 - period 2/Open Data Science/IODS-project")
write.csv(BPRSL, file="bprsl.csv", row.names=FALSE)
write.csv(RATSL, file="ratsl.csv", row.names=FALSE)

