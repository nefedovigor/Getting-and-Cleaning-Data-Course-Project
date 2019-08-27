library(dplyr)
library(readr)

# STEP 0. reading data files

# creating paths for reading test files
X_test_path <- file.path("UCI HAR Dataset", "test", "X_test.txt")
y_test_path <- file.path("UCI HAR Dataset", "test", "y_test.txt")
subject_test_path <- file.path("UCI HAR Dataset", "test", "subject_test.txt")

# creating paths for reading train files
X_train_path <- file.path("UCI HAR Dataset", "train", "X_train.txt")
y_train_path <- file.path("UCI HAR Dataset", "train", "y_train.txt")
subject_train_path <- file.path("UCI HAR Dataset", "train", "subject_train.txt")

# creating paths for reading features and activity labels
features_path <- file.path("UCI HAR Dataset", "features.txt")
activity_labels_path <- file.path("UCI HAR Dataset", "activity_labels.txt")

# reading test files: measurments; activities, subjects
X_test <- read_table(X_test_path, col_names = FALSE)
y_test <- read_table(y_test_path, col_names = FALSE)
subject_test <- read_table(subject_test_path, col_names = FALSE)

# reading train files: measurments; activities, subjects
X_train <- read_table(X_train_path, col_names = FALSE)
y_train <- read_table(y_train_path, col_names = FALSE)
subject_train <- read_table(subject_train_path, col_names = FALSE)


# STEP 1. Merging the training and the test sets to create one data set
sensor_data_test <- cbind(subject_test, y_test, X_test)
sensor_data_train <- cbind(subject_train, y_train, X_train)
sensor_data_raw <- rbind(sensor_data_test, sensor_data_train)


# STEP 4. Appropriately labels the data set with descriptive variable names.

# reading features file with variable names
features_table <- read_table(features_path, col_names = FALSE)

# creating vector from it and cleaning it
features_vect <-  features_table[[1]]
features_vect <- gsub("-mean[()]+", "-mean", features_vect)
features_vect <- gsub("-std[()]+", "-st-deviation", features_vect)
features_vect <- gsub("\\s", "-", features_vect)

# adding headers to data frame         
colnames(sensor_data_raw) <- c("subject_id", "activity_id", features_vect)


# STEP 2. Extracting only the measurements on the mean and standard deviation for each measurement.
# STEP 3. Using descriptive activity names to name the activities in the data set

# first reading the table with activity labels
activity_labels_table <- read_table(activity_labels_path, col_names = FALSE)


tidy_sensor_data <- sensor_data_raw %>%
        # using "cut" function to add activity labels
        mutate(activity = cut(activity_id, breaks = c(0, activity_labels_table[[1]]),
                              labels = activity_labels_table[[2]])) %>%
        
        # selecting columns with mean and standart deviation using
        # "contains" function
        select(subject_id, activity, contains("-mean", ignore.case = TRUE),
               contains("-st-deviation", ignore.case = TRUE))


# STEP 5. Creating a second, independent tidy data set with the average of each
# variable for each activity and each subject

summary_sensor_data <- tidy_sensor_data %>%
        group_by(subject_id, activity) %>%
        summarise_all(mean)

write.table(summary_sensor_data, file = "summary_data.txt")


# removing all unnecessary variables
rm("activity_labels_path", "activity_labels_table", "features_path", "features_table",
   "features_vect", "sensor_data_raw", "sensor_data_test",
   "sensor_data_train", "subject_test",  "subject_test_path", "subject_train",
   "subject_train_path", "X_test", "X_test_path", "X_train", "X_train_path", "y_test",
   "y_test_path", "y_train", "y_train_path")




