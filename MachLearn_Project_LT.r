setwd("C:/Users/thomlo02/Documents/R SCripts")
rm(list=ls())

library(lattice)
library(ggplot2)
library(caret)
library(rpart)
library(RGtk2)
library(rattle)
library(rpart.plot)

data<-read.csv("pml-training.csv", header = TRUE)

#Create a new data (raw data) set with just the raw data variables (no max, avg, etc.)
#Only grab variables that start with roll, pitch, yaw, total, gyros, accel, magnet, include classe
roll<-grep("^roll",colnames(data), value = TRUE)
pitch<-grep("^pitch",colnames(data), value=TRUE)
yaw<-grep("^yaw",colnames(data), value=TRUE)
total<-grep("^total",colnames(data), value=TRUE)
gyros<-grep("^gyros",colnames(data), value=TRUE)
accel<-grep("^accel",colnames(data), value=TRUE)
magnet<-grep("^magnet",colnames(data), value=TRUE)
classe<-data$classe
rawdata<-data.frame(data[,roll],data[,pitch],data[,yaw],data[,total],data[,gyros],data[,accel],
                    data[,magnet],classe)

#Create training and testing sets 
set.seed(12345)
inTrain<-createDataPartition(y=rawdata$classe, p=.75, list=FALSE)
training<-rawdata[inTrain,]
testing<-rawdata[-inTrain,]



#Create a decision tree using rpart
#control=rpart.control(minsplit=30, cp=0.001) requires that the minimum number 
#of observations in a node be 30 before attempting a split and that a split must 
#decrease the overall lack of fit by a factor of 0.001 (cost complexity factor) 
#before being attempted.
tree1 <- rpart(classe ~ . ,method="class", data=training, control=rpart.control(minsplit=30, cp=0.001))
printcp(tree) # display the results 
plotcp(tree) # visualize cross-validation results 
summary(tree) # detailed summary of splits

#Use all of given training set csv raw data
tree2 <- rpart(classe ~ . ,method="class", data=rawdata, control=rpart.control(minsplit=30, cp=0.001))
printcp(tree) # display the results 

# plot tree 
#plot(fit, uniform=TRUE, 
#     main="Classification Tree")
#text(fit, use.n=TRUE, all=TRUE, cex=.8)
fancyRpartPlot(tree1,main="Classification Tree1")
fancyRpartPlot(tree2,main="Classification Tree2")

#prune the tree
#automatically select the complexity parameter associated 
#with the smallest cross-validated error
ptree1<- prune(tree1, cp=   tree1$cptable[which.min(tree1$cptable[,"xerror"]),"CP"])
ptree2<- prune(tree2, cp=   tree2$cptable[which.min(tree2$cptable[,"xerror"]),"CP"])

# plot the pruned tree 
#plot(pfit, uniform=TRUE, 
#     main="Pruned Classification Tree")
#text(pfit, use.n=TRUE, all=TRUE, cex=.8)
fancyRpartPlot(ptree1, main="Pruned Classification Tree1")
fancyRpartPlot(ptree1, main="Pruned Classification Tree2")

#Analsis of results for training set within given "training csv"
prediction1<-predict(ptree1,newdata=training, type='class')
confusion1<-confusionMatrix(prediction1, training$classe)
print(confusion1)

#Analysis of results for testing set data within given "training csv"
prediction2<-predict(ptree1,newdata=testing, type='class')
confusion2<-confusionMatrix(prediction2, testing$classe)
print(confusion2)


#Analysis of reulsts using entire training csv
prediction3<-predict(ptree2,newdata=rawdata, type='class')
confusion3<-confusionMatrix(prediction3, rawdata$classe)
print(confusion3)


pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

data_testset<-read.csv("pml-testing.csv", header = TRUE)
#Create a new data (raw data_testset) set with just the raw data variables (no max, avg, etc.)
#Only grab variables that start with roll, pitch, yaw, total, gyros, accel, magnet, include classe
roll_testset<-grep("^roll",colnames(data_testset), value = TRUE)
pitch_testset<-grep("^pitch",colnames(data_testset), value=TRUE)
yaw_testset<-grep("^yaw",colnames(data_testset), value=TRUE)
total_testset<-grep("^total",colnames(data_testset), value=TRUE)
gyros_testset<-grep("^gyros",colnames(data_testset), value=TRUE)
accel_testset<-grep("^accel",colnames(data_testset), value=TRUE)
magnet_testset<-grep("^magnet",colnames(data_testset), value=TRUE)

rawdata_testset<-data.frame(data_testset[,roll],data_testset[,pitch],data_testset[,yaw],data_testset[,total],data_testset[,gyros],data_testset[,accel],
                            data_testset[,magnet])

prediction_tree1_testset<-predict(ptree1,newdata=rawdata_testset, type='class')
print(prediction_tree1_testset)
prediction_tree2_testset<-predict(ptree2,newdata=rawdata_testset, type='class')
print(prediction_tree2_testset)
#pml_write_files(prediction_tree1_testset)
#pml_write_files(prediction_tree2_testset)
#See CourseraProject_ML_LT.RMD
