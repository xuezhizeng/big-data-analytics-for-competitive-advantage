# description: predict the revenue and opening weekend sales of films based on aspects of production using http://en.wikipedia.org/wiki/Random_forest.
# author: Ben Adelman (Adapted approach from Kaggle Competition to fit our data), Paul Prae (Improved and Evaluated Model)
# since: 4/10/2015
# citation: inspired by a tutorial for a Kaggle competition written by Trevor Stephens: https://github.com/trevorstephens/titanic

install.packages('randomForest')
library(randomForest)

##  load the full file into R
training_data <- read.csv("./data/input/film_data_minimal.csv")
possible_films <- read.csv("./data/input/possible_films_plus_empty_cols_ordered.csv")

## adjusting some data types
training_data$Budget <- as.numeric(as.character(training_data$Budget))
training_data$Revenue <- as.numeric(as.character(training_data$Revenue))
training_data$Weekend_Total <- as.numeric(as.character(training_data$Revenue))
possible_films$Budget <- as.numeric(as.character(possible_films$Budget))
possible_films$Revenue <- as.numeric(possible_films$Revenue)
possible_films$Weekend_Total <- as.numeric(possible_films$Revenue)
levels(possible_films$MPAA_Rating) <- levels(training_data$MPAA_Rating)

##  set up the random forest model for predicting Total Revenue and Opening Weekend Sales
# configuratioin: as.numeric, importance=TRUE, ntree=2000
fit_Revenue <- randomForest(as.numeric(Revenue) ~ Budget + MPAA_Rating + Release_in_Winter + Release_in_Spring + Release_in_Summer + Release_in_Fall + Release_in_Holiday + Actor_Morgan_Freeman + Actor_Dennis_Hopper + Actor_Henry_Fonda + Actor_Bruce_Willis + Actor_Samuel_L__Jackson + Actor_Robert_De_Niro + Actor_Burt_Lancaster + Actor_Donald_Sutherland + Actor_Christopher_Lee + Actor_John_Wayne + Actor_Keanu_Reeves + Actor_Nick_Nolte + Actor_Nicolas_Cage + Actor_Gene_Hackman + Actor_Michael_Caine + Actor_Sean_Connery + Actor_Oliver_Hardy + Actor_Stan_Laurel + Actor_Robert_Duvall + Actor_Susan_Sarandon + Actor_Jack_Nicholson + Actor_Robert_Downey_Jr_ + Actor_Christopher_Walken + Actor_Willem_Dafoe + Actor_James_Stewart + Actor_Dustin_Hoffman + Actor_Robin_Williams + Actor_John_Goodman + Actor_Dennis_Quaid + Actor_Harvey_Keitel + Director_Blake_Edwards + Director_Sidney_Lumet + Director_Steven_Spielberg + Director_Spike_Lee + Director_John_Ford + Director_Robert_Altman + Director_Charlie_Chaplin + Director_Vincente_Minnelli + Director_Woody_Allen + Director_Clint_Eastwood + Director_Martin_Scorsese + Director_Ingmar_Bergman + Director_Howard_Hawks + Director_John_Huston + Director_Raoul_Walsh + Director_Chuck_Jones + Director_Werner_Herzog + Director_Fritz_Lang + Director_Steven_Soderbergh + Director_Michael_Curtiz + Director_Francis_Ford_Coppola + Director_Roger_Corman + Director_Alfred_Hitchcock + Director_Friz_Freleng + Director_Anthony_Mann + Director_Norman_Taurog + Director_Akira_Kurosawa + Genre_comedy + Genre_drama + Genre_romantic + Genre_science_fiction + Genre_crime + Genre_action + Genre_thriller + Genre_horror + Genre_animated, data=training_data, importance=TRUE, ntree=2000)
fit_Weekend_Total <- randomForest(as.numeric(Weekend_Total) ~ Budget + MPAA_Rating + Release_in_Winter + Release_in_Spring + Release_in_Summer + Release_in_Fall + Release_in_Holiday + Actor_Morgan_Freeman + Actor_Dennis_Hopper + Actor_Henry_Fonda + Actor_Bruce_Willis + Actor_Samuel_L__Jackson + Actor_Robert_De_Niro + Actor_Burt_Lancaster + Actor_Donald_Sutherland + Actor_Christopher_Lee + Actor_John_Wayne + Actor_Keanu_Reeves + Actor_Nick_Nolte + Actor_Nicolas_Cage + Actor_Gene_Hackman + Actor_Michael_Caine + Actor_Sean_Connery + Actor_Oliver_Hardy + Actor_Stan_Laurel + Actor_Robert_Duvall + Actor_Susan_Sarandon + Actor_Jack_Nicholson + Actor_Robert_Downey_Jr_ + Actor_Christopher_Walken + Actor_Willem_Dafoe + Actor_James_Stewart + Actor_Dustin_Hoffman + Actor_Robin_Williams + Actor_John_Goodman + Actor_Dennis_Quaid + Actor_Harvey_Keitel + Director_Blake_Edwards + Director_Sidney_Lumet + Director_Steven_Spielberg + Director_Spike_Lee + Director_John_Ford + Director_Robert_Altman + Director_Charlie_Chaplin + Director_Vincente_Minnelli + Director_Woody_Allen + Director_Clint_Eastwood + Director_Martin_Scorsese + Director_Ingmar_Bergman + Director_Howard_Hawks + Director_John_Huston + Director_Raoul_Walsh + Director_Chuck_Jones + Director_Werner_Herzog + Director_Fritz_Lang + Director_Steven_Soderbergh + Director_Michael_Curtiz + Director_Francis_Ford_Coppola + Director_Roger_Corman + Director_Alfred_Hitchcock + Director_Friz_Freleng + Director_Anthony_Mann + Director_Norman_Taurog + Director_Akira_Kurosawa + Genre_comedy + Genre_drama + Genre_romantic + Genre_science_fiction + Genre_crime + Genre_action + Genre_thriller + Genre_horror + Genre_animated, data=training_data, importance=TRUE, ntree=2000)


##  stats
summary(fit_Revenue)
varImpPlot(fit_Revenue)

summary(fit_Weekend_Total)
varImpPlot(fit_Weekend_Total)

##  Now to make the prediction... using the model against all possible film combinations data...
RevenuePrediction <- predict(fit_Revenue, possible_films, OOB=TRUE, type = "response")
WeekendTotalPrediction <- predict(fit_Weekend_Total, possible_films, OOB=TRUE, type = "response")

## save 'em
possible_films$RevenuePrediction <- RevenuePrediction
possible_films$WeekendTotalPrediction <- WeekendTotalPrediction
write.csv(possible_films, file = "./data/output/final_predictions.csv", row.names = TRUE)
