#Cleaning up the Samsung Human Activity Recognition dataset
##This run_analysis.R script is an R script that tidies up the data set.
###It should be run in the same folder with the unzipped getdata-projectfiles-UCI HAR Dataset.zip
####The contents of the zip should be extracted to the directory "UCI HAR Dataset" in same directory that the script is run from
###It starts by loading up all the test and train data for features, subjects, and activities.  
####It uses rbind() to join test and train sets.  Follwing that, it uses colnames() to add labels for each feature, subject, and activity.
###It selects only the mean and standard deviation features, 66 out of the 561 total features provided in the dataset, using grepl() and subsetting columns to achieve this end.
###It replaces the integer activity labels with descriptive activity labels (e.g. "WALKING", "RUNNING", "LAYING")
###The separate feature, subject, and activity data frames are joined with cbind().
##The combined dataframe "comdat" is then operated on to produce a tidy data set that is written to a text file, "tidydata.txt".
###aggregate() is used to calculate the mean of each feature by subject and by activity separately.
###paste() and colnames() are used to provide more descriptive column names for the tidy data set.
###cbind() is used to join data frames containing means of each feature, separately, by subject or by activity.
###finally, the output is written to tidydata.txt