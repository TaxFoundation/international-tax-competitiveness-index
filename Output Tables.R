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
using(scales)

#Read in relevant spreadsheets

rawdata_2019 <- read_csv("./final-outputs/Raw Data 2019.csv")

Final2017 <- read_csv("./final-outputs/data2017run.csv")
Final2018 <- read_csv("./final-outputs/data2018run.csv")
Final2019 <- read_csv("./final-outputs/data2019run.csv")

subcategories_2019 <- read_csv("./final-outputs/subcategories 2019.csv")

###Table 1 Results####
Table_1_Results<-Final2019

#Select variables
keep<-c("country","finalrank","final","corporaterank","incomerank","consumptionrank","propertyrank","internationalrank")
Table_1_Results<-Table_1_Results[keep]

#Sort by rank
Table_1_Results<-Table_1_Results[order(Table_1_Results$finalrank),]

#Format columns
Table_1_Results$final<-formatC(round(Table_1_Results$final,digits=1),format = "f",digits=1)


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

Table2_Changes$'Change in Rank from 2018 to 2019'<-(Table2_Changes$`2019 Rank`-Table2_Changes$`2018 Rank`)*(-1)
Table2_Changes$'Change in Score from 2018 to 2019'<-Table2_Changes$`2019 Score`-Table2_Changes$`2018 Score`

#Format Columns

Table2_Changes$`2017 Score`<-formatC(round(Table2_Changes$`2017 Score`,digits=1),format = "f",digits=1)
Table2_Changes$`2018 Score`<-formatC(round(Table2_Changes$`2018 Score`,digits=1),format = "f",digits=1)
Table2_Changes$`2019 Score`<-formatC(round(Table2_Changes$`2019 Score`,digits=1),format = "f",digits=1)
Table2_Changes$`Change in Score`<-formatC(round(Table2_Changes$`Change in Score`,digits=1),format = "f",digits=1)


write.csv(Table2_Changes,"./final-outputs/Table 2 Changes.csv",row.names=F)

###Table 3 Corporate####
Table3_Corporate<-subcategories_2019
Table3_Corporate<-merge(Table3_Corporate,Final2019,by=c("country"))

keep<-c("country","corporaterank","corporate","corporateraterank","corporaterate","costrecoveryrank","costrecovery","incentivesrank","incentives")
Table3_Corporate<-Table3_Corporate[keep]
colnames(Table3_Corporate)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Cost Recovery Rank","Cost Recovery Score","Incentives/Complexity Rank","Incentives/Complexity Score")

#Format Columns

Table3_Corporate$`Overall Score`<-formatC(round(Table3_Corporate$`Overall Score`,digits=1),format = "f",digits=1)
Table3_Corporate$`Rate Score`<-formatC(round(Table3_Corporate$`Rate Score`,digits=1),format = "f",digits=1)
Table3_Corporate$`Cost Recovery Score`<-formatC(round(Table3_Corporate$`Cost Recovery Score`,digits=1),format = "f",digits=1)
Table3_Corporate$`Incentives/Complexity Score`<-formatC(round(Table3_Corporate$`Incentives/Complexity Score`,digits=1),format = "f",digits=1)

write.csv(Table3_Corporate,"./final-outputs/Table 3 Corporate.csv",row.names=F)


###Table 4 Individual####
Table4_Individual<-subcategories_2019
Table4_Individual<-merge(Table4_Individual,Final2019,by=c("country"))

#names(Table4_Individual)

keep<-c("country","incomerank","income","incometaxrank","incometax","incometaxcomplexityrank","incometaxcomplexity","capgainsanddividendsrank","capgainsanddividends")
Table4_Individual<-Table4_Individual[keep]
colnames(Table4_Individual)<-c("Country","Overall Rank","Overall Score","Income Tax Rank","Income Tax Score","Complexity Rank","Complexity Score", "Capital Gains/Dividends Rank","Capital Gains/Dividends Score")

Table4_Individual$`Overall Score`<-formatC(round(Table4_Individual$`Overall Score`,digits=1),format = "f",digits=1)
Table4_Individual$`Income Tax Score`<-formatC(round(Table4_Individual$`Income Tax Score`,digits=1),format = "f",digits=1)
Table4_Individual$`Complexity Score`<-formatC(round(Table4_Individual$`Complexity Score`,digits=1),format = "f",digits=1)
Table4_Individual$`Capital Gains/Dividends Score`<-formatC(round(Table4_Individual$`Capital Gains/Dividends Score`,digits=1),format = "f",digits=1)


