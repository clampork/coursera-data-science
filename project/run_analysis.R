library(dplyr)

# Download and extract dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_zip <- basename(url)
data_dir <- "UCI HAR Dataset"

if(!dir.exists(data_dir)) {
    download.file(url, data_zip, method = "curl")
    unzip(data_zip)
    file.remove(data_zip)
}

# 1. Merge the training and the test sets to create one data set
x_train <- read.table(paste0(data_dir, "/train/X_train.txt"))
x_test <- read.table(paste0(data_dir, "/test/X_test.txt"))
x_merged <- bind_rows(x_train, x_test)
features <- read.table(paste0(data_dir, "/features.txt"))[, 2]
names(x_merged) <- make.names(features, unique = TRUE)

# 2. Extract only mean and standard deviation measurements for each variable
x_subset <- select(x_merged, 
                   contains('mean.', ignore.case = FALSE), 
                   contains('std.', ignore.case = FALSE))

# 3. Use descriptive activity names to name the activities in the dataset
y_train <- read.table(paste0(data_dir, "/train/y_train.txt"))
y_test <- read.table(paste0(data_dir, "/test/y_test.txt"))
activity_labels <- read.table(paste0(data_dir, "/activity_labels.txt"))
y_train_labels <- left_join(y_train, activity_labels)
y_test_labels <- left_join(y_test, activity_labels)
y_merged <- bind_rows(y_train_labels, y_test_labels)[, 2]
names(y_merged) <- "activity"
data_merged <- bind_cols(y_merged, x_subset)

# 4. Appropriately label the data set with descriptive variable names 
names(data_merged) <- sub("^t", "time_", names(data_merged))
names(data_merged) <- sub("^f", "freq_", names(data_merged))
names(data_merged) <- sub("BodyBody", "body_", names(data_merged))
names(data_merged) <- sub("Body", "body_", names(data_merged))
names(data_merged) <- sub("Gravity", "grav_", names(data_merged))
names(data_merged) <- sub("Acc", "acc_", names(data_merged))
names(data_merged) <- sub("Gyro", "gyro_", names(data_merged))
names(data_merged) <- sub("Jerk", "jerk_", names(data_merged))
names(data_merged) <- sub("Mag", "mag_", names(data_merged))
names(data_merged) <- sub(".mean..", "mean", names(data_merged))
names(data_merged) <- sub(".std..", "std", names(data_merged))
names(data_merged) <- sub(".X", "_x", names(data_merged))
names(data_merged) <- sub(".Y", "_y", names(data_merged))
names(data_merged) <- sub(".Z", "_z", names(data_merged))

# 5. Create an independent tidy data set with the average of each variable for 
#    each activity and each subject
subject_train <- read.table(paste0(data_dir, "/train/subject_train.txt"))
subject_test <- read.table(paste0(data_dir, "/test/subject_test.txt"))
subject_merged <- bind_rows(subject_train, subject_test)
names(subject_merged) <- "subject"

data_tidy <- subject_merged %>% 
                 bind_cols(data_merged) %>%
                 group_by(subject, activity) %>% 
                 summarize_each(funs(mean))

write.table(data_tidy, 
            file = "tidy.txt", 
            quote = FALSE,
            row.name = FALSE)