# this code reads textfiles for the course assignment and merges them into one data file and creates a tidy data set
library(data.table)
library(gdata)
library(stringr)
library(plyr)

#read files
myPath<-"C:\\Users\\Gloria\\ProgrammingAssignment3\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\"
test<-read.table(paste(myPath,"test\\X_test.txt",sep=''))
testlab<-read.table(paste(myPath,"test\\Y_test.txt",sep=''))
subtest<-read.table(paste(myPath,"test\\subject_test.txt",sep=''))

train<-as.data.frame(read.table(paste(myPath,"train\\X_train.txt",sep='')))
trainlab<-read.table(paste(myPath,"train\\Y_train.txt",sep=''))
subtrain<-read.table(paste(myPath,"train\\subject_train.txt",sep=''))

features<-read.table(paste(myPath,"features.txt",sep=""))

#merge files together & labels them
combinedData<-as.data.frame(rbind(test,train))
dimnames(combinedData)[[2]]<-features$V2
combinedData<-combinedData[,grep("mean\\(|std",names(combinedData))]
names(combinedData)<-str_replace(names(combinedData),"\\(","")
names(combinedData)<-str_replace(names(combinedData),"\\)","")
combinedData$label<-rbind(testlab,trainlab)$V1
combinedData$subject<-rbind(subtest,subtrain)$V1
actlab<-read.table(paste(myPath,"activity_labels.txt",sep=""))
dimnames(actlab)[[2]]<-c("label","activity")
actlab<-as.data.table(actlab);setkey(actlab,label);
combinedData<-as.data.table(combinedData);setkey(combinedData,label)
combinedData<-merge(combinedData,actlab)

# aggregrates the data by subject and activity
tidyData<-aggregate(subset(combinedData, select=c(1:66)),by=list(subject=combinedData$subject,activity=combinedData$activity),FUN=mean,na.rm=TRUE)
write.table(tidyData,paste(myPath,"tidyData.txt",sep=""),row.name=FALSE)
