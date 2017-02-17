#Research Question and Data

###Can the DOB develop a model using existing to predict unsafe buildings? Are building characteristics a good predictor to determine whether a building facade is safe or unsafe?

###Data: Compliance database

Owners who own buildings greater than 6 floors are required to file whether their building facade is safe or unsafe.

Currently the most useful data because large and has low sampling bias,  owners are required by law file a report to the DOB.

Dataset included filings from 2000 through the present.

Data limitations – Compliance only applies to buildings 6 floors or higher

#Model

###Decision tree induction

Decision tree models are  classifiers that utilize a tree structure to model the relationships among the features and the potential outcomes.

Dependent variable: Building is "unsafe" or "safe", 10065 buildings labeled as safe, 2550 unsafe.

Independent variables: Building frontage (the width of the building), age, assess total value of the bilding, number of floors, type of ownership (public or private), prevoius complaint history.

Method: Trained model using training dataset and validated with test data, calculated accuracy and applied rules to PLUTO dataset to find buildings that are unsafe.

Results: 

Overall accuracy of the model: 86%

Accuracy of predicting safe buildings: 95%

Accuracy of predicting unsafe buildings: 40%






