# Getting and cleaning data

Data originally from
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Files in this repo

CodeBook.md -- codebook describing variables and the data and transformations
run_analysis.R -- actual R code
README.md -- description of "run_analysis.R"
summary-data.txt - the resulting dataset provided by "run_analysis.R"

## run_analysis Goals
The task was to create R script that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
It should run in a folder of the Samsung data (the zip had this folder: UCI HAR Dataset) The script assumes it has in it's working directory the following files and folders:

## Requirements
For running the script you should meet this requirements
1. Set the working directory
2. Download and unzip the original dataset. You can use this code
```
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI HAR Dataset.zip")
zip.file.extract("UCI HAR Dataset.zip", zipname = "UCI HAR Dataset")
```

## Walkthrough
__Step 0:__
1. Creates universal OS paths of each file.
2. Reads the files in test and train folders

__Step 1:__
1. Creates 2 different data frames for test and train data using cbind function
2. Merge 2 tables into one using rbind function

__Step 4:__ _(according to provided task)_
1. Reading features file with variable names
2. Creates vector from it
3. Replaces the parentheses, "std" with "st-deviation", speces with "-"
4. Adds correct headers to df from step 1

__Step 2 and 3:__ _(both steps using dplyr functions)_
1. Reads the table with the activities labels
2. Ads activity labels to df according to IDs'
3. Selects columns with mean and standart deviation measurments

__Step 5:__
1. Groups the table by subject IDs and activities
2. Calculates mean values for those groups
3. Writes produced df to files "summary_data.txt"
