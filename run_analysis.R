setwd("C:\\Users\\akhilendrapratap\\Documents\\Data science notes\\R Course\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test")


#create two data frame for test files
xtest<-read.table("x_test.txt",header=FALSE)
ytest<-read.table("y_test.txt",header=FALSE)
subtest<-read.table("subject_test.txt",header=FALSE)



setwd("C:\\Users\\akhilendrapratap\\Documents\\Data science notes\\R Course\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train")

xtrain<- read.table("x_train.txt",header=FALSE)
ytrain<- read.table("y_train.txt",header=FALSE)
subtrain<-read.table("subject_train.txt",header=FALSE)



setwd("C:\\Users\\akhilendrapratap\\Documents\\Data science notes\\R Course\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset")


meansd<-read.table("features.txt",header=FALSE)
labels<- read.table("activity_labels.txt",header=FALSE)

# Assigin column names to the Train data
colnames(labels)  <-c('activityId','Activitytype')
colnames(subtrain)<-"subjectId"
colnames(xtrain)<- meansd[,2]
colnames(ytrain)<- "activityId";
colnames(meansd)<- c('Serial #','Variable')

# Assigin column names to the Test Data
colnames(subtest) = "subjectId"
colnames(xtest)       = meansd[,2] 
colnames(ytest)       = "activityId"


xmerge<- cbind(subtest,ytest,xtest)
ymerge<-cbind(subtrain,ytrain,xtrain)


finalmerge<- rbind(ymerge,xmerge)



# correct names in the finalmerge,Uses descriptive activity names to name the activities in the data set

corrnames<-colnames(finalmerge)

for (i in 1:length(corrnames)) 
{
  corrnames[i] = gsub("\\()","",corrnames[i])
  corrnames[i] = gsub("-std$","StdDev",corrnames[i])
  corrnames[i] = gsub("-mean","Mean",corrnames[i])
  corrnames[i] = gsub("^(t)","time",corrnames[i])
  corrnames[i] = gsub("^(f)","freq",corrnames[i])
  corrnames[i] = gsub("([Gg]ravity)","Gravity",corrnames[i])
  corrnames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",corrnames[i])
  corrnames[i] = gsub("[Gg]yro","Gyro",corrnames[i])
  corrnames[i] = gsub("AccMag","AccMagnitude",corrnames[i])
  corrnames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",corrnames[i])
  corrnames[i] = gsub("JerkMag","JerkMagnitude",corrnames[i])
  corrnames[i] = gsub("GyroMag","GyroMagnitude",corrnames[i])
}

colnames(finalmerge)<-corrnames

# extract mean and standard values
library(plyr)

extracteddata<-grep("-(mean|std)\\(\\)", meansd[, 2])

finalmerge<-finalmerge[, extracteddata]

# Appropriately labels the data set with descriptive variable names

finalmerge = merge(finalmerge,labels, by.x='activityId', by.y='activityId',all.x=TRUE)

# Create a tidy dataset without the activityType column
newtidy <- ddply(finalmerge, .(subjectId, activityId), function(x) colMeans(x[, 1:66]))
write.table(newtidy, "newtidy.txt", row.name=FALSE)
