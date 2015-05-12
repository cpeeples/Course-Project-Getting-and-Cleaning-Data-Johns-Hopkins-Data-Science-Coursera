#You should create one R script called run_analysis.R that does the following. 
#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names. 
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#load the data
        #features
ftest<-read.table("./UCI HAR dataset/test/X_test.txt")
ftrain<-read.table("./UCI HAR dataset/train/X_train.txt")
        #subjects
stest<-read.table("./UCI HAR dataset/test/subject_test.txt")
strain<-read.table("./UCI HAR dataset/train/subject_train.txt")
        #activities
actest<-read.table("./UCI HAR dataset/test/y_test.txt")
actrain<-read.table("./UCI HAR dataset/train/y_train.txt")        

#bind all test and train rows
ftt<-rbind(ftest,ftrain)
stt<-rbind(stest,strain)
att<-rbind(actest,actrain)
#step 1 complete

#name the columns
fnames<-read.table("./UCI HAR dataset/features.txt")
colnames(ftt)<-t(fnames[,2])
colnames(stt)<-"Subject"
colnames(att)<-"Activity"

#make a 'whitelist' of feature names including mean and std
whitelist<-grepl("mean[(][)]|std[(][)]",names(ftt))
ftt<-ftt[,whitelist]  #subset the feature data keeping only the whitelisted columns
#step 2 complete

#give activities descriptive labels
actlabel<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
for (i in 1:6) {
        att[att$Activity==i,]<-actlabel[i]
}
# step 3 complete

#bind various columns into a single data frame including all observations
comdat<-cbind(stt,att,ftt) #

#creates a new column combining subject and activity into one factor for use with aggregate().
comdat["SubjectActivity"]<-paste(comdat[,"Subject"],comdat[,"Activity"],"")

#use aggregate() to calculate means by subject/activity combination: 
#see answer by Joris Meys http://stackoverflow.com/questions/7029800/how-to-run-tapply-on-multiple-columns-of-data-frame-using-r
mnsbysubjact<-aggregate(comdat[,3:68],by=list(comdat$SubjectActivity),mean)
colnames(mnsbysubjact)[1]<-"Subject ID Activity"
#step 4/5 complete

#Write the tidy data txt file
write.table(mnsbysubjact,file="tidydata.txt",sep=",",row.names=F)
#output to text file complete!

# This tidy data set considers each subject/activity combination (30 subject * 6 activities=180 combinations) as an observation and each 
# "feature" (there are 66 features of the mean() std() types) as a distinct variable measured for that observation

# If Subject and Activity were separate columns, then there would be an additional column in 
# the data set that does not correspond to an observed variable (i.e. "Activity").
# If one argued against the previous point, that in fact, the activity a given subject was performing 
# counts as a variable measured, that would imply that one subject is the unit of observaation.  Then there 
# would be multiple rows for one observation; not tidy! 
# Thus, we can see that in order for this dataset to be 'tidy', we must have Subject/Activity combined as
# the identifier for one observation unit.  
# User of this dataset may apply "strsplit()" if they wish to have subject and activity separated for some 
# analysis.