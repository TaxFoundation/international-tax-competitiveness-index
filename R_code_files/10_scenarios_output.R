baseline <- read_csv(paste(final_outputs,"United_Kingdom_Baseline.csv",sep=""))
Option_A <- read_csv(paste(final_outputs,"United_Kingdom_Option_A.csv",sep=""))
Option_B <- read_csv(paste(final_outputs,"United_Kingdom_Option_B.csv",sep=""))
Budget_2020 <- read_csv(paste(final_outputs,"United_Kingdom_Budget_2020.csv",sep=""))
baseline$scenario<-"Baseline"
Option_A$scenario<-"Option A"
Option_B$scenario<-"Option B"
Budget_2020$scenario<-"Budget 2020"

scenarios<-rbind(baseline,Option_A,Option_B,Budget_2020)
scenarios<-subset(scenarios,scenarios$year==2019)
scenarios<-scenarios[-c(1:2,4,6,8,10,12,14:16)]
names(scenarios)
scenarios<-scenarios[c("scenario","final_rank","corporate_rank","income_rank","consumption_rank","property_rank","international_rank")]


colnames(scenarios)<-c("Scenario",
                       "Overall Rank",
                       "Corporate Tax Rank", 
                       "Individual Taxes Rank", 
                       "Consumption Taxes Rank", 
                       "Property Taxes Rank", 
                       "International Tax Rules Rank")

write.csv(scenarios,paste(final_outputs,"United_Kingdom_scenarios.csv",sep=""),row.names=F)
