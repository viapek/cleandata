# cleandata
##Getting and Cleaning data assignment

This script works with the extracted UCI HAR Dataset directory found at
- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Once you have downloaded the data change the current working directory to UCI HAR Dataset
- setwd('UCI HAR Dataset')

Place the run_analysis.R script in the directory and run.

##How it works

The script first checks that the data are present by looking for the presence of the expected directories.

Then it checks to see if a dataset already exists with the same name. If so it exits asking that this be addressed before running again.

The script loads the data.table and dplyr packages

The column names are then extracted from the features.txt file.

Then for both test and then train data parts:
- load the y data and apply human readable labels
- replace the activity codes with appropriate text
- grab the subject identifiers
- combine into single dataset

Tidy the dataset ensuring that it is indeed a data.table and then remove only the variables relating to mean() and std(). Also making the column names easier to read.

Remove all the excess datasets from memory and lastly calculate the averageData.

