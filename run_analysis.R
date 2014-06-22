#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation 
##for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#Creates a second, independent tidy data set with the average of each variable 
##for each activity and each subject.

setwd("C:/Users/pam/Desktop/Coursea Courses/Data Science Specialization/Getting and Cleaning Data/Project")

a = read.table("test/X_test.txt")
b = read.table("train/X_train.txt")
c = read.table("test/y_test.txt")
d = read.table("train/y_train.txt")
e = read.table("features.txt")
f = read.table("activity_labels.txt")
g = read.table("test/subject_test.txt")
h = read.table("train/subject_train.txt")

# combine X_train with X_test and Y_train with Y_test
ab = rbind(a,b)
cd = rbind(c,d)
gh = rbind(g,h)

#convert activity code to activity label
for (label in cd){
    activity <- f[label,2]
}

# create a file with column names that only have "std" | "mean"
### use grep to find substrs "std" | "mean"
colNumbers <- grep("mean|std",e[,2],ignore.case=TRUE) # 86
# To exclude columns like angle(Mean(s)) and meanFreq USE 
# colNumbers <- grep("-mean\\(|-std\\(",e[,2],ignore.case=TRUE) # 66

# make names R compliant in a new column
e[,3] <- gsub("-","_",e[,2])
e[,3] <- make.names(e[,3])
# THEN assign names to columns
colnames(ab) <- e[,3]

# Create table of selected fields
selectCols = ab[,colNumbers]
# append Activity Label rows as first field
colnames(gh) <- 'subject'
file1 <- cbind(gh,activity,selectCols)
write.table(file1,file="file1.txt")
# DOCUMENTATION FOR CODEBOOK 
colnames(ab) <- e[,2] # original names
selectCols = ab[,colNumbers]
origNames <- cbind(gh,activity,selectCols)
file3 <- cbind(c(integer(2),colNumbers),colnames(file1),colnames(origNames))
write.table(file3,file="features-with-R.txt",row.names=FALSE)
#steps 1 thru 4 complete

# step 5 how many rows seems like 1 row per subject/activity -> 180
file2 <- aggregate(file1[,3:88],list(file1$subject,file1$activity),mean )
colnames(file2)[1:2] <- c("subject","activity")
# by subject per activity to reverse 
# file2 <- aggregate(file1[,3:88],list(file1$activity,file1$subject),mean )
# colnames(file2)[1:2] <- c("activity","subject")
write.table(file2,file="file2-tidy.txt")
