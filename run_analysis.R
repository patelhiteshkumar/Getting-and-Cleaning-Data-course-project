##You should create one R script called run_analysis.R that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#   each variable for each activity and each subject.

#Updated the script to check if the required packages are installed and loaded before running the script
if (!require("data.table")) {
  install.packages("data.table")
  library(data.table)
}
if (!require("reshape2")) {
  install.packages("reshape2")
  library(reshape2)
}

if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}


# Read the activity labels data from activity_lables.txt (second column only)
  activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
 
# Read the features list data from features.txt (second column only)
  features_list <- read.table("./UCI HAR Dataset/features.txt")[,2]
  
# From the features list, filter the mean and standard deviation data lables for each features
  extract_features <- grepl("mean|std", features_list)
  
# Read the test data -> x_test & y_test & training data -> X_train & y_train
  X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#Read the subject_test.txt & subject_train.txt 
#Provides the list of the subjects for which corresponding test & training data is collected
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Assign the features_list as the column names for the X_test & X_train data since it just has variable names as V01, V02 etc.
  names(X_test) = features_list
  names(X_train) = features_list
   
# Filter out only the measurements on the mean and standard deviation for each measurement
  X_test_mean_std = X_test[,extract_features]
  X_train_mean_std = X_train[,extract_features]
 
# Add a new column to y_test & y_train
# This would have the name of the activity listed viz. 1-> walking, 2-> walking_upstairs & so on
  y_test[,2] = activity_labels[y_test[,1], 2]
  y_train[,2] = activity_labels[y_train[,1], 2]
   
#Update the column names for y_test & y_train
  names(y_test) = c("Activity_ID", "Activity_Label")
  names(y_train) = c("Activity_ID", "Activity_Label")
  
#Update the column name for the subject_test data & subject_train data
  names(subject_test) = "subject"
  names(subject_train) = "subject"
   
# Column Bind subject_test, y_test, X_test_mean_std to get all the data related to test in one table (similar for train data)
  test_data <- cbind(as.data.table(subject_test), y_test, X_test_mean_std)
  train_data <- cbind(as.data.table(subject_train), y_train, X_train_mean_std)
   
# Merge test and train data using rbind
  data = rbind(test_data, train_data)
   
#Creating id_lables variable with the varaibles that are id variables
  id_labels = c("subject", "Activity_ID", "Activity_Label")
   
#Get the feature list from the "data" table which will be used as measure.vars in melting the data
  data_labels = setdiff(colnames(data), id_labels)
   
#Melt the data
  melt_data = melt(data, id = id_labels, measure.vars = data_labels)
   
# Apply mean function to dataset using dcast function
  tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
   
#Write the file 
  write.table(tidy_data, file = "./UCI HAR Dataset/tidy_data.txt")