write.csv(Table4_Individual,"./final-outputs/Table 4 Individual.csv",row.names=F)

###Table 5 Consumption####
Table5_Consumption<-subcategories_2019
Table5_Consumption<-merge(Table5_Consumption,Final2019,by=c("country"))

#names(Table5_Consumption)

keep<-c("country","consumptionrank","consumption","consumptiontaxraterank","consumptiontaxrate","consumptiontaxbaserank","consumptiontaxbase","consumptiontaxcomplexityrank","consumptiontaxcomplexity")
Table5_Consumption<-Table5_Consumption[keep]
colnames(Table5_Consumption)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Base Rank","Base Score","Complexity Rank","Complexity Score")


Table5_Consumption$`Overall Score`<-formatC(round(Table5_Consumption$`Overall Score`,digits=1),format = "f",digits=1)
Table5_Consumption$`Rate Score`<-formatC(round(Table5_Consumption$`Rate Score`,digits=1),format = "f",digits=1)
Table5_Consumption$`Base Score`<-formatC(round(Table5_Consumption$`Base Score`,digits=1),format = "f",digits=1)
Table5_Consumption$`Complexity Score`<-formatC(round(Table5_Consumption$`Complexity Score`,digits=1),format = "f",digits=1)



write.csv(Table5_Consumption,"./final-outputs/Table 5 Consumption.csv",row.names=F)

###Table 6 Property####
Table6_Property<-subcategories_2019
Table6_Property<-merge(Table6_Property,Final2019,by=c("country"))

#names(Table6_Property)

keep<-c("country","propertyrank","property","realpropertytaxrank","realpropertytax","wealthtaxesrank","wealthtaxes","capitaltaxesrank","capitaltaxes")
Table6_Property<-Table6_Property[keep]
colnames(Table6_Property)<-c("Country","Overall Rank","Overall Score", "Real Property Taxes Rank","Real Property Taxes Score","Wealth/Estate Taxes Rank","Wealth/Estate Taxes Score","Capital/Transaction Taxes Rank","Capital/Transaction Taxes Score")


Table6_Property$`Overall Score`<-formatC(round(Table6_Property$`Overall Score`,digits=1),format = "f",digits=1)
Table6_Property$`Real Property Taxes Score`<-formatC(round(Table6_Property$`Real Property Taxes Score`,digits=1),format = "f",digits=1)
Table6_Property$`Wealth/Estate Taxes Score`<-formatC(round(Table6_Property$`Wealth/Estate Taxes Score`,digits=1),format = "f",digits=1)
Table6_Property$`Capital/Transaction Taxes Score`<-formatC(round(Table6_Property$`Capital/Transaction Taxes Score`,digits=1),format = "f",digits=1)



write.csv(Table6_Property,"./final-outputs/Table 6 Property.csv",row.names=F)

###Table 7 International####
Table7_International<-subcategories_2019
Table7_International<-merge(Table7_International,Final2019,by=c("country"))

#names(Table7_International)

keep<-c("country","internationalrank","international","territorialrank","territorial","withholdingtaxesrank","withholdingtaxes","intregulationsrank","intregulations")
Table7_International<-Table7_International[keep]
colnames(Table7_International)<-c("Country","Overall Rank","Overall Score", "Div/Cap Gains Exemption Rank","Div/Cap Gains Exemption Score","Withholding Taxes Rank","Withholding Taxes Score","Regulations Rank","Regulations Score")


Table7_International$`Overall Score`<-formatC(round(Table7_International$`Overall Score`,digits=1),format = "f",digits=1)
Table7_International$`Div/Cap Gains Exemption Score`<-formatC(round(Table7_International$`Div/Cap Gains Exemption Score`,digits=1),format = "f",digits=1)
Table7_International$`Withholding Taxes Score`<-formatC(round(Table7_International$`Withholding Taxes Score`,digits=1),format = "f",digits=1)
Table7_International$`Regulations Score`<-formatC(round(Table7_International$`Regulations Score`,digits=1),format = "f",digits=1)


write.csv(Table7_International,"./final-outputs/Table 7 International.csv",row.names=F)

###Table A Coprorate####

#Raw Data
TableA_Corporate_raw<-subset(rawdata_2019,rawdata_2019$year==2019)


