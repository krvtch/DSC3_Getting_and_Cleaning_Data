# Download the data package and read the data into R
dir.create("C:/Users/User/Desktop/Coursera/Course3_Data_Cleaning/Project")
setwd("C:/Users/User/Desktop/Coursera/Course3_Data_Cleaning/Project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "dataset.zip", mode = "wb")
unzip("dataset.zip", exdir = "./Project")

# To check if the contents of the package have been successfully unzipped
list.files("./Project", recursive=TRUE)


## Objective 1: Merges the training and the test sets to create one data set.

# Read and arrange Test Data set
subjtest <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt")
colnames(subjtest) <- "subjectId"

ytest <- read.table("./Project/UCI HAR Dataset/test/y_test.txt")
colnames(ytest) <- "activityId"

xtest <- read.table("./Project/UCI HAR Dataset/test/X_test.txt")
xcols <- read.table("./Project/UCI HAR Dataset/features.txt")
colnames(xtest) <- xcols$V2

merge_test <- cbind(subjtest,ytest,xtest)
head(merge_test)

# Read and arrange Train Data set
subjtrain <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt")
colnames(subjtrain) <- "subjectId"

ytrain <- read.table("./Project/UCI HAR Dataset/train/y_train.txt")
colnames(ytrain) <- "activityId"

xtrain <- read.table("./Project/UCI HAR Dataset/train/X_train.txt")
colnames(xtrain) <- xcols$V2

merge_train <- cbind(subjtrain,ytrain,xtrain)
head(merge_train)

# Merge Test and Train Data sets
mergedData <- rbind(merge_test,merge_train)
str(mergedData)


## Objective 2: Extracts only the measurements on the mean and standard deviation for each measurement

featNames <- colnames(mergedData)
# featNames becomes a logical vector where the values TRUE correspond to the needed mean and standard deviation columns
featNames <- (grepl("activityId" , featNames) | grepl("subjectId" , featNames) | grepl("mean\\()" , featNames) | grepl("std\\()" , featNames))

mean_and_std_Data <- mergedData[,featNames == T]
# to verify that there are now 68 columns in the new data set
length(colnames(mean_and_std_Data))


## Objective 3: Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table("./Project/UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels) <- c("activityId","activityName")
mean_and_std_Data <- merge(mean_and_std_Data,activityLabels,by = "activityId")
# to verify that there are now 69 columns in the new data set
length(colnames(mean_and_std_Data))


## Objective 4: Appropriately labels the data set with descriptive variable names

# We have already appropriately labelled the data set 'mean_and_std_Data' with descriptive variable names when we used the colnames() function at Objective 1.


## Objective 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Let's use the function aggregate() under the stats package
tidyData <- aggregate(. ~activityName + subjectId, mean_and_std_Data, mean)
tidyData <- tidyData[order(tidyData$activityId,tidyData$subjectId),]
write.table(tidyData, file = "./Project/UCI HAR Dataset/tidyData.txt",row.names = F,sep = ",")
