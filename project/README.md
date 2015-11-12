## Getting and Cleaning Data: Course Project
For this project, we examine a dataset collected from experiments carried out amongst a group of 30 volunteers, each performing six different activities while wearing a Samsung Galaxy S II smartphone on their person. A full description of the study may be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), and the dataset may be downloaded directly from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

#### The script and its dependencies
run_analysis.R is an R script that cleans the abovementioned dataset and outputs a tidy dataset for use in further analysis. It requires the `dplyr` package, which you can install by running:
```R
install.packages("dplyr")
library(dplyr)
```

#### Download and extract dataset
First, we need to download and extract the dataset into our working directory.
```R
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_zip <- basename(url)
data_dir <- "UCI HAR Dataset"
```

In the interest of bandwidth and time, we check to see if the dataset's directory already exists, and skip the downloading and unzipping step if it does.
```R
if(!dir.exists(data_dir)) {
    download.file(url, data_zip, method = "curl")
    unzip(data_zip)
    file.remove(data_zip)
}
```

#### Step 1: Merge the training and the test sets to create one dataset
From README.txt in the data directory, we learn that the training and test sets are stored in train/X_train.txt and test/X_test.txt respectively. Here, we read both files into variables `x_train` and `x_test`, merging both with dplyr's `bind_rows` function. 
```R
x_train <- read.table(paste0(data_dir, "/train/X_train.txt"))
x_test <- read.table(paste0(data_dir, "/test/X_test.txt"))
x_merged <- bind_rows(x_train, x_test)
```

We also want to label the columns of merged data frame `x_merged` with the feature list found in features.txt so that we know what each column measures. In order to create syntactically valid and unique column names out of the `features` vector, we use the `make.names` function appended with a `unique = TRUE` argument.
```R
features <- read.table(paste0(data_dir, "/features.txt"))[, 2]
names(x_merged) <- make.names(features, unique = TRUE)
```

#### Step 2: Extract only mean and standard deviation measurements for each variable
From features_info.txt in the data directory, we learn that the mean and standard deviation variables are labeled mean() and std() respectively. Here is where `dplyr` really shines in making our code readable. We simply run `select` appended with `contains` arguments to extract the relevant columns into `x_subset`, instead of having to specify regular expressions with the `grep` function. Note that the strings we will be searching for are `mean.` and `std.`, in order to omit the `meanFreq` columns. Also, because the angle() variable contains averaging vectors that follow the naming convention 'xMean', we add an `ignore.case = FALSE` argument to omit those columns as well.
```R
x_subset <- select(x_merged, 
                   contains('mean.', ignore.case = FALSE), 
                   contains('std.', ignore.case = FALSE))
```

#### Step 3: Use descriptive activity names to name the activities in the dataset
From README.txt in the data directory, we learn that the training and test labels are stored in train/y_train.txt and test/y_test.txt respectively, while activity_labels.txt links these labels with their activity name. By performing a simple left_join on `y_train` and `activity_labels`, omitting the `by` argument because the only column both sets have in common is 'V1', we create a data frame `y_train_labels` that maps the full activity names to their indices. 
```R
y_train <- read.table(paste0(data_dir, "/train/y_train.txt"))
y_test <- read.table(paste0(data_dir, "/test/y_test.txt"))
activity_labels <- read.table(paste0(data_dir, "/activity_labels.txt"))
y_train_labels <- left_join(y_train, activity_labels)
```

We then repeat the process with `y_test` and `activity_labels` to create `y_test_labels`, and merge the second column (which contains the descriptive activity names) of both sets into `y_merged`.
```R
y_test_labels <- left_join(y_test, activity_labels)
y_merged <- bind_rows(y_train_labels, y_test_labels)[, 2]
```

Finally, we simply name the column in `y_merged` and join it column-wise to `x_subset`, creating `data_merged` that contains the subsetted data with each row appropriately labeled with its descriptive activity name.
```R
names(y_merged) <- 'activity'
data_merged <- bind_cols(y_merged, x_subset)
```

#### Step 4: Appropriately label the dataset with descriptive variable names 
Here are the variable names in `data_merged`:
```R
names(data_merged)
```
```R
 [1] "tBodyAcc.mean...X"           "tBodyAcc.mean...Y"           "tBodyAcc.mean...Z"          
 [4] "tGravityAcc.mean...X"        "tGravityAcc.mean...Y"        "tGravityAcc.mean...Z"       
 [7] "tBodyAccJerk.mean...X"       "tBodyAccJerk.mean...Y"       "tBodyAccJerk.mean...Z"      
[10] "tBodyGyro.mean...X"          "tBodyGyro.mean...Y"          "tBodyGyro.mean...Z"         
[13] "tBodyGyroJerk.mean...X"      "tBodyGyroJerk.mean...Y"      "tBodyGyroJerk.mean...Z"     
[16] "tBodyAccMag.mean.."          "tGravityAccMag.mean.."       "tBodyAccJerkMag.mean.."     
[19] "tBodyGyroMag.mean.."         "tBodyGyroJerkMag.mean.."     "fBodyAcc.mean...X"          
[22] "fBodyAcc.mean...Y"           "fBodyAcc.mean...Z"           "fBodyAccJerk.mean...X"      
[25] "fBodyAccJerk.mean...Y"       "fBodyAccJerk.mean...Z"       "fBodyGyro.mean...X"         
[28] "fBodyGyro.mean...Y"          "fBodyGyro.mean...Z"          "fBodyAccMag.mean.."         
[31] "fBodyBodyAccJerkMag.mean.."  "fBodyBodyGyroMag.mean.."     "fBodyBodyGyroJerkMag.mean.."
[34] "tBodyAcc.std...X"            "tBodyAcc.std...Y"            "tBodyAcc.std...Z"           
[37] "tGravityAcc.std...X"         "tGravityAcc.std...Y"         "tGravityAcc.std...Z"        
[40] "tBodyAccJerk.std...X"        "tBodyAccJerk.std...Y"        "tBodyAccJerk.std...Z"       
[43] "tBodyGyro.std...X"           "tBodyGyro.std...Y"           "tBodyGyro.std...Z"          
[46] "tBodyGyroJerk.std...X"       "tBodyGyroJerk.std...Y"       "tBodyGyroJerk.std...Z"      
[49] "tBodyAccMag.std.."           "tGravityAccMag.std.."        "tBodyAccJerkMag.std.."      
[52] "tBodyGyroMag.std.."          "tBodyGyroJerkMag.std.."      "fBodyAcc.std...X"           
[55] "fBodyAcc.std...Y"            "fBodyAcc.std...Z"            "fBodyAccJerk.std...X"       
[58] "fBodyAccJerk.std...Y"        "fBodyAccJerk.std...Z"        "fBodyGyro.std...X"          
[61] "fBodyGyro.std...Y"           "fBodyGyro.std...Z"           "fBodyAccMag.std.."          
[64] "fBodyBodyAccJerkMag.std.."   "fBodyBodyGyroMag.std.."      "fBodyBodyGyroJerkMag.std.." 
```

