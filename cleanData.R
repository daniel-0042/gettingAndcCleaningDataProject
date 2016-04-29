# this script reads the UCI data set from various files, combines it to one tidy dataset which is written to csv

rm(list=ls())

library(reshape2)
library(tidyr)
library(dplyr)
library(data.table)


#load data from seperate files
x.train <- fread("../UCI HAR Dataset/train/X_train.txt", header = FALSE)
y.train <- fread("../UCI HAR Dataset/train/y_train.txt",  header = FALSE)
subject.train <- fread("../UCI HAR Dataset/train/subject_train.txt", sep = " ", header = FALSE)
x.test <- fread("../UCI HAR Dataset/test/X_test.txt", header = FALSE)
y.test <- fread("../UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject.test <- fread("../UCI HAR Dataset/test/subject_test.txt", sep = " ", header = FALSE)

#load meta data
features <- fread("../UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
activities <- fread("../UCI HAR Dataset/activity_labels.txt", sep = " ", header = FALSE)

#join data
test <- cbind(subject.test, x.test, activities$V2[y.test$V1])
train <- cbind(subject.train, x.train, activities$V2[y.train$V1])
all.data <- rbind(test, train)
rm(x.train,y.train,subject.train,train,x.test,y.test,subject.test,test)

#assign colnames
colnames(all.data) <- c("subject", features$V2, "activity")

#subset mean and std 
all.data <- select(all.data,  subject, contains("mean()"), contains("std()"), activity)# matches("mean()"),matches("std()"))
all.data <- arrange(all.data,  subject)
#Label data (remove special chars and apply to column names)
colnames(all.data) <- gsub("-", ".", colnames(all.data))
colnames(all.data) <- gsub("[\\(\\)]", "", colnames(all.data))

write.csv(all.data, "tidy UCI HAR Dataset.csv", row.names = F)

mean.of.all.data<-all.data%>%group_by(subject,activity)%>%
                             summarize_each(funs(mean))%>%
                             ungroup() %>%
                             arrange(subject,activity) %>%
                             collect() 

write.csv(mean.of.all.data, "means of tidy UCI HAR Dataset.csv", row.names = F)
