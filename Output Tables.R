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
using(xlsx)


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

###Table 6 Property####
Table6_Property<-subcategories_2019
Table6_Property<-merge(Table6_Property,Final2019,by=c("country"))

#names(Table6_Property)

keep<-c("country","propertyrank","property","realpropertytaxrank","realpropertytax","wealthtaxesrank","wealthtaxes","capitaltaxesrank","capitaltaxes")
Table6_Property<-Table6_Property[keep]
colnames(Table6_Property)<-c("Country","Overall Rank","Overall Score", "Real Property Taxes Rank","Real Property Taxes Score","Wealth/Estate Taxes Rank","Wealth/Estate Taxes Score","Capital/Transaction Taxes Rank","Capital/Transaction Taxes Score")

write.csv(Table6_Property,"./final-outputs/Table 6 Property.csv",row.names=F)

###Table 7 Property####
Table7_International<-subcategories_2019
Table7_International<-merge(Table7_International,Final2019,by=c("country"))

#names(Table7_International)

keep<-c("country","internationalrank","international","territorialrank","territorial","withholdingtaxesrank","withholdingtaxes","intregulationsrank","intregulations")
Table7_International<-Table7_International[keep]
colnames(Table7_International)<-c("Country","Overall Rank","Overall Score", "Div/Cap Gains Exemption Rank","Div/Cap Gains Exemption Score","Withholding Taxes Rank","Withholding Taxes Score","Regulations Rank","Regulations Score")

write.csv(Table7_International,"./final-outputs/Table 7 International.csv",row.names=F)

###Table A Coprorate####

#Raw Data
TableA_Corporate_raw<-subset(rawdata_2019,rawdata_2019$year==2019)


keep<-c("country","corprate","losscarryback","losscarryforward","pdvmachines","pdvbuildings","pdvintangibles","inventory","patentbox","rndcredit","corptime","profitpayments","otherpayments")
TableA_Corporate_raw<-TableA_Corporate_raw[keep]


#Text Data
TableA_Corporate_text<-read_csv("./source-data/TableA_Corporate.csv")
colnames(TableA_Corporate_text)<-names(TableA_Corporate_raw)
TableA_Corporate_text<-TableA_Corporate_text[3:38,]



#Replace raw data with text data for select columns
replace<-c("losscarryback","losscarryforward","inventory","rndcredit")
TableA_Corporate_text<-TableA_Corporate_text[replace]
TableA_Corporate<-TableA_Corporate_raw[,!names(TableA_Corporate_raw) %in% replace]
TableA_Corporate<-cbind(TableA_Corporate,TableA_Corporate_text)

TableA_Corporate<-TableA_Corporate[c("country","corprate","losscarryback","losscarryforward",
                                     "pdvmachines","pdvbuildings","pdvintangibles","inventory",
                                     "patentbox","rndcredit","corptime","profitpayments","otherpayments")]



#Format variables
#corprate
TableA_Corporate$corprate<-TableA_Corporate$corprate*100
TableA_Corporate$corprate<-paste((formatC(round(TableA_Corporate$corprate,digits=1),format = "f",digits=1)),"%",sep="")

#pdvmachines
TableA_Corporate$pdvmachines<-TableA_Corporate$pdvmachines*100
TableA_Corporate$pdvmachines<-paste((formatC(round(TableA_Corporate$pdvmachines,digits=1),format = "f",digits=1)),"%",sep="")

#pdvbuildings
TableA_Corporate$pdvbuildings<-TableA_Corporate$pdvbuildings*100
TableA_Corporate$pdvbuildings<-paste((formatC(round(TableA_Corporate$pdvbuildings,digits=1),format = "f",digits=1)),"%",sep="")

#pdvintangibles
TableA_Corporate$pdvintangibles<-TableA_Corporate$pdvintangibles*100
TableA_Corporate$pdvintangibles<-paste((formatC(round(TableA_Corporate$pdvintangibles,digits=1),format = "f",digits=1)),"%",sep="")

#patentbox
TableA_Corporate$patentbox<-if_else(TableA_Corporate$patentbox==0,"No","Yes")

#corptime
TableA_Corporate$corptime<-formatC(round(TableA_Corporate$corptime,digits=0),format = "f",digits=0)


#profitpayments
TableA_Corporate$profitpayments<-formatC(round(TableA_Corporate$profitpayments,digits=0),format = "f",digits=0)


#otherpayments
TableA_Corporate$otherpayments<-formatC(round(TableA_Corporate$otherpayments,digits=0),format = "f",digits=0)


headers<-c("",
           "Corporate Rate",
           "Cost Recovery",
           "",
           "",
           "",
           "",
           "",
           "Tax Incentives and Complexity","","","","")
columns<-c("Country",
           "Top Marginal Corporate Tax Rate",
           "Loss Carryback (Number of Years)",
           "Loss Carryforward (Number of Years)",
           "Machinery",
           "Industrial Buildings",
           "Intangibles",
           "Inventory (Best Available)",
           "Patent Box",
           "Research and Development Credit and/or Super Deduction",
           "Corporate Complexity (Time)",
           "Corporate Complexity (Yearly Profit Payments)",
           "Corporate Complexity (Other Yearly Payments)")

TableA_Corporate<-rbind(headers,columns,TableA_Corporate)
TableA_Corporate<-as.data.frame(TableA_Corporate)
write.csv(TableA_Corporate,"./final-outputs/Appendix-Table-CSV/Table A Corporate.csv",row.names = F)
write.xlsx(TableA_Corporate,"./final-outputs/Table A Corporate.xlsx",row.names = F)
