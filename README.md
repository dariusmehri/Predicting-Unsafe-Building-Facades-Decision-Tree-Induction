#Research Question and Data

###Can the DOB develop a model using existing data to predict unsafe buildings? Are building characteristics a good predictor of whether a building facade is safe or unsafe?

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

####Results: 

Overall accuracy of the model: 86%

Accuracy of predicting safe buildings: 95%

Accuracy of predicting unsafe buildings: 40%

Conclusion: Model is very good at predicting safee buildings, not so good at predicting unsafe buildings

![capture_predictive_actual](https://cloud.githubusercontent.com/assets/11237613/23081238/e63b5296-f521-11e6-8351-228ce96e1a0a.PNG)


####Decision Tree Rules:




    Age <= 30: SAFE (774.2/191.2)
    
    Age > 30:
    
    :...Violations <= 0:
    
    :...Public = 0: SAFE (4505.5/1407.7)
    
    :   Public = 1:
    
    :   :...BldgFront > 471: UNSAFE (30.5/2.5) ACC = 90%
    
    :       BldgFront <= 471:
    
    :       :...NumFloors <= 6.5: SAFE (472.3/184.5)
    
    :           NumFloors > 6.5:
    
    :           :...AssessTotal <= 16.69095: UNSAFE (465.3/211.3)
    
    :               AssessTotal > 16.69095: SAFE (418/181.7) ACC = 30%
    
    Violations > 0:
    
    :...AssessTotal > 160.4799: SAFE (41.5/8.2)
    
        AssessTotal <= 160.4799:
        
        :...NumFloors <= 17:
        
            :...BldgFront <= 24: SAFE (65.2/13.8)
            
            :   BldgFront > 24:
            
            :   :...Age <= 89: SAFE (2270.7/1090.4)
            
            :       Age > 89:
            
            :       :...AssessTotal <= 0.9495: UNSAFE (205.7/84.7)
            
            :           AssessTotal > 0.9495: SAFE (1560.3/633.2)
            
            NumFloors > 17:
            
            :...Public = 1: SAFE (69.5/23.7)
            
                Public = 0:
                
                :...BldgFront <= 70.83: UNSAFE (105.2/23.5)
                
                    BldgFront > 70.83:
                    
                    :...BldgFront > 338.5: UNSAFE (28.8/3.4)
                    
                        BldgFront <= 338.5:
                        
                        :...AssessTotal <= 50.06025: UNSAFE (414.4/190)
                        
                            AssessTotal > 50.06025: SAFE (84/22.5)


