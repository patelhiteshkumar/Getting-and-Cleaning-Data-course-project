# Getting and Cleaning Data Course Project
## Getting the raw data and Running Script
1)The raw input data of the script is from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
2) Please download this and extract. There will be a folder called "UCI HAR Dataset"    
3) This will contain the test and training data with other files  
4) Place the run_analysis.R script into this folder  
5) Set your working directory to this folder on your terminal or in RStudio  
6) Set source("run_analysis.R") to run script. When it's finish, it will output transformed data to tidy_data.txt  

## Goals of the script

### run_analysis.R aims to do the following
* Merges the training and the test sets to create one data set  
* Extracts only the measurements on the mean and standard deviation for each measurement  
* Uses descriptive activity names to name the activities in the data set  
* Appropriately labels the data set with descriptive variable names  
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject  

## How script works

1) Load test data into R  
2) Then extract needed measurements  
3) In the mean time adding descriptive labels to variables and to observations  
4) Add Activity Labels to yTest  
5) Set measurement column names  
6) Extract needed measurement columns from x_test  
7) Merge all tables for test column wise  
8) Repeat same with training data  
9) Merge both test and train data row wise  
10) Create a second, independent tidy data set with the average of each variable for each activity and each subject  
11) This is done by determine the id columns vs the data columns  
12) Melt the data by passing data, id and data (measure) columns to the ```melt``` function  
13) Use ```dcast``` function to create data in required format  
14) Outputs this to tidy_data.txt using the ```write.table``` function   

## Dependencies such as Libraries  
Note that there is a check in the R script for these packages and if not installed, it would do the installation and load the package
1) dplyr
2) reshape2  
3) data.table  