To make our dataset more readable, we want each column to adhere to snake_case, and expand dimensions `t` and `f` to `time` and `freq`.
```R
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
```

Now when we run `names(data_merged)` again, we see our new snake-case variable names:
```R
 [1] "activity"                     "time_body_acc_mean_x"         "time_body_acc_mean_y"        
 [4] "time_body_acc_mean_z"         "time_grav_acc_mean_x"         "time_grav_acc_mean_y"        
 [7] "time_grav_acc_mean_z"         "time_body_acc_jerk_mean_x"    "time_body_acc_jerk_mean_y"   
[10] "time_body_acc_jerk_mean_z"    "time_body_gyro_mean_x"        "time_body_gyro_mean_y"       
[13] "time_body_gyro_mean_z"        "time_body_gyro_jerk_mean_x"   "time_body_gyro_jerk_mean_y"  
[16] "time_body_gyro_jerk_mean_z"   "time_body_acc_mag_mean"       "time_grav_acc_mag_mean"      
[19] "time_body_acc_jerk_mag_mean"  "time_body_gyro_mag_mean"      "time_body_gyro_jerk_mag_mean"
[22] "freq_body_acc_mean_x"         "freq_body_acc_mean_y"         "freq_body_acc_mean_z"        
[25] "freq_body_acc_jerk_mean_x"    "freq_body_acc_jerk_mean_y"    "freq_body_acc_jerk_mean_z"   
[28] "freq_body_gyro_mean_x"        "freq_body_gyro_mean_y"        "freq_body_gyro_mean_z"       
[31] "freq_body_acc_mag_mean"       "freq_body_acc_jerk_mag_mean"  "freq_body_gyro_mag_mean"     
[34] "freq_body_gyro_jerk_mag_mean" "time_body_acc_std_x"          "time_body_acc_std_y"         
[37] "time_body_acc_std_z"          "time_grav_acc_std_x"          "time_grav_acc_std_y"         
[40] "time_grav_acc_std_z"          "time_body_acc_jerk_std_x"     "time_body_acc_jerk_std_y"    
[43] "time_body_acc_jerk_std_z"     "time_body_gyro_std_x"         "time_body_gyro_std_y"        
[46] "time_body_gyro_std_z"         "time_body_gyro_jerk_std_x"    "time_body_gyro_jerk_std_y"   
[49] "time_body_gyro_jerk_std_z"    "time_body_acc_mag_std"        "time_grav_acc_mag_std"       
[52] "time_body_acc_jerk_mag_std"   "time_body_gyro_mag_std"       "time_body_gyro_jerk_mag_std" 
[55] "freq_body_acc_std_x"          "freq_body_acc_std_y"          "freq_body_acc_std_z"         
[58] "freq_body_acc_jerk_std_x"     "freq_body_acc_jerk_std_y"     "freq_body_acc_jerk_std_z"    
[61] "freq_body_gyro_std_x"         "freq_body_gyro_std_y"         "freq_body_gyro_std_z"        
[64] "freq_body_acc_mag_std"        "freq_body_acc_jerk_mag_std"   "freq_body_gyro_mag_std"      
[67] "freq_body_gyro_jerk_mag_std" 
```

#### Step 5: Create an independent tidy dataset with the average of each variable for each activity and each subject
From README.txt in the data directory, we learn that the training and test subject IDs are stored in train/subject_train.txt and test/subject_test.txt respectively. As before, we read those sets into variables and merge them into `subject_merged` with 'subject' as the variable name.
```R
subject_train <- read.table(paste0(data_dir, "/train/subject_train.txt"))
subject_test <- read.table(paste0(data_dir, "/test/subject_test.txt"))
subject_merged <- bind_rows(subject_train, subject_test)
names(subject_merged) <- "subject"
```
Next, we create our tidy dataset through a series of `dplyr` pipes. First we merge `subject_merged` and `data_merged` column-wise, then we do a `group_by` and `summarize_each` to find the means of each variable per subject per activity.
```r
data_tidy <- subject_merged %>% 
             bind_cols(data_merged) %>%
             group_by(subject, activity) %>% 
             summarize_each(funs(mean))
```

Finally, we write `data_tidy` to a text file named tidy.txt, which you can find [here](https://github.com/clampork/coursera-datascience/blob/3-getting-and-cleaning-data/project/tidy.txt).
```R
write.table(data_tidy, "tidy.txt", quote = FALSE)
```
