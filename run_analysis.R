## this script is for the Assignment of Getting and Cleaning Data Course Project
## reads and clean up data from activity tracking

# read in test set
test <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt") # activity label
test_subject <- read.table("./test/subject_test.txt")
# add in activity label and subject info
test <- cbind(test,test_y,test_subject)

# read in training test
train <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt") # activity label
train_subject <- read.table("./train/subject_train.txt")
# add in activity label and subject info
train <- cbind(train,train_y,train_subject)

# combine the two datasets
data <- rbind(train,test)
dim(data) # 10299, 563
# read in the feature names 
features <- read.table("./features.txt") 

# add column names to the dataset
names(data) <- features$V2
colnames(data)[562:563] <- c("activity_id", "subject_id")

# creating index for measurements containing mean and std
mean_index <- grep("mean", names(data))
std_index <- grep("std", names(data))
data1 <- data[,c(mean_index, std_index, 562:563)]
dim(data1) # 10299, 81

# add descriptive activity name 
activity_names <- read.table("activity_labels.txt")
library(dplyr)
data2 <- mutate(data1, activity = activity_names[activity_id,2]) %>% select(-activity_id)
head(data2)
# modify the variable names a little bit
names(data2) <- gsub("\\()","", names(data2))
names(data2) <- gsub("^t","time",names(data2))
names(data2) <- gsub("^f","freq",names(data2))
names(data2) <- gsub("-","_",names(data2))

# write this dataset as tidy_dataset1
write.table(data2, file = "tidy_dataset1.txt")

# make the second tidy_dataset for the average of each variable for each activity and each subject
data3 <- group_by(data2, activity, subject_id)
tidy_dataset2 <- summarise_each(data3, funs(mean))
write.table(tidy_dataset2, file = "tidy_dataset2.txt")