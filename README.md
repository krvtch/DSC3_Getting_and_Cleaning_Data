---
title: "README.md"
author: "proj20"
date: "July 1, 2017"
output: html_document
---


## Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate the author's ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. This repo contains the following files:

* a tidy data set (tidyData.csv) as described in the "Tidy Data Set Objectives"
* a script (run_analysis.R) for performing the analysis
* a code book (CodeBook.md) that describes the variables, the data, and any transformations or work that you performed to clean up the data
* a README.md that explains how all of the scripts work and how they are connected (this file)


## Overview

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## Tidy Data Set Objectives

To create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Methodology and Explanation by Objective

## Getting and Preparing the Raw Data Set
The section below downloads the raw data set needed from the web URL then unzips the contents.

```{r}
dir.create("C:/Users/User/Desktop/Coursera/Course3_Data_Cleaning/Project")
setwd("C:/Users/User/Desktop/Coursera/Course3_Data_Cleaning/Project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "dataset.zip", mode = "wb")
unzip("dataset.zip", exdir = "./Project")
```
To check if the contents of the package have been successfully unzipped.
```{r}
list.files("./Project", recursive=TRUE)
```

## Objective 1: Merges the training and the test sets to create one data set.

Read and merge all Test Data set into a single data table
```{r}
subjtest <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt")
colnames(subjtest) <- "subjectId"

ytest <- read.table("./Project/UCI HAR Dataset/test/y_test.txt")
colnames(ytest) <- "activityId"

xtest <- read.table("./Project/UCI HAR Dataset/test/X_test.txt")
xcols <- read.table("./Project/UCI HAR Dataset/features.txt")
colnames(xtest) <- xcols$V2

merge_test <- cbind(subjtest,ytest,xtest)
head(merge_test)
```

Read and merge all Train Data set into a single data table
```{r}
subjtrain <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt")
colnames(subjtrain) <- "subjectId"

ytrain <- read.table("./Project/UCI HAR Dataset/train/y_train.txt")
colnames(ytrain) <- "activityId"

xtrain <- read.table("./Project/UCI HAR Dataset/train/X_train.txt")
colnames(xtrain) <- xcols$V2

merge_train <- cbind(subjtrain,ytrain,xtrain)
head(merge_train)
```

Merge both Test and Train Data sets into a singular data table
```{r}
mergedData <- rbind(merge_test,merge_train)
str(mergedData)
```

## Objective 2: Extracts only the measurements on the mean and standard deviation for each measurement
Use `grepl()` function to select only columns that are needed for the tidy data
```{r}
featNames <- colnames(mergedData)
# featNames becomes a logical vector where the values TRUE correspond to the needed mean and standard deviation columns
featNames <- (grepl("activityId" , featNames) | grepl("subjectId" , featNames) | grepl("mean\\()" , featNames) | grepl("std" , featNames))

mean_and_std_Data <- mergedData[,featNames == T]
# to verify that there are now 68 columns in the new data set
length(colnames(mean_and_std_Data))
```

## Objective 3: Uses descriptive activity names to name the activities in the data set
Use the `merge()` function to create a new variable called `activityName` that describes the activity name associated with the activity ID  
```{r}
activityLabels <- read.table("./Project/UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels) <- c("activityId","activityName")
mean_and_std_Data <- merge(mean_and_std_Data,activityLabels,by = "activityId")
# to verify that there are now 69 columns in the new data set
length(colnames(mean_and_std_Data))
```

## Objective 4: Appropriately labels the data set with descriptive variable names
We have already appropriately labelled the data set `mean_and_std_Data` with descriptive variable names when we used the `colnames()` function at Objective 1


## Objective 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Use the `aggregate()` function under the stats package to do the means summary then create a new independent tidy data set called `tidyData.csv` by using `write.csv()` function
```{r}
tidyData <- aggregate(. ~activityName + subjectId, mean_and_std_Data, mean)
tidyData <- tidyData[order(tidyData$activityId,tidyData$subjectId),]
write.table(tidyData, file = "./Project/UCI HAR Dataset/tidyData.txt",row.names = F,sep = ",")
```

Thanks for reading through. You've reached the end of README.md
