
install.packages("C50")
library(C50)

install.packages("gmodels")
library(gmodels)


unsafe <-  read.csv("S:\\Office of Risk Management\\User Folders\\Darius Mehri\\Facade Predictive Analysis\\FACADE ANALYSIS DEC TREE 5.csv", sep=",", header=T)

names(unsafe)

summary(unsafe)

#only analyze private buildings
unsafe<-unsafe[!(unsafe$Public==1),]



#create new columns for elevetor and office buildings
unsafe$ElevatorBuilding <- ifelse(unsafe$BldgClassAgg=="D", "1", 0) 
unsafe$OfficeBuilding <- ifelse(unsafe$BldgClassAgg=="O", "1", 0) 

unsafe$FrontSurfaceArea = unsafe$BldgFront * 9 *unsafe$NumFloors




#unsafe <-  unsafe[,c('Status','NumFloors','BldgFront','Age','AssessTotal', 'Landmark2', 'OwnerType') ]
#unsafe <-  unsafe[,c('Status','NumFloors','BldgFront','Age','AssessTotal', 'Landmark2', 'Public') ]

#unsafe <-  unsafe[,c('Status','NumFloors','BldgFront','Age','AssessTotal', 'Landmark2') ]

#unsafe <-  unsafe[,c('Status','NumFloors','BldgFront','Age','AssessTotal', 'Public') ]

#unsafe <-  unsafe[,c('Status','NumFloors','BldgFront','Age', 'AssessTotal', 'Public', 'Rent.Stabalized', 'Violations') ]

#public and private
#model 1
unsafe <-  unsafe[,c('Status','BldgFront','Age','Violations','Public','AssessTotal', 'NumFloors', 'Complaints') ]

#model 2
unsafe <-  unsafe[,c('Status','BldgFront','Age','Public','AssessTotal', 'NumFloors', 'Complaints') ]

#model 2b
unsafe <-  unsafe[,c('Status','BldgFront','Age','Public', 'NumFloors', 'Complaints') ]

#model 2c
unsafe <-  unsafe[,c('Status','BldgFront','Age','Public', 'NumFloors') ]

#model 2d
unsafe <-  unsafe[,c('Status','AssessTotal', 'BldgFront', 'Age' ) ]

#model 2e
unsafe <-  unsafe[,c('Status','AssessTotal', 'BldgFront','Age', 'NumFloors' ) ]

#model 2f, with pulic
unsafe <-  unsafe[,c('Status','AssessTotal', 'BldgFront','Age', 'NumFloors', 'Public', 'Complaints' ) ]




#model 3, w wall surface area
unsafe <-  unsafe[,c('Status','Age','Public','AssessTotal', 'WallSurfaceArea', 'Complaints') ]

#model 4, w wall surface area
unsafe <-  unsafe[,c('Status','Age','Public','AssessTotal', 'Complaints') ]

#model 5, old model
unsafe <-  unsafe[,c('Status','BldgFront','Age','Public','AssessTotal', 'NumFloors', 'Complaints') ]

#model 6, no complaints
unsafe <-  unsafe[,c('Status','BldgFront','Age','Public','AssessTotal', 'NumFloors') ]

#model 7, only building characteristics
unsafe <-  unsafe[,c('Status','BldgFront','Age','AssessTotal', 'NumFloors') ]

#model 8, with wall surface area
unsafe <-  unsafe[,c('Status','WallSurfaceArea','Age','AssessTotal') ]


#public
#model 1
unsafe <-  unsafe[,c('Status','BldgFront','Age','Violations','AssessTotal', 'NumFloors') ]

#model 2
unsafe <-  unsafe[,c('Status','BldgFront','Age','AssessTotal', 'NumFloors') ]

#model 3
unsafe <-  unsafe[,c('Status','BldgFront','Age','AssessTotal') ]



#unsafe <-  unsafe[,c('Status','BldgFront','Age','Violations','Public') ]

unsafe <- na.omit(unsafe)




names(unsafe)
unsafe$Status <- as.factor(unsafe$Status)
#unsafe$Public <- as.factor(unsafe$Public)
#unsafe$Rent.Stabalized <- as.factor(unsafe$Rent.Stabalized)
#unsafe$OfficeBuilding <- as.factor(unsafe$OfficeBuilding)
#unsafe$ElevatorBuilding <- as.factor(unsafe$ElevatorBuilding)



#unsafe$Status <- as.factor(unsafe$Status)


table(unsafe$Status)


#CREATE TRAINING DATASET:
#create random sample object
set.seed(123)
#take 10% of sample
#train_sample <- sample(12714, 10171)
#train_sample <- sample(12790, 11511)

