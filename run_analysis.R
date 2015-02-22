# using the library dplyr for SQL type commands
library(dplyr)

# loading data
tempf <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = tempf, mode = "b", method = "curl")
#cleaning files
unzip(tempf)
unlink(tempf)

# establishing the working directory 
wd <- "/Users/ralozano/Documents/Cursos/Primavera15/BigData/Coursera/CleanData/Project"
setwd(wd)
#creating the folder and changing to it
if(!file.exists("./work")){dir.create("./work")}
wd <- "/Users/ralozano/Documents/Cursos/Primavera15/BigData/Coursera/CleanData/Project/work"
setwd(wd)
wd <- paste0(wd,"/","UCI HAR Dataset")
setwd(wd)

# loading data to main memory
x_test <- read.delim("test/X_test.txt", header = FALSE, sep = '')
x_train <- read.delim("train/X_train.txt", header = FALSE, sep = '')
# union of test and training x_files
x_all <- rbind(x_test,x_train)
#cleaning 
rm(x_test)
rm(x_train)

# the same for y_files
y_test <- read.delim("test/y_test.txt", header = FALSE, sep = '')
y_train <- read.delim("train/y_train.txt", header = FALSE, sep = '')
y_all <- rbind(y_test, y_train)
rm(y_test)
rm(y_train)
#adding the column of activity for the y_file
names(y_all) <- "activity_code"

#and for the subjet_files the same thing
subject_test <- read.delim("test/subject_test.txt", header = FALSE, sep = '')
subject_train <- read.delim("train/subject_train.txt", header = FALSE, sep = '')
subject_all <- rbind(subject_test, subject_train)
rm(subject_test)
rm(subject_train)
# adding the column subject 
names(subject_all) <- "subject"

#selecting only the mean and std columns
features <- unlist(read.delim("features.txt", colClasses = c("integer", "character"), header = FALSE, sep = '')[2])
mean_std <- grep("(mean|std)", features, ignore.case=TRUE)
x_all <- x_all[,mean_std]

#replacing - for _ to the feature names
features <- features[mean_std]
features <- gsub("-","_",gsub("[\\(,\\)]","",features))
#adding a new column (feature) to the x_all
names(x_all) <- features
rm(features)

#binding x_files with y_files and subjects
x_all <- cbind(subject_all, y_all, x_all)

activity_labels <- read.delim("activity_labels.txt", colClasses = c("integer", "character"), header = FALSE, sep = '')
names(activity_labels) <- c("activity_code", "activity_name")

#adding the activity lables to the final product
x_all <- select(merge(activity_labels, x_all), c(subject,activity_name:angleZgravityMean),-activity_code)

### for the file required
# group by subject and activity name and obtain the mean of the features
means <- aggregate.data.frame(x_all[,3:88], by = list(x_all$subject,x_all$activity_name), FUN = mean) %>% rename(subject = Group.1, activity_name = Group.2)
setwd("..")
#writing the file requested
write.table(means, file = "means.txt", row.names=FALSE)


