#main index code
rm(list=ls())
gc()

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


using<-function(...,prompt=TRUE){
  libs<-sapply(substitute(list(...))[-1],deparse)
  req<-unlist(lapply(libs,require,character.only=TRUE))
  need<-libs[req==FALSE]
  n<-length(need)
  installAndRequire<-function(){
    install.packages(need)
    lapply(need,require,character.only=TRUE)
  }
  if(n>0){
    libsmsg<-if(n>2) paste(paste(need[1:(n-1)],collapse=", "),",",sep="") else need[1]
    if(n>1){
      libsmsg<-paste(libsmsg," and ", need[n],sep="")
    }
    libsmsg<-paste("The following packages count not be found: ",libsmsg,"n\r\n\rInstall missing packages?",collapse="")
    if(prompt==FALSE){
      installAndRequire()
    }else if(winDialog(type=c("yesno"),libsmsg)=="YES"){
      installAndRequire()
    }
  }
}

# Sets the working directory. This sets it to the "index" folder on my desktop
using(plyr)
using(dplyr)
using(tidyverse)
using(readxl)


#Read in relevant spreadsheets

rawdata_2019 <- read_csv("./final-outputs/Raw Data 2019.csv")

Final2017 <- read_csv("./final-outputs/data2017run.csv")
Final2018 <- read_csv("./final-outputs/data2018run.csv")
Final2019 <- read_csv("./final-outputs/data2019run.csv")

subcategories_2019 <- read_csv("./final-outputs/subcategories 2019.csv")

###Table 1####
Table_1_Results<-Final2019

#Select variables
keep<-c("country","finalrank","final","corporaterank","incomerank","consumptionrank","propertyrank","internationalrank")
Table_1_Results<-Table_1_Results[keep]

#Sort by rank
Table_1_Results<-Table_1_Results[order(Table_1_Results$finalrank),]

colnames(Table_1_Results)<-c("Country",
                             "Overall Rank",
                             "Overall Score",
                             "Corporate Tax Rank", 
                             "Individual Taxes Rank", 
                             "Consumption Taxes Rank", 
                             "Property Taxes Rank", 
                             "International Tax Rules Rank")

write.csv(Table_1_Results,"./final-outputs/Table 1 Results.csv",row.names=F)

###Table 2 Changes####
Table2_Changes<-merge(Final2018,Final2019,by="country")
keep<-c("country","finalrank.x","final.x","finalrank.y","final.y")

Table2_Changes<-Table2_Changes[keep]

colnames(Table2_Changes)<-c("country", "2018 Rank","2018 Score","2019 Rank","2019 Score")

Table2_Changes<-merge(Final2017,Table2_Changes,by="country")
keep<-c("country","finalrank","final","2018 Rank","2018 Score","2019 Rank","2019 Score")

Table2_Changes<-Table2_Changes[keep]

colnames(Table2_Changes)<-c("Country","2017 Rank","2017 Score", "2018 Rank","2018 Score","2019 Rank","2019 Score")

Table2_Changes$'Change in Rank'<-(Table2_Changes$`2019 Rank`-Table2_Changes$`2018 Rank`)*(-1)
Table2_Changes$'Change in Score'<-Table2_Changes$`2019 Score`-Table2_Changes$`2018 Score`

write.csv(Table2_Changes,"./final-outputs/Table 2 Changes.csv",row.names=F)

###Table 3 Corporate####
Table3_Corporate<-subcategories_2019
Table3_Corporate<-merge(Table3_Corporate,Final2019,by=c("country"))

keep<-c("country","corporaterank","corporate","corporateraterank","corporaterate","costrecoveryrank","costrecovery","incentivesrank","incentives")
Table3_Corporate<-Table3_Corporate[keep]
colnames(Table3_Corporate)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Cost Recovery Rank","Cost Recovery Score","Incentives/Complexity Rank","Incentives/Complexity Score")

write.csv(Table3_Corporate,"./final-outputs/Table 3 Corporate.csv",row.names=F)


###Table 4 Individual####
Table4_Individual<-subcategories_2019
Table4_Individual<-merge(Table4_Individual,Final2019,by=c("country"))

#names(Table4_Individual)

keep<-c("country","incomerank","income","capgainsanddividendsrank","capgainsanddividends","incometaxrank","incometax","incometaxcomplexityrank","incometaxcomplexity")
Table4_Individual<-Table4_Individual[keep]
colnames(Table4_Individual)<-c("Country","Overall Rank","Overall Score", "Capital Gains/Dividends Rank","Capital Gains/Dividends Score","Income Tax Rank","Income Tax Score","Complexity Rank","Complexity Score")

write.csv(Table4_Individual,"./final-outputs/Table 4 Individual.csv",row.names=F)

###Table 5 Consumption####
Table5_Consumption<-subcategories_2019
Table5_Consumption<-merge(Table5_Consumption,Final2019,by=c("country"))

#names(Table5_Consumption)

keep<-c("country","consumptionrank","consumption","consumptiontaxraterank","consumptiontaxrate","consumptiontaxbaserank","consumptiontaxbase","consumptiontaxcomplexityrank","consumptiontaxcomplexity")
Table5_Consumption<-Table5_Consumption[keep]
colnames(Table5_Consumption)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Base Rank","Base Score","Complexity Rank","Complexity Score")

write.csv(Table5_Consumption,"./final-outputs/Table 5 Consumption.csv",row.names=F)
