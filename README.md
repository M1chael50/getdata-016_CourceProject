getdata-016_CourceProject
=========================

getdata-016_CourceProject

### Introduction

This is the Project assignment for the 'Getting and Cleaning Data' Courcera cource getdata-016 
It uses data collected from the accelerometers from the Samsung Galaxy S smartphone.

A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

and the original data sets can be obtained form here
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### The goal is to prepare tidy data that can be used for later analysis.

An R script called run_analysis.R in this repo does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### 1  Merges the training and the test sets to create one data set.

The script downloads the data in to a directory called data and un zips it.

It then load in the features and activity_lables into data tables
The main data files are then loaded, they form 2 groups Test and Training data

#### Test data files

X_test was loaded using the features data set to set names 
subject_test
y_test

#### Trianing data files

X_train was loaded using the features data set to set names
subject_train
y_train 

Suitable column names for subject and y data tables are added "subject", "activity" and the 3 files for each group are combined using cbind
Before the merging of the 2 groups a dataType factor variable was added ("training & "test")
The groups were then brought together using rbind


### 2 Extract only the measurements on the mean and standard deviation for each measurement. 

'data.table' library was used to convert the  to data.table in order to be able to ues like function
%like% "mean" and %like% "std" to creat a list of featuers that had mean and Std values these were then extraced into 'meanAndStdData' from the larger data set along with the subject and activity columns


### 3 Uses descriptive activity names to name the activities in the data set activity_labels


The activity_lables data set was then merged with meanAndStdData by activity to create a new data set with names, the old int cloumn was then removed


### 4 Appropriately labels the data set with descriptive variable names.

Appropriate labes were added throughout the processing so no additionl work was required at this point 

###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The reshape2 library was used here to melt and dcast the data appropreatly and the resultant tidy data set saved as tidyDataSet.txt
