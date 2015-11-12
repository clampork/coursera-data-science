## Code Book
This code book describes the data found in [tidy.txt](https://github.com/clampork/coursera-datascience/blob/3-getting-and-cleaning-data/project/tidy.txt), the cleaned output dataset from the Getting and Cleaning Data [Course Project](https://github.com/clampork/coursera-datascience/tree/3-getting-and-cleaning-data/project). The dataset contains 180 observations of the average value for each of 66 features, across each activity for each subject. In this document, you will find details for each of the variables in the cleaned dataset, along with all the transformations it underwent from the original raw data.

#### Original dataset
The original dataset was collected from experiments carried out amongst a group of 30 volunteers, each performing six different activities while wearing a Samsung Galaxy S II smartphone on their person. A full description of the study may be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), and the dataset may be downloaded directly from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

#### Dataset variables
The first variable `subject` records the subject ID for each of the 30 subjects, while the second variable `activity` records the experiment activity for each subject. Subjects performed 6 different activities as follows:

| Activity ID | Activity           |
| :---------- | :----------------  |
| 1           | WALKING            |
| 2           | WALKING_UPSTAIRS   |
| 3           | WALKING_DOWNSTAIRS |
| 4           | SITTING            |
| 5           | STANDING           |
| 6           | LAYING             |

The remaining variables record the average value of the mean and standard deviation of each feature, across each activity for each subject. Observations of each feature from the original dataset had already been normalized, so observations in the cleaned dataset which are average values of the original dataset are likewise unitless. 

Features are named according to the following naming convention:

| Category            | Possible values | Description                    |
| :------------------ | :-------------- | :----------------------------- |
| Domain signal       | `time`          | Time domain signal             |
| Domain signal       | `freq`          | Frequency domain signal        |
| Acceleration signal | `body`          | Body acceleration signal       |
| Acceleration signal | `grav`          | Gravity acceleration signal    |
| Instrument          | `acc`           | Accelerometer                  |
| Instrument          | `gyro`          | Gyroscope                      |
| Derived signal      | `jerk`          | Jerk signal                    |
| Statistical         | `mag`           | Magnitude using Euclidean norm |
| Statistical         | `mean`          | Mean                           |
| Statistical         | `std`           | Standard deviation             |
| Axial signal        | `x`             | X-direction                    |
| Axial signal        | `y`             | Y-direction                    |
| Axial signal        | `z`             | Z-direction                    |

For example, the first feature `time_body_acc_mean_x` represents the average mean of time domain signals for body acceleration along an X-direction.

#### Dataset transformations
[tidy.txt](https://github.com/clampork/coursera-datascience/blob/3-getting-and-cleaning-data/project/tidy.txt) is the output of [run_analysis.R](https://github.com/clampork/coursera-datascience/blob/3-getting-and-cleaning-data/project/run_analysis.R), an R script that transforms the original dataset through the following steps:

| Step | Intermediate data frames | Description                                                             |
| :--- | :----------------------- | :---------------------------------------------------------------------- |
| 1a   | `x_merged`               | Merge the training and test sets to create one dataset                  |
| 1b   | `x_merged`               | Label dataset variables with appropriate feature names                  |
| 2    | `x_subset`               | Extract only mean and standard deviation measurements for each variable |
| 3a   | `y_merged`               | Join descriptive activity names to y datasets                           | 
| 3b   | `data_merged`            | Use descriptive activity names to name the activities in the dataset    |
| 4    | `data_merged`            | Appropriately label the dataset with descriptive variable names         |
| 5a   | `subject_merged`         | Merge subject data into dataset                                         |
| 5b   | `data_tidy`              | Create an independent tidy dataset and write output to file             |

For more details on how the script works, see the README file [here](https://github.com/clampork/coursera-datascience/blob/3-getting-and-cleaning-data/project/README.md).
