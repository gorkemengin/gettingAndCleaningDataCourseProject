# Merges the training and the test sets to create one data set.

        test_label     <- read.table("test/y_test.txt", col.names="label")
        test_subject   <- read.table("test/subject_test.txt", col.names="subject")
        test_data      <- read.table("test/X_test.txt")
        train_label    <- read.table("train/y_train.txt", col.names="label")
        train_subject  <- read.table("train/subject_train.txt", col.names="subject")
        train_data     <- read.table("train/X_train.txt")
        
        data <- rbind( cbind(test_subject, test_label, test_data),
                       cbind(train_subject, train_label, train_data) )
        
# Extracts only the measurements on the mean and standard deviation for each measurement. 

        features                <- read.table("features.txt", strip.white = TRUE, stringsAsFactors = FALSE)
        features_mean_std       <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
        data_mean_std           <- data[, c(1, 2, features_mean_std$V1+2)]
        
# Uses descriptive activity names to name the activities in the data set

        labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
        data_mean_std$label <- labels[data_mean_std$label, 2]
        
# Appropriately labels the data set with descriptive variable names. 

        old_colnames <- c("subject", "label", features_mean_std$V2)
        new_colnames <- tolower(gsub("[^[:alpha:]]", "", old_colnames))
        colnames(data_mean_std) <- new_colnames
        
# From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
        
        aggr_data <- aggregate(data_mean_std[, 3:ncol(data_mean_std)],
                               by = list(subject = data_mean_std$subject, label = data_mean_std$label),
                               mean)
        
        write.table(format(aggr_data, scientific=T), "tidydata.txt", row.names=F, col.names=F, quote=2)