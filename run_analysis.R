## file containing the code for the project

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## read the data
test<-read.table("test/X_test.txt")
train<-read.table("train/X_train.txt")

## read the subject(user) identifier
testsubj<-read.table("test/subject_test.txt")
trainsubj<-read.table("train/subject_train.txt")

## Add the names to the columns
colnames(testsubj)<-"subject"
colnames(trainsubj)<-"subject"

## read the activity id performed by each subject
namestest <- read.table("test/y_test.txt")
namestrain <- read.table("train/y_train.txt")

## Add the names to the columns
colnames(namestest)<-"activity_code"
colnames(namestrain)<-"activity_code"

## Read the names of activities for each code
actnames <- read.table("activity_labels.txt")
## Set the column names
colnames(actnames)<-c("v1","Activity")

## Read the list of features corresponding to variable codes
features<-read.table("features.txt")

## Find all "mean" variables
means<-grep("mean\\(\\)",features[,2])

## Find all standard deviation variables
stds<-grep("std\\(\\)",features[,2])

## As we have 2 sets of variables, we need to sort them in ascending order
variablelist <- sort(c(means,stds))

## This is the subset of all observations that we want to keep from TESTING set
useful1 <-test[,variablelist]
## This is the subset of all observations that we want to keep from TRAINING set
useful2 <-train[,variablelist]

## Make a single data frame from the variables, subject id and activity code
test<-cbind(testsubj,namestest,useful1)
train <- cbind(trainsubj,namestrain,useful2)

## Now merge test and train data
final <- rbind(test,train)

## Now we fix the names of variables
features <- features[c(variablelist),]
## Remove the hyphen
features$V2 <-gsub("-",".",features$V2)
## Remove the ()
features$V2 <-gsub("\\(\\)","",features$V2)

##Calculate the mean values per activity code and subject
final <- aggregate(.~subject+activity_code,FUN=mean,data=final)

## Now merge the activity label in test2
final <- merge(actnames,final,by.x="v1",by.y="activity_code")
final$activity_code<-NULL
final$v1<-NULL

## Rename the column names to the appropriate variable name
colnames(final) <- c("Activity","Subject",features$V2)

## Remove the temporary variables
rm(namestest,namestrain,testsubj,trainsubj,means,stds,useful1,useful2,features,variablelist)

## Create the tidy data file
write.table(final,"final.txt",row.names=FALSE)