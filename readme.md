#Cleaning up the Samsung Human Activity Recognition dataset
##This run_analysis.R script is an R script that tidies up the data set.
It should be run in the same folder with the unzipped getdata-projectfiles-UCI HAR Dataset.zip
The contents of the zip should be extracted to the directory "UCI HAR Dataset" in same directory that the script is run from
##It starts by loading up all the test and train data for features, subjects, and activities.  
It uses rbind() to join test and train sets.  Following that, it uses colnames() to add labels for each feature, subject, and activity.
##It selects only the mean and standard deviation features. 
These make up 66 out of the 561 total features provided in the dataset, and are extracted using grepl() and subsetting columns to achieve this end.
##It replaces the integer activity labels with descriptive activity labels (e.g. "WALKING", "RUNNING", "LAYING")
##The separate feature, subject, and activity data frames are joined with cbind().
##The combined dataframe "comdat" is then operated on to produce a tidy data set that is written to a text file, "tidydata.txt".
A new identifier column is formed by paste() - ing subject ID and activity together.
aggregate() is used to calculate the mean of each feature by subject/activity combination.
The identifier column is strsplit()-ed to form the final tidy data frame.
finally, the output is written to tidydata.txt