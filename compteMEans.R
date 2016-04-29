#read UCI ata set from previous excercise and compute the means grouped by subject and activitd.

rm(list=ls())

library(reshape2)
library(tidyr)
library(dplyr)
library(data.table)


#load data from seperate files
all.data <- fread("tidy UCI HAR Dataset.csv", header = T)

mean.of.all.data<-all.data%>%group_by(subject,activity)%>%
                             summarize_each(funs(mean))%>%
                             ungroup() %>%
                             arrange(subject,activity) %>%
                             collect() 

write.csv(mean.of.all.data, "means of tidy UCI HAR Dataset.csv", row.names = F)
