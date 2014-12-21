# run_anaysis.R an R script file to download prepare and save data

#creata data folder if not already present

if(!file.exists("data")){dir.create("data")}
#Download data file

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
localZipFile <- "./data/getdata_projectfiles_UCI HAR Dataset.zip"
download.file(fileUrl,destfile=localZipFile,method="curl")
unzip(localZipFile,exdir="./data")
dateDownloaded <- date()

# Read in features and activity_labels data files
features <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Read in full _test data files //  

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt",col.names=features[,2])
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

# Read in _train data files
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt",col.names=features[,2])
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

#############################################################
# Merge the training and the test sets to create one data set
#############################################################

#Set column names for _test data sets
colnames(subject_test) <- "subject"
colnames(y_test) <- "activity"

#combine _test data sets
Combined_test <- cbind(subject_test,y_test,X_test)

#Set column names for _train data sets
colnames(subject_train) <- "subject"
colnames(y_train) <- "activity"


#combine _train data sets
Combined_train <- cbind(subject_train,y_train,X_train)

#merge data sets
# set new variable column for Train and Test data sets
Combined_train$dataType <- "training"
Combined_test$dataType <- "test"
mergedData <- rbind(Combined_train,Combined_test)

###########################################################################################
# 2 Extract only the measurements on the mean and standard deviation for each measurement. 
###########################################################################################
library(data.table)
# convert to data.table in order to be able to ues like function
features <- data.table(features)
# use like function to extract a list of cloumn names only containing Mean or std in names
meanAndStdList <- rbind(features[V2 %like% "mean" ], features[V2 %like% "std"])
# make into true names
meanAndStdNames <- make.names(meanAndStdList[,V2])
# add in Activity Subject & dataType
# use which function to extract columns that match mean and std list 
#meanAndStd <- mergedData[ , -which(names(mergedData) %in% meanAndStd)]
meanAndStdCols <- c("subject","activity",meanAndStdNames)
meanAndStdData <- mergedData[,meanAndStdCols]
##########################################################################
# 3 Uses descriptive activity names to name the activities in the data set activity_labels
##########################################################################
colnames(activity_labels) <- c("activity","activityDesc")
activityDescription <- merge(meanAndStdData,activity_labels, by.x="activity",by.y="activity")
# Remove old Activity column
activityDescription$activity <- NULL
######################################################################
# 4 Appropriately labels the data set with descriptive variable names.
######################################################################
###############################################################################################################################################
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###############################################################################################################################################
library(reshape2)
meltData <- melt(activityDescription,id.var=c("activityDesc","subject"))
tidyData <- dcast(meltData, activityDesc + subject ~ variable,mean)
#write out tidy data set
write.table(tidyData, file="./tidyDataSet.txt", row.name=FALSE)





