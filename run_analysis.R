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

#use aggregate() to calculate means by subject and activity: 
#see answer by Joris Meys http://stackoverflow.com/questions/7029800/how-to-run-tapply-on-multiple-columns-of-data-frame-using-r
mnsbysubj<-t(aggregate(comdat[,3:68],by=list(comdat$Subject),mean))
mnsbyact<-t(aggregate(comdat[,3:68],by=list(comdat$Activity),mean))

#provide descriptive column labels for the tidy data
sublabel<-1:30
sublabel<-paste("Mean for Subject",sublabel," ")
colnames(mnsbysubj)<-sublabel
actlabel2<-paste("Mean for All Subjects", actlabel," ")
colnames(mnsbyact)<-actlabel2
tidydata<-cbind(colnames(ftt),mnsbysubj[2:67,],mnsbyact[2:67,]) #The first row of mnsbysubj/mnsbyact is redundant column names.  Subsetting rows 2:67 is probably not the most elegant solution here, but it works.
colnames(tidydata)[1]<-"Feature"
#step 4/5 complete

#Write the tidy data txt file
write.table(tidydata,file="tidydata.txt",sep=",",row.names=F)
#output to text file complete!
#this tidy data set considers each feature as an observation and each subject and each activity as a distinc variable measured for that observation
#there is one row for each feature and one column for each subject or activity.
#simply transposing it using t(tidydata) would give a tidy data set treating each feature as a variable with subject or activity as the observation unit

