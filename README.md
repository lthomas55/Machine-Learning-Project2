# Machine-Learning-Project2

#Coursera Project

#Please Note
I am new to GitHub and this was hard to figure out my first time. For the output, please copy and paste the listed html site in the HTML file

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