#train_sample <- sample(11009, 8807)


train_sample <- sample(12615, 11354)

#train_sample <- sample(11697, 9358)

#train_sample

#create the training and test datasets
unsafe_train <- unsafe[train_sample, ]
unsafe_test <- unsafe[-train_sample, ]

#check to make sure training and test datasets are about evenly split
prop.table(table(unsafe_train$Status))
prop.table(table(unsafe_test$Status))


#build the model
#unsafe_train$Status <- as.numeric(unsafe_train$Status)
unsafe_train$Status <- as.factor(unsafe_train$Status)

#default is in column 1 of the dataset
unsafe_model <- C5.0(unsafe_train[-1], unsafe_train$Status)
unsafe_model

#run the model
summary(unsafe_model)

plot(unsafe_model)

names(unsafe_train)

#Evaluate model performance

unsafe_pred <- predict(unsafe_model, unsafe_test)

CrossTable(unsafe_test$Status, unsafe_pred, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c('actual Status', 'predicted Status'))


#improve through boosting
unsafe_boost10 <- C5.0(unsafe_train[-1], unsafe_train$Status, trials = 10)
unsafe_boost10
unsafe_boost10_pred <- predict(unsafe_boost10, unsafe_test)
CrossTable(unsafe_test$Status, unsafe_boost10_pred, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c('actual Status', 'predicted Status'))


summary(unsafe_boost10)


plot(unsafe_boost10)



#making mistakes more costly than others
matrix_dimensions <- list(c("no", "yes"), c("no", "yes"))
names(matrix_dimensions) <- c("predicted", "actual")
matrix_dimensions

error_cost <- matrix(c(0, 1, 4, 0), nrow = 2, dimnames = matrix_dimensions)
error_cost

unsafe_cost <- C5.0(unsafe_train[-1], unsafe_train$Status,  costs = error_cost)

unsafe_cost_pred <- predict(unsafe_cost, unsafe_test)

CrossTable(unsafe_test$Status, unsafe_cost_pred, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,dnn = c('actual default', 'predicted default'))

levels(unsafe_train$Status)
levels(unsafe_train$BldgFront)

names(unsafe_train)
summary(unsafe_train)
levels(unsafe_train$Status)[1] = "missing"

write.csv(unsafe_test, file = "S:\\Office of Risk Management\\User Folders\\Darius Mehri\\Facade Predictive Analysis\\unsafe_test.csv")




#ONE RULE LEARNERS
install.packages("RWeka")
library(RWeka)

df <-  read.csv("S:\\Office of Risk Management\\User Folders\\Darius Mehri\\Facade Predictive Analysis\\FACADE ANALYSIS DEC TREE 6 CURRENT STATUS.csv", sep=",", header=T)

names(df)

#model 1
df <-  df[,c('Status', 'YearBuiltCategory','AssessTotalCategory','NumFloorsCategory', 'Owner.Business.Name') ]

#model 2
df <-  df[,c('Status','YearBuiltCategory','AssessTotalCategory','NumFloorsCategory') ]


names(df)




train_sample <- sample(9830, 8847)

#train_sample <- sample(11697, 9358)

#train_sample

#create the training and test datasets
train <- df[train_sample, ]
test <- df[-train_sample, ]

#check to make sure training and test datasets are about evenly split
prop.table(table(train$Status))
prop.table(table(test$Status))


#build and test model
m <- OneR(Status ~ YearBuiltCategory + AssessTotalCategory + NumFloorsCategory + Owner.Business.Name, data = train)

m <- OneR(Status ~ ., data = train)


m
summary(m)


p <- predict(m, test)

as(m, "data.frame")

m[0]

is.list(m)


sink("clipboard")  # works in Windows, substitute "clipboard" for file name
print(m)
sink()




#write the results:
save(m, file = "S:\\Office of Risk Management\\User Folders\\Darius Mehri\\Facade Predictive Analysis\\one_rule_results.txt")

write.csv(m, file = "S:\\Office of Risk Management\\User Folders\\Darius Mehri\\Facade Predictive Analysis\\one_rule_results.csv", row.names = TRUE, sep = ',', col.names = TRUE)

library(plyr) 

m.df <- do.call("rbind", lapply(m, as.data.frame)) 

lapply(m, write, "S:\\Office of Risk Management\\User Folders\\Darius Mehri\\Facade Predictive Analysis\\one_rule_results.txt", append=TRUE, ncolumns=1000)

m.df = as.data.frame(do.call(rbind, m[1]))


str(m)


