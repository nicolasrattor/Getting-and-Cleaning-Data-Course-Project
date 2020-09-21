
## Packages

library(dplyr)

## Download the data

getwd()

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "data.zip")

unzip(zipfile = "data.zip", exdir = getwd())



# You should create one R script called run_analysis.R that does the following.

#1. Merges the training and the test sets to create one data set.

# Training data

tr1<-read.table("UCI HAR Dataset/train/subject_train.txt")
#tr2<-read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
#tr3<-read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
#tr4<-read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")

tr2<-read.table("UCI HAR Dataset/train/X_train.txt")
tr3<-read.table("UCI HAR Dataset/train/y_train.txt")


# Test data

te1<-read.table("UCI HAR Dataset/test/subject_test.txt")
#te2<-read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
#te3<- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
#te4<-read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
te2<-read.table("UCI HAR Dataset/test/X_test.txt")
te3<-read.table("UCI HAR Dataset/test/y_test.txt")


# Merge

x_data <- rbind(tr2,te2)
y_data <- rbind(tr3,te3)
subject_data <- rbind(tr1,te1)

features<-read.table("UCI HAR Dataset/features.txt")

a<-t(features[2])
a[1,]

names(x_data)<-a[1,]
names(subject_data)<-"subjects"
names(y_data)<-"activity"
data <- cbind(subject_data, y_data, x_data)


#2. Extracts only the measurements on the mean and standard deviation for each measurement.

a <- grep("std\\(\\)|mean\\(\\)|activity|subject", names(data), value=TRUE)
data<-data %>% select(a)



#3. Uses descriptive activity names to name the activities in the data set
table(data$activity,useNA = "ifany")

data<-data %>% mutate(activity=case_when(
                                   activity==1 ~ "WALKING",
                                   activity==2 ~ "WALKING_UPSTAIRS",
                                   activity==3 ~ "WALKING_DOWNSTAIRS",
                                   activity==4 ~ "SITTING",
                                   activity==5 ~ "STANDING",
                                   activity==6 ~ "LAYING"))


str(data)


write.table(data, file = "tidy_data.txt", row.names = FALSE)

#4. Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data2<-data %>% group_by(subjects,activity) %>% summarise_all(mean)

write.table(data2, file = "tidy_data_by_subject.txt", row.names = FALSE)


