**BACKGROUND INFO**
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

**Done Outside R Script**
Downloaded file from internet AND unzipped it into 'Project' directory

**Down Inside run_analysis.R Script**
	setwd 
#load all files
	a = read.table("test/X_test.txt")
	b = read.table("train/X_train.txt")
	c = read.table("test/y_test.txt")
	d = read.table("train/y_train.txt")
	e = read.table("features.txt")
	f = read.table("activity_labels.txt")
	g = read.table("test/subject_test.txt")
	h = read.table("train/subject_train.txt")
#combine files
	ab = rbind(a,b)
	cd = rbind(c,d)
	gh = rbind(g,h)
#convert activity code to activity label
	for (label in cd){
		activity <- f[label,2]
	}
# Only select column names that have "std" | "mean"
### use grep to find substrs "std" | "mean"
### decided to use the more inclusive selection
	colNumbers <- grep("mean|std",e[,2],ignore.case=TRUE) # 86 columns
# To exclude columns like angle(Mean(s)) and meanFreq USE 
# colNumbers <- grep("-mean\\(|-std\\(",e[,2],ignore.case=TRUE) # 66 columns
# make colnames R compliant 
	e[,3] <- gsub("-","_",e[,2])
	e[,3] <- make.names(e[,3])
# THEN assign names to columns
	colnames(ab) <- e[,3]
# Create table of selected fields
	selectCols = ab[,colNumbers]
# append Subject ID and Activity Label as first columns
	colnames(gh) <- 'subject'
	file1 <- cbind(gh,activity,selectCols)
# write out file	
	write.table(file1,file="file1.txt")		#file1.txt 10299 rows
# Create column names for Codebook
	colnames(ab) <- e[,2] # original names
	selectCols = ab[,colNumbers]
	origNames <- cbind(gh,activity,selectCols)
	file3 <- cbind(c(integer(2),colNumbers),colnames(file1),colnames(origNames))
	write.table(file3,file="features-with-R.txt",row.names=FALSE)
# step 5 how many rows seems like 1 row per subject/activity -> 180
	file2 <- aggregate(file1[,3:88],list(file1$subject,file1$activity),mean )
	colnames(file2)[1:2] <- c("subject","activity")
# by subject per activity to reverse 
	file2 <- aggregate(file1[,3:88],list(file1$activity,file1$subject),mean )
	colnames(file2)[1:2] <- c("activity","subject")
# file2-tidy.txt 6 activities and 30 subjects -> 180 rows uploaded to github 
	write.table(file2,file="file2-tidy.txt") #file2-tidy.txt 180 rows
	