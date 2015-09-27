# Machine-Learning-Project2

#Coursera Project

#Introduction:
At the beginning of this project, I read the article (http://groupware.les.inf.puc-rio.br/har) provided. I wanted to familiarize myself with the study and truly understand what each of the variable in question represented. My motivation for taking this course stems from an interest in Decision Trees and how to build them. I had very little experience in using Decision Tree algorithms prior to this class, and I selected a Decision Tree model to complete this project in order to develop my knowledge base. It should be noted that there are many different ways to conduct this study as well as different predicting techniques (regression, categorical analysis, etc.), but for the sake of my project I decided to proceed with the Decision Tree model. 

#Understanding the Data:
My first step in using a tree to predict classe was to understand what variable would be used in predicting. It is my understanding that this is called Featured Selection. There were many variables (160 to be exact) to choose from at the onset of this project. In order to simplify, I decided to only use the “raw” data inputs and no maximum, minimum, or average values of these inputs. I cleaned the data set and only used 52 of the given 160 variables. These variables can be seen in the images attached to this report. 

#Model Creation:
When I first created a Decision Tree model, I used the training csv given from the website. Within this training set, I created my own test set and training set. I used the sub-training set to create the tree validated the results. The tree performed at a 92% accuracy rate when sub training set was run through the model. I then tested the tree (created using the sub-training set), and the predictions were 90% accurate. I then created an additional tree using all the data available in the training data set (not sub-splitting the given training csv into a training set and test set). The tree that was created was 91% accurate when I ran the training csv data through it. 

#Model Evaluation:
Once I had both trees build (one created using a subset of the training csv and one created using the entire training csv), I applied the model to the provided test set. First, I had to clean up the test set in order to only use the variable I first selected in the “Understanding the Data” section. This means I had to ensure the 20 test observations had the same 52 variables I used in my decision tree for prediction. 
I first submitted my results based on the sub-training created tree. This tree correctly identified 16 of the 20 observations. Then, I submitted the result from the second tree I created. This tree correctly identified 18 of the 20 observations.


#Conclusions:
I believe a better tree could be created given more time and data analysis. This project was a great way to introduce myself to a decision tree model, and I am thankful for the opportunity to explore this topic more. 


Code:
library(lattice)
library(ggplot2)
library(caret)
library(rpart)
library(RGtk2)
library(rattle)
library(rpart.plot)

data<-read.csv("pml-training.csv", header = TRUE)

Create a new data (raw data) set with just the raw data variables (no max, avg, etc.)
Only grab variables that start with roll, pitch, yaw, total, gyros, accel, magnet, include classe
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

Create training and testing sets 
set.seed(12345)
inTrain<-createDataPartition(y=rawdata$classe, p=.75, list=FALSE)
training<-rawdata[inTrain,]
testing<-rawdata[-inTrain,]



Create a decision tree using rpart
control=rpart.control(minsplit=30, cp=0.001) requires that the minimum number 
of observations in a node be 30 before attempting a split and that a split must 
decrease the overall lack of fit by a factor of 0.001 (cost complexity factor) 
before being attempted.
tree <- rpart(classe ~ . ,method="class", data=training, control=rpart.control(minsplit=30, cp=0.001))
printcp(tree) # display the results 
plotcp(tree) # visualize cross-validation results 
summary(tree) # detailed summary of splits

Use all of given training set csv raw data
tree <- rpart(classe ~ . ,method="class", data=rawdata, control=rpart.control(minsplit=30, cp=0.001))
printcp(tree) # display the results 

plot tree 
plot(fit, uniform=TRUE, 
     main="Classification Tree")
text(fit, use.n=TRUE, all=TRUE, cex=.8)
fancyRpartPlot(tree,main="Classification Tree")

prune the tree
automatically select the complexity parameter associated 
with the smallest cross-validated error
ptree<- prune(tree, cp=   tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"])

 plot the pruned tree 
plot(pfit, uniform=TRUE, 
     main="Pruned Classification Tree")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)
fancyRpartPlot(ptree)

Analsis of results for training set within given "training csv"
prediction<-predict(ptree,newdata=training, type='class')
confusion<-confusionMatrix(prediction, training$classe)
print(confusion)

Analsis of results for training set within given "training csv"
predictiontrial<-predict(ptree,newdata=testing, type='class')
confusion<-confusionMatrix(predictiontrial, testing$classe)
print(confusion)

Analysis of reulsts using entire training csv
predictiontrial<-predict(ptree,newdata=rawdata, type='class')
confusion<-confusionMatrix(predictiontrial, rawdata$classe)
print(confusion)


pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

data_testset<-read.csv("pml-testing.csv", header = TRUE)
Create a new data (raw data_testset) set with just the raw data variables (no max, avg, etc.)
Only grab variables that start with roll, pitch, yaw, total, gyros, accel, magnet, include classe
roll_testset<-grep("^roll",colnames(data_testset), value = TRUE)
pitch_testset<-grep("^pitch",colnames(data_testset), value=TRUE)
yaw_testset<-grep("^yaw",colnames(data_testset), value=TRUE)
total_testset<-grep("^total",colnames(data_testset), value=TRUE)
gyros_testset<-grep("^gyros",colnames(data_testset), value=TRUE)
accel_testset<-grep("^accel",colnames(data_testset), value=TRUE)
magnet_testset<-grep("^magnet",colnames(data_testset), value=TRUE)

rawdata_testset<-data.frame(data_testset[,roll],data_testset[,pitch],data_testset[,yaw],data_testset[,total],data_testset[,gyros],data_testset[,accel],
                            data_testset[,magnet])

prediction_testset<-predict(ptree,newdata=rawdata_testset, type='class')

pml_write_files(prediction_testset)
