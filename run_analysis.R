## read the txt. files
features <- read.table("features.txt")
Xtest <- read.table("test\\X_test.txt")
Ytest <- read.table("test\\Y_test.txt")
SubjectTest <- read.table("test\\subject_test.txt")
Xtrain <- read.table("train\\X_train.txt")
Ytrain <- read.table("train\\Y_train.txt")
SubjectTrain<- read.table("train\\subject_train.txt")

## create one tidy data set
colunam <- features[,2]
colnames(Xtest) <- colunam
colnames(Xtrain)<- colunam
colnames(Ytest)<- "activityID"
colnames(Ytrain) <- "activityID"
colnames(SubjectTest)<- "subjectID"
colnames(SubjectTrain)<- "subjectID"
TestDat <- cbind(Ytest, SubjectTest, Xtest)
TrainDat <- cbind(Ytrain, SubjectTrain, Xtrain)
AllDat <- rbind(TrainDat, TestDat)

## Extracts only the measurements on the mean and standard deviation for each measurement.
Logigcolunam <- ((grepl("-mean", colunam) & !grepl("-meanFreq", colunam)) | grepl("-std", colunam))
colunam <- c("TRUE", "TRUE", Logigcolunam)
MeaSdDat<- AllDat[colunam == TRUE]

## name the activities in the data set
activity_labels <- read.table("activity_labels.txt")
colnames(activity_labels) <-  c("activityID","activityType")
AllDatNam <- merge(activity_labels, MeaSdDat, by = "activityID")
AllDatNam <- AllDatNam[,names(AllDatNam) != "activityID"]

## descriptive variable names.
names(AllDatNam) <- gsub("^t", "Time", names(AllDatNam))
names(AllDatNam) <- gsub("^f", "Frequency", names(AllDatNam))
names(AllDatNam) <- gsub("Acc", "Acceleration", names(AllDatNam))
names(AllDatNam) <- gsub("Mag", "Magnitude", names(AllDatNam))
names(AllDatNam) <- gsub("Gyro", "Gyroscope", names(AllDatNam))

## independent tidy data set with the average of each variable for each activity and each subject.
colunam <- colnames(AllDatNam)
AllDatNam <- aggregate(AllDatNam[3:68], by = list(AllDatNam$activityType, AllDatNam$subjectID), FUN = mean)
colnames(AllDatNam) <- colunam
## creat a new file with the tidy data.
write.table(AllDatNam, "AllDatNam.txt", row.names = FALSE)

