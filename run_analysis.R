library(reshape2)

x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
s_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
s_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

# 1. Merging the test and train dataset to create one dataset
x_data<-rbind(x_train,x_test)
y_data<-rbind(y_train,y_test)
s_data<-rbind(s_train,s_test)


# 2. Extracting only the mean and the standard deviation for each measurement
feature<-read.table("./UCI HAR Dataset/features.txt")

selectedCols<-grep("-(mean|std).*" , as.character(feature[,2]))
selectedColNames<-feature[selectedCols,2]
selectedColNames<-gsub("-mean","Mean",selectedColNames)
selectedColNames<-gsub("-std","Std",selectedColNames)
selectedColNames<-gsub("[-()]","",selectedColNames)


# 3. Uses descriptive activity names to name the activity in the dataset.
activity_label<-read.table("./UCI HAR Dataset/activity_labels.txt")
x_data<-x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

# 4. Appropriatly labelling the dataset.
allData$Activity<-factor(allData$Activity,levels = activity_label[,1],labels = activity_label[,2])
allData$Subject <- as.factor(allData$Subject)

# 5. Creating tidy dataset.
meltedData<-melt(allData,id = c("Subject","Activity"))
tidydata<-dcast(meltedData,Subject + Activity ~ variable,mean)

write.table(tidydata, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
