# description: an evaluation of our model to predict the revenue of films based on aspects of production using http://en.wikipedia.org/wiki/Random_forest.
# author: Ben Adelman (Adapted approach from Kaggle Competition to fit our data), Paul Prae (Improved and Evaluated Model)
# since: 4/10/2015
# citation: inspired by a tutorial for a Kaggle competition written by Trevor Stephens: https://github.com/trevorstephens/titanic

install.packages('randomForest')
library(randomForest)

##  load the full file into R
full_data <- read.csv("./data/input/film_data.csv")

## adjusting some data types
full_data$Budget <- as.numeric(as.character(full_data$Budget))
full_data$Revenue <- as.numeric(as.character(full_data$Revenue))
full_data$Weekend_Total <- as.numeric(as.character(full_data$Revenue))

##  75% of the sample size for train (used for evaluation run, not final run)
smp_size <- floor(0.75 * nrow(full_data))

## set the seed to make your partition reproducible (a random number seed)
set.seed(123)
train_ind <- sample(seq_len(nrow(full_data)), size = smp_size)

##  now let's split into test vs. training data
train <- full_data[train_ind, ]
test <- full_data[-train_ind, ]

##  set up the random forest model for predicting Total Revenue
# configuratioin: as.numeric, importance=TRUE, ntree=2000
fit_Revenue <- randomForest(as.numeric(Revenue) ~ Budget + MPAA_Rating + Release_in_Winter + Release_in_Spring + Release_in_Summer + Release_in_Fall + Release_in_Holiday + Actor_Morgan_Freeman + Actor_Dennis_Hopper + Actor_Henry_Fonda + Actor_Bruce_Willis + Actor_Samuel_L__Jackson + Actor_Robert_De_Niro + Actor_Burt_Lancaster + Actor_Donald_Sutherland + Actor_Christopher_Lee + Actor_John_Wayne + Actor_Keanu_Reeves + Actor_Nick_Nolte + Actor_Nicolas_Cage + Actor_Gene_Hackman + Actor_Michael_Caine + Actor_Sean_Connery + Actor_Oliver_Hardy + Actor_Stan_Laurel + Actor_Robert_Duvall + Actor_Susan_Sarandon + Actor_Jack_Nicholson + Actor_Robert_Downey_Jr_ + Actor_Christopher_Walken + Actor_Willem_Dafoe + Actor_James_Stewart + Actor_Dustin_Hoffman + Actor_Robin_Williams + Actor_John_Goodman + Actor_Dennis_Quaid + Actor_Harvey_Keitel + Director_Blake_Edwards + Director_Sidney_Lumet + Director_Steven_Spielberg + Director_Spike_Lee + Director_John_Ford + Director_Robert_Altman + Director_Charlie_Chaplin + Director_Vincente_Minnelli + Director_Woody_Allen + Director_Clint_Eastwood + Director_Martin_Scorsese + Director_Ingmar_Bergman + Director_Howard_Hawks + Director_John_Huston + Director_Raoul_Walsh + Director_Chuck_Jones + Director_Werner_Herzog + Director_Fritz_Lang + Director_Steven_Soderbergh + Director_Michael_Curtiz + Director_Francis_Ford_Coppola + Director_Roger_Corman + Director_Alfred_Hitchcock + Director_Friz_Freleng + Director_Anthony_Mann + Director_Norman_Taurog + Director_Akira_Kurosawa + Genre_comedy + Genre_drama + Genre_romantic + Genre_science_fiction + Genre_crime + Genre_action + Genre_thriller + Genre_horror + Genre_animated, data=train, importance=TRUE, ntree=2000)

##  stats
summary(fit_Revenue)
varImpPlot(fit_Revenue, type=1)
varImpPlot(fit_Revenue, type=2)
imp <- importance(fit_Revenue)
imp
##  Now to make the prediction... using the model against the test data...
RevenuePrediction <- predict(fit_Revenue, test, OOB=TRUE, type = "response")

## more stats
## estimated versus observed values
options(scipen=5)
plot(test$Revenue, RevenuePrediction, xlab="Actual Revenue", ylab="Predicted Revenue")

## r squared
cor(RevenuePrediction, test$Revenue)^2

## root-mean-square error 
RMSE <- (sum((RevenuePrediction-test$Revenue)^2)/length(test$Revenue))^(1/2)

## find the max observed value
maxRevenue <- max(test$Revenue)
maxRevenue

## find the min observed value
minRevenue <- min(test$Revenue)
minRevenue

## normalized root-mean-square error
NRMSE <- (RMSE/(maxRevenue - minRevenue))
NRMSE

## save 'em
test$RevenuePrediction <- RevenuePrediction
write.csv(test, file = "./data/output/test_predictions.csv", row.names = TRUE)