keep<-c("country","corprate","losscarryback","losscarryforward","pdvmachines","pdvbuildings","pdvintangibles","inventory","patentbox","rndcredit","corptime","profitpayments","otherpayments")
TableA_Corporate_raw<-TableA_Corporate_raw[keep]


#Text Data
TableA_Corporate_text<-read_csv("./source-data/TableA_Corporate.csv")
colnames(TableA_Corporate_text)<-names(TableA_Corporate_raw)
TableA_Corporate_text<-TableA_Corporate_text[2:37,]



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

write.csv(TableA_Corporate,"./final-outputs/Appendix-Table-CSV/Table A Corporate.csv",row.names = F)
write.xlsx(TableA_Corporate,"./final-outputs/Table A Corporate.xlsx",row.names = F)

#Table B Individual####

#Raw Data
TableB_Individual_raw<-subset(rawdata_2019,rawdata_2019$year==2019)
#names(TableB_Individual_raw)

keep<-c("country","incrate","progressivity","taxwedge","laborpayments","labortime","capgainsrate","divrate")
TableB_Individual<-TableB_Individual_raw[keep]


#Format variables
#incrate
TableB_Individual$incrate<-TableB_Individual$incrate*100
TableB_Individual$incrate<-paste((formatC(round(TableB_Individual$incrate,digits=1),format = "f",digits=1)),"%",sep="")

#progressivity
TableB_Individual$progressivity<-(formatC(round(TableB_Individual$progressivity,digits=1),format = "f",digits=1))

#taxwedge
TableB_Individual$taxwedge<-(formatC(round(TableB_Individual$taxwedge,digits=1),format = "f",digits=1))

#laborpayments
TableB_Individual$laborpayments<-(formatC(round(TableB_Individual$laborpayments,digits=0),format = "f",digits=0))

#labortime
TableB_Individual$labortime<-(formatC(round(TableB_Individual$labortime,digits=0),format = "f",digits=0))

#capgainsrate
TableB_Individual$capgainsrate<-TableB_Individual$capgainsrate*100
TableB_Individual$capgainsrate<-paste((formatC(round(TableB_Individual$capgainsrate,digits=1),format = "f",digits=1)),"%",sep="")

#divrate
TableB_Individual$divrate<-TableB_Individual$divrate*100
TableB_Individual$divrate<-paste((formatC(round(TableB_Individual$divrate,digits=1),format = "f",digits=1)),"%",sep="")

headers<-c("",
           "Ordinary Income Taxes and Payroll Taxes",
           "",
           "",
           "Income Tax Complexity",
           "",
           "Capital Gains/Dividends",
           "",
           "")
columns<-c("Country",
           "Top Marginal Income Tax Rate",
           "Top Income Tax Rate Threshold (a)",
           "Ratio of Marginal to Average Tax Wedge",
           "Income Tax Complexity (Payments)",
           "Income Tax Complexity (Time)",
           "Top Marginal Capital Gains Rate (b)",
           "Top Marginal Dividends Tax Rate (b)")
