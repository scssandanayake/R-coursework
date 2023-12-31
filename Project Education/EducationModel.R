library(caTools)
library(ROCR)
library(dplyr)
library(caret)

dataset <- read.csv("C:\\Users\\Gosisa Jinasena\\Desktop\\R Project Education\\Education Viz\\HR_Analytics.csv")

summary(dataset)

# Data Cleaning & Data Preprocessing

dataset <- dataset %>%
  mutate(Attrition = ifelse(Attrition == "No",0,1))

# Splitting Dataset

set.seed(123)
split <- sample.split(dataset, SplitRatio = 0.7) 
split

train_reg <- subset(dataset, split == "TRUE")
test_reg <- subset(dataset, split == "FALSE")

# Training Model

logistic_model <- glm(Attrition ~ MonthlyIncome + Education,
                      data = train_reg,
                      family = "binomial")
logistic_model

# Summary

summary(logistic_model)

predict_reg <- predict(logistic_model,
                       test_reg, type = "response")
predict_reg


# Changing probabilities for prediction

predict_reg <- ifelse(predict_reg >0.5, 1, 0)

# Keep probabilities for ROC curve

predict1_reg <- predict(logistic_model, test_reg, type = "response")


# Evaluating model accuracy using confusion matrix

confusion_matrix <-table(test_reg$Attrition, predict_reg)
print(confusion_matrix)

missing_classerr <- mean(predict_reg != test_reg$Attrition)
print(paste('Accuracy =', 1 - missing_classerr))

contable <- confusionMatrix(as.factor(predict_reg), as.factor(test_reg$Attrition))
print(contable)



# ROC-AUC Curve

ROCPred <- prediction(predict1_reg, test_reg$Attrition)
ROCPer <- performance(ROCPred, measure = "tpr",
                      x.measure = "fpr")

auc <- performance(ROCPred, measure = "auc")
auc <- auc@y.values[[1]]
auc

# Plotting curve

plot(ROCPer)
plot(ROCPer, colorize = TRUE, 
     print.cutoffs.at = seq(0.1, by = 0.1),
      main = "ROC CURVE")
abline(a = 0, b = 1)

auc <- round(auc, 4)
legend(.6, .4, auc, title = "AUC", cex = 1)

