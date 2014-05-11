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
colnames(actnames)<-c("V1","Activity")

## Read the list of features corresponding to variable codes
features<-read.table("features.txt")

## Find all "mean" variables
means<-grep("mean\\(\\)",features[,2])

## Find all standard deviation variables
stds<-grep("std\\(\\)",features[,2])

## This is the subset of all observations that we want to keep from TESTING set
useful1 <-test[,c(means,stds)]
## This is the subset of all observations that we want to keep from TRAINING set
useful2 <-train[,c(means,stds)]

## Make a single data frame from the variables, subject id and activity code
test2<-cbind(testsubj,namestest,useful1)
train2 <- cbind(trainsubj,namestrain,useful2)

## Now merge test and train data
final <- rbind(test2,train2)

## Now merge the activity label in test2
#final2 <- merge(final,actnames,by.x="activity_code",by.y="V1")

## Remove the temporary variables
rm(namestest,namestrain,test2,train2,testsubj,trainsubj,means,stds,useful1,useful2)

## Start measuring the means for each variable


write.table(final2,"final.txt",row.names=FALSE)