notes_1<-c("Notes:",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_2<-c("(a) Multiple of the average income at which the highest tax bracket applies.",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_3<-c("(b) After any imputation, credit, or offset.",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
TableB_Individual<-rbind(headers,columns,TableB_Individual,notes_1,notes_2,notes_3)

write.csv(TableB_Individual,"./final-outputs/Appendix-Table-CSV/Table B Individual.csv",row.names = F)
write.xlsx(TableB_Individual,"./final-outputs/Table B Individual.xlsx")

#Table C Consumption####
#Raw Data
TableC_Consumption_raw<-subset(rawdata_2019,rawdata_2019$year==2019)
#names(TableC_Consumption_raw)

keep<-c("country","vatrate","threshold","base","consumptiontime")
TableC_Consumption<-TableC_Consumption_raw[keep]

#Format variables
#vatrate
TableC_Consumption$vatrate<-paste((formatC(round(TableC_Consumption$vatrate,digits=1),format = "f",digits=1)),"%",sep="")

#threshold
TableC_Consumption$threshold<-dollar(TableC_Consumption$threshold,largest_with_cents = 10^10)

#base
TableC_Consumption$base<-TableC_Consumption$base*100
TableC_Consumption$base<-paste((formatC(round(TableC_Consumption$base,digits=1),format = "f",digits=1)),"%",sep="")

#consumptiontime
TableC_Consumption$consumptiontime<-formatC(round(TableC_Consumption$consumptiontime,digits=0),format = "f",digits=0)

#fix US and Canada to add footnote markers
TableC_Consumption$vatrate[4]<-paste0(TableC_Consumption$vatrate[4]," (b)")
TableC_Consumption$vatrate[36]<-paste0(TableC_Consumption$vatrate[36]," (c)")

headers<-c("",
           "Consumption Tax Rate",
           "Consumption Tax Base",
           "",
           "Consumption Tax Complexity")
columns<-c("Country",
           "VAT/Sales Tax Rate",
           "VAT/Sales Tax Threshold (a)",
           "VAT/Sales Tax Base as a Percent of Total Consumption",
           "Complexity (Hours to Comply")
notes_1<-c("Notes:",
           "",
           "",
           "",
           "")

notes_2<-c("(a) In U.S. dollars (Purchasing Power Parity).",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_3<-c("(b) The Canadian rate is the average of the total sales tax rate for the provinces and includes Goods and Services Tax, Provincial Sales Tax, and Retail Sales Tax where applicable.",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_4<-c("(c) The United States' rate is the combined weighted average state and local sales tax rate.",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
TableC_Consumption<-rbind(headers,columns,TableC_Consumption,notes_1,notes_2,notes_3,notes_4)

write.csv(TableC_Consumption,"./final-outputs/Appendix-Table-CSV/Table C Consumption.csv",row.names = F)
write.xlsx(TableC_Consumption,"./final-outputs/Table C Consumption.xlsx")

#Table D Property####
#Raw Data
TableD_Property_raw<-subset(rawdata_2019,rawdata_2019$year==2019)
#names(TableD_Property_raw)

keep<-c("country","propertytaxes","propertytaxescollections","netwealth","estate.inheritance.tax","transfertaxes","Assettaxes","capitalduties","financialtrans")
TableD_Property_raw<-TableD_Property_raw[keep]
TableD_Property_raw$deductible<-if_else(TableD_Property_raw$propertytaxes==0.5,1,0)

#Text Data
TableD_Property_text<-read_csv("./source-data/TableD_Property.csv")


colnames(TableD_Property_text)<-c("country","propertytaxes","deductible","propertytaxescollections","netwealth","estate.inheritance.tax",  
                                  "transfertaxes","Assettaxes","capitalduties","financialtrans")
TableD_Property_text<-TableD_Property_text[2:37,]


#Replace raw data with text data for select columns
replace<-c("propertytaxes","estate.inheritance.tax","transfertaxes","Assettaxes")
TableD_Property_text<-TableD_Property_text[replace]
TableD_Property<-TableD_Property_raw[,!names(TableD_Property_raw) %in% replace]
TableD_Property<-cbind(TableD_Property,TableD_Property_text)

TableD_Property<-TableD_Property[c("country","propertytaxes","deductible","propertytaxescollections","netwealth","estate.inheritance.tax",  
                                   "transfertaxes","Assettaxes","capitalduties","financialtrans")]

#Format variables
#deductible
TableD_Property$deductible<-if_else(TableD_Property$deductible==1,"Yes","No")

#propertytaxescollections
TableD_Property$propertytaxescollections<-paste((formatC(round(TableD_Property$propertytaxescollections,digits=1),format = "f",digits=1)),"%",sep="")

#netwealth
TableD_Property$netwealth<-if_else(TableD_Property$netwealth==1,"Yes","No")

#capitalduties
TableD_Property$capitalduties<-if_else(TableD_Property$capitalduties==1,"Yes","No")

#financialtrans
TableD_Property$financialtrans<-if_else(TableD_Property$financialtrans==1,"Yes","No")


headers<-c("",
           "Real Property Taxes",
           "",
           "",
           "Wealth/Estate Taxes",
           "",
           "Capital/Transaction Taxes",
           "",
           "",
           "")

columns<-c("Country",
           "Real Property or Land Tax",
           "Real Property Taxes Deductible",
           "Real Property Taxes as % of Capital Stock",
           "Net Wealth Tax",
           "Estate/Inheritance Tax",
           "Transfer Taxes",
           "Asset Taxes",
           "Capital Duties",
           "Financial Transaction Tax")
notes_1<-c("Notes:",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_2<-c("(a) Applies to some real estate (vacation homes).",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_3<-c("(b) Tax on the imputed rent of properties. Applies to machinery.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_4<-c("(c) The Land Appreciation Tax is levied like a capital gains tax on the sale of property.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_5<-c("(d) Levied by local governments. A few cities tax capital improvements.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_6<-c("(e) The purchaser of real property is subject to a purchase tax.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_7<-c("(f) Nine U.S. states levy a tax on intangible personal property.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
TableD_Property<-rbind(headers,columns,TableD_Property,notes_1,notes_2,notes_3,notes_4,notes_5,notes_6,notes_7)

write.csv(TableD_Property,"./final-outputs/Appendix-Table-CSV/Table D Property.csv",row.names = F)
write.xlsx(TableD_Property,"./final-outputs/Table D Property.xlsx")

#Table E International####
#Raw Data
TableE_International_raw<-subset(rawdata_2019,rawdata_2019$year==2019)
names(TableE_International_raw)

keep<-c("country","dividendexempt","capgainsexemption","divwithhold","intwithhold","roywithhold","taxtreaties","cfcrules","countrylimitations","thincap")
TableE_International_raw<-TableE_International_raw[keep]
TableE_International_raw$cfc_income<-TableE_International_raw$cfcrules
TableE_International_raw$cfc_exemption<-TableE_International_raw$cfcrules

#Text Data
TableE_International_text<-read_csv("./source-data/TableE_International.csv")


colnames(TableE_International_text)<-c("country","dividendexempt","capgainsexemption","countrylimitations","divwithhold","intwithhold","roywithhold",  
                                  "taxtreaties","cfcrules","cfc_exemption","cfc_income","thincap")
TableE_International_text<-TableE_International_text[2:37,]


#Replace raw data with text data for select columns
replace<-c("countrylimitations","cfcrules","cfc_exemption","cfc_income","thincap")
TableE_International_text<-TableE_International_text[replace]
TableE_International<-TableE_International_raw[,!names(TableE_International_raw) %in% replace]
TableE_International<-cbind(TableE_International,TableE_International_text)

TableE_International<-TableE_International[c("country","dividendexempt","capgainsexemption","countrylimitations","divwithhold","intwithhold",  
                                   "roywithhold","taxtreaties","cfcrules","cfc_income","cfc_exemption","thincap")]

#Format variables
#dividendexempt
TableE_International$dividendexempt<-TableE_International$dividendexempt*100
TableE_International$dividendexempt<-paste((formatC(round(TableE_International$dividendexempt,digits=1),format = "f",digits=1)),"%",sep="")


#capgainsexemption
TableE_International$capgainsexemption<-TableE_International$capgainsexemption*100
TableE_International$capgainsexemption<-paste((formatC(round(TableE_International$capgainsexemption,digits=1),format = "f",digits=1)),"%",sep="")

#divwithhold
TableE_International$divwithhold<-TableE_International$divwithhold*100
TableE_International$divwithhold<-paste((formatC(round(TableE_International$divwithhold,digits=1),format = "f",digits=1)),"%",sep="")

#intwithhold
TableE_International$intwithhold<-TableE_International$intwithhold*100
TableE_International$intwithhold<-paste((formatC(round(TableE_International$intwithhold,digits=1),format = "f",digits=1)),"%",sep="")

#roywithhold
TableE_International$roywithhold<-TableE_International$roywithhold*100
TableE_International$roywithhold<-paste((formatC(round(TableE_International$roywithhold,digits=1),format = "f",digits=1)),"%",sep="")


headers<-c("",
           "Participation Exemption",
           "",
           "",
           "Withholding Taxes",
           "",
           "",
           "",
           "International Tax Regulations",
           "",
           "",
           "")

columns<-c("Country",
           "Dividend Exemption",
           "Capital Gains Exemption",
           "Country Limitations",
           "Dividend Withholding Tax",
           "Interest Withholding Tax",
           "Royalties Withholding Tax",
           "Number of Tax Treaties",
           "Controlled Foreign Corporation Rules",
           "Controlled Foreign Corporation Rules: Income",
           "Controlled Foreign Corporation Rules: Exemptions",
           "Interest Deduction Limitations")

TableE_International<-rbind(headers,columns,TableE_International)

write.csv(TableE_International,"./final-outputs/Appendix-Table-CSV/Table E International.csv",row.names = F)
write.xlsx(TableE_International,"./final-outputs/Table E International.xlsx")
