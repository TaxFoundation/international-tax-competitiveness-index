#output tables code
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

raw_data_2019 <- read_csv("./final-outputs/raw_data_2019.csv")

final_2017 <- read_csv("./final-outputs/data_2017_run.csv")
final_2018 <- read_csv("./final-outputs/data_2018_run.csv")
final_2019 <- read_csv("./final-outputs/data_2019_run.csv")

subcategories_2019 <- read_csv("./final-outputs/subcategories_2019.csv")

###Table 1 Results####
table_1_results<-final_2019

#Select variables
keep<-c("country","final_rank","final","corporate_rank","income_rank","consumption_rank","property_rank","international_rank")
table_1_results<-table_1_results[keep]

#Sort by rank
table_1_results<-table_1_results[order(table_1_results$final_rank),]

#Format columns
table_1_results$final<-formatC(round(table_1_results$final,digits=1),format = "f",digits=1)


colnames(table_1_results)<-c("Country",
                             "Overall Rank",
                             "Overall Score",
                             "Corporate Tax Rank", 
                             "Individual Taxes Rank", 
                             "Consumption Taxes Rank", 
                             "Property Taxes Rank", 
                             "International Tax Rules Rank")


write.csv(table_1_results,"./final-outputs/table_1_results.csv",row.names=F)

###Table 2 Changes####
table_2_changes<-merge(final_2018,final_2019,by="country")
keep<-c("country","final_rank.x","final.x","final_rank.y","final.y")

table_2_changes<-table_2_changes[keep]

colnames(table_2_changes)<-c("country", "2018 Rank","2018 Score","2019 Rank","2019 Score")

table_2_changes<-merge(final_2017,table_2_changes,by="country")
keep<-c("country","final_rank","final","2018 Rank","2018 Score","2019 Rank","2019 Score")

table_2_changes<-table_2_changes[keep]

colnames(table_2_changes)<-c("Country","2017 Rank","2017 Score", "2018 Rank","2018 Score","2019 Rank","2019 Score")

table_2_changes$'Change in Rank from 2018 to 2019'<-(table_2_changes$`2019 Rank`-table_2_changes$`2018 Rank`)*(-1)
table_2_changes$'Change in Score from 2018 to 2019'<-table_2_changes$`2019 Score`-table_2_changes$`2018 Score`

#Format Columns

table_2_changes$`2017 Score`<-formatC(round(table_2_changes$`2017 Score`,digits=1),format = "f",digits=1)
table_2_changes$`2018 Score`<-formatC(round(table_2_changes$`2018 Score`,digits=1),format = "f",digits=1)
table_2_changes$`2019 Score`<-formatC(round(table_2_changes$`2019 Score`,digits=1),format = "f",digits=1)
table_2_changes$`Change in Score`<-formatC(round(table_2_changes$`Change in Score`,digits=1),format = "f",digits=1)


write.csv(table_2_changes,"./final-outputs/table_2_changes.csv",row.names=F)

###Table 3 Corporate####
table_3_corporate<-subcategories_2019
table_3_corporate<-merge(table_3_corporate,final_2019,by=c("country"))

keep<-c("country","corporate_rank","corporate","corporate_rate_rank","corporate_rate","cost_recovery_rank","cost_recovery","incentives_rank","incentives")
table_3_corporate<-table_3_corporate[keep]
colnames(table_3_corporate)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Cost Recovery Rank","Cost Recovery Score","Incentives/Complexity Rank","Incentives/Complexity Score")

#Format Columns

table_3_corporate$`Overall Score`<-formatC(round(table_3_corporate$`Overall Score`,digits=1),format = "f",digits=1)
table_3_corporate$`Rate Score`<-formatC(round(table_3_corporate$`Rate Score`,digits=1),format = "f",digits=1)
table_3_corporate$`Cost Recovery Score`<-formatC(round(table_3_corporate$`Cost Recovery Score`,digits=1),format = "f",digits=1)
table_3_corporate$`Incentives/Complexity Score`<-formatC(round(table_3_corporate$`Incentives/Complexity Score`,digits=1),format = "f",digits=1)

write.csv(table_3_corporate,"./final-outputs/table_3_corporate.csv",row.names=F)


###Table 4 Individual####
table_4_individual<-subcategories_2019
table_4_individual<-merge(table_4_individual,final_2019,by=c("country"))

#names(table_4_individual)

keep<-c("country","income_rank","income","income_tax_rank","income_tax","income_tax_complexity_rank","income_tax_complexity","capital_gains_and_dividends_rank","capital_gains_and_dividends")
table_4_individual<-table_4_individual[keep]
colnames(table_4_individual)<-c("Country","Overall Rank","Overall Score","Income Tax Rank","Income Tax Score","Complexity Rank","Complexity Score", "Capital Gains/Dividends Rank","Capital Gains/Dividends Score")

table_4_individual$`Overall Score`<-formatC(round(table_4_individual$`Overall Score`,digits=1),format = "f",digits=1)
table_4_individual$`Income Tax Score`<-formatC(round(table_4_individual$`Income Tax Score`,digits=1),format = "f",digits=1)
table_4_individual$`Complexity Score`<-formatC(round(table_4_individual$`Complexity Score`,digits=1),format = "f",digits=1)
table_4_individual$`Capital Gains/Dividends Score`<-formatC(round(table_4_individual$`Capital Gains/Dividends Score`,digits=1),format = "f",digits=1)


write.csv(table_4_individual,"./final-outputs/table_4_individual.csv",row.names=F)

###Table 5 Consumption####
table_5_consumption<-subcategories_2019
table_5_consumption<-merge(table_5_consumption,final_2019,by=c("country"))

#names(table_5_consumption)

keep<-c("country","consumption_rank","consumption","consumption_tax_rate_rank","consumption_tax_rate","consumption_tax_base_rank","consumption_tax_base","consumption_tax_complexity_rank","consumption_tax_complexity")
table_5_consumption<-table_5_consumption[keep]
colnames(table_5_consumption)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Base Rank","Base Score","Complexity Rank","Complexity Score")


table_5_consumption$`Overall Score`<-formatC(round(table_5_consumption$`Overall Score`,digits=1),format = "f",digits=1)
table_5_consumption$`Rate Score`<-formatC(round(table_5_consumption$`Rate Score`,digits=1),format = "f",digits=1)
table_5_consumption$`Base Score`<-formatC(round(table_5_consumption$`Base Score`,digits=1),format = "f",digits=1)
table_5_consumption$`Complexity Score`<-formatC(round(table_5_consumption$`Complexity Score`,digits=1),format = "f",digits=1)



write.csv(table_5_consumption,"./final-outputs/table_5_consumption.csv",row.names=F)

###Table 6 Property####
table_6_property<-subcategories_2019
table_6_property<-merge(table_6_property,final_2019,by=c("country"))

#names(table_6_property)

keep<-c("country","property_rank","property","real_property_tax_rank","real_property_tax","wealth_taxes_rank","wealth_taxes","capital_taxes_rank","capital_taxes")
table_6_property<-table_6_property[keep]
colnames(table_6_property)<-c("Country","Overall Rank","Overall Score", "Real Property Taxes Rank","Real Property Taxes Score","Wealth/Estate Taxes Rank","Wealth/Estate Taxes Score","Capital/Transaction Taxes Rank","Capital/Transaction Taxes Score")


table_6_property$`Overall Score`<-formatC(round(table_6_property$`Overall Score`,digits=1),format = "f",digits=1)
table_6_property$`Real Property Taxes Score`<-formatC(round(table_6_property$`Real Property Taxes Score`,digits=1),format = "f",digits=1)
table_6_property$`Wealth/Estate Taxes Score`<-formatC(round(table_6_property$`Wealth/Estate Taxes Score`,digits=1),format = "f",digits=1)
table_6_property$`Capital/Transaction Taxes Score`<-formatC(round(table_6_property$`Capital/Transaction Taxes Score`,digits=1),format = "f",digits=1)



write.csv(table_6_property,"./final-outputs/table_6_property.csv",row.names=F)

###Table 7 International####
table_7_international<-subcategories_2019
table_7_international<-merge(table_7_international,final_2019,by=c("country"))

#names(table_7_international)

keep<-c("country","international_rank","international","territorial_rank","territorial","withholding_taxes_rank","withholding_taxes","international_regulations_rank","international_regulations")
table_7_international<-table_7_international[keep]
colnames(table_7_international)<-c("Country","Overall Rank","Overall Score", "Div/Cap Gains Exemption Rank","Div/Cap Gains Exemption Score","Withholding Taxes Rank","Withholding Taxes Score","Regulations Rank","Regulations Score")


table_7_international$`Overall Score`<-formatC(round(table_7_international$`Overall Score`,digits=1),format = "f",digits=1)
table_7_international$`Div/Cap Gains Exemption Score`<-formatC(round(table_7_international$`Div/Cap Gains Exemption Score`,digits=1),format = "f",digits=1)
table_7_international$`Withholding Taxes Score`<-formatC(round(table_7_international$`Withholding Taxes Score`,digits=1),format = "f",digits=1)
table_7_international$`Regulations Score`<-formatC(round(table_7_international$`Regulations Score`,digits=1),format = "f",digits=1)


write.csv(table_7_international,"./final-outputs/table_7_international.csv",row.names=F)

###Table A Coprorate####

#Raw Data
table_a_corporate_raw<-subset(raw_data_2019,raw_data_2019$year==2019)


keep<-c("country",
        "corporate_rate",
        "loss_carryback",
        "loss_carryforward",
        "machines_cost_recovery",
        "buildings_cost_recovery",
        "intangibles_cost_recovery",
        "inventory",
        "patent_box",
        "r_and_d_credit",
        "corporate_time",
        "profit_payments",
        "other_payments")
table_a_corporate_raw<-table_a_corporate_raw[keep]


#Text Data
table_a_corporate_text<-read_csv("./source-data/table_a_corporate.csv")
colnames(table_a_corporate_text)<-names(table_a_corporate_raw)
table_a_corporate_text<-table_a_corporate_text[2:37,]



#Replace raw data with text data for select columns
replace<-c("loss_carryback","loss_carryforward","inventory","r_and_d_credit")
table_a_corporate_text<-table_a_corporate_text[replace]
table_a_corporate<-table_a_corporate_raw[,!names(table_a_corporate_raw) %in% replace]
table_a_corporate<-cbind(table_a_corporate,table_a_corporate_text)

table_a_corporate<-table_a_corporate[c("country","corporate_rate",
                                     "loss_carryback",
                                     "loss_carryforward",
                                     "machines_cost_recovery",
                                     "buildings_cost_recovery",
                                     "intangibles_cost_recovery",
                                     "inventory",
                                     "patent_box",
                                     "r_and_d_credit",
                                     "corporate_time",
                                     "profit_payments",
                                     "other_payments")]



#Format variables
#corporate_rate
table_a_corporate$corporate_rate<-table_a_corporate$corporate_rate*100
table_a_corporate$corporate_rate<-paste((formatC(round(table_a_corporate$corporate_rate,digits=1),format = "f",digits=1)),"%",sep="")

#machines_cost_recovery
table_a_corporate$machines_cost_recovery<-table_a_corporate$machines_cost_recovery*100
table_a_corporate$machines_cost_recovery<-paste((formatC(round(table_a_corporate$machines_cost_recovery,digits=1),format = "f",digits=1)),"%",sep="")

#buildings_cost_recovery
table_a_corporate$buildings_cost_recovery<-table_a_corporate$buildings_cost_recovery*100
table_a_corporate$buildings_cost_recovery<-paste((formatC(round(table_a_corporate$buildings_cost_recovery,digits=1),format = "f",digits=1)),"%",sep="")

#intangibles_cost_recovery
table_a_corporate$intangibles_cost_recovery<-table_a_corporate$intangibles_cost_recovery*100
table_a_corporate$intangibles_cost_recovery<-paste((formatC(round(table_a_corporate$intangibles_cost_recovery,digits=1),format = "f",digits=1)),"%",sep="")

#patent_box
table_a_corporate$patent_box<-if_else(table_a_corporate$patent_box==0,"No","Yes")

#corporate_time
table_a_corporate$corporate_time<-formatC(round(table_a_corporate$corporate_time,digits=0),format = "f",digits=0)


#profit_payments
table_a_corporate$profit_payments<-formatC(round(table_a_corporate$profit_payments,digits=0),format = "f",digits=0)


#other_payments
table_a_corporate$other_payments<-formatC(round(table_a_corporate$other_payments,digits=0),format = "f",digits=0)


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

table_a_corporate<-rbind(headers,columns,table_a_corporate)

write.csv(table_a_corporate,"./final-outputs/table_a_corporate.csv",row.names = F)

#Table B Individual####

#Raw Data
table_b_individual_raw<-subset(raw_data_2019,raw_data_2019$year==2019)
#names(table_b_individual_raw)

keep<-c("country","top_income_rate",
        "threshold_top_income_rate",
        "tax_wedge",
        "labor_payments",
        "labor_time",
        "capital_gains_rate",
        "dividends_rate")
table_b_individual<-table_b_individual_raw[keep]


#Format variables
#top_income_rate
table_b_individual$top_income_rate<-table_b_individual$top_income_rate*100
table_b_individual$top_income_rate<-paste((formatC(round(table_b_individual$top_income_rate,digits=1),format = "f",digits=1)),"%",sep="")

#threshold_top_income_rate
table_b_individual$threshold_top_income_rate<-(formatC(round(table_b_individual$threshold_top_income_rate,digits=1),format = "f",digits=1))

#tax_wedge
table_b_individual$tax_wedge<-(formatC(round(table_b_individual$tax_wedge,digits=1),format = "f",digits=1))

#labor_payments
table_b_individual$labor_payments<-(formatC(round(table_b_individual$labor_payments,digits=0),format = "f",digits=0))

#labor_time
table_b_individual$labor_time<-(formatC(round(table_b_individual$labor_time,digits=0),format = "f",digits=0))

#capital_gains_rate
table_b_individual$capital_gains_rate<-table_b_individual$capital_gains_rate*100
table_b_individual$capital_gains_rate<-paste((formatC(round(table_b_individual$capital_gains_rate,digits=1),format = "f",digits=1)),"%",sep="")

#dividends_rate
table_b_individual$dividends_rate<-table_b_individual$dividends_rate*100
table_b_individual$dividends_rate<-paste((formatC(round(table_b_individual$dividends_rate,digits=1),format = "f",digits=1)),"%",sep="")

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

notes_2<-c("(a) Multiple of the average income at which the highest tax bracket applies, in U.S. dollars in Purchasing Power Parity (PPP).",
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
table_b_individual<-rbind(headers,columns,table_b_individual,notes_1,notes_2,notes_3)

write.csv(table_b_individual,"./final-outputs/table_b_individual.csv",row.names = F)

#Table C Consumption####
#Raw Data
table_c_consumption_raw<-subset(raw_data_2019,raw_data_2019$year==2019)
#names(table_c_consumption_raw)

keep<-c("country","vat_rate",
        "vat_threshold",
        "vat_base",
        "consumption_time")
table_c_consumption<-table_c_consumption_raw[keep]

#Format variables
#vat_rate
table_c_consumption$vat_rate<-paste((formatC(round(table_c_consumption$vat_rate,digits=1),format = "f",digits=1)),"%",sep="")

#vat_threshold
table_c_consumption$vat_threshold<-dollar(table_c_consumption$vat_threshold,largest_with_cents = 1)

#vat_base
table_c_consumption$vat_base<-table_c_consumption$vat_base*100
table_c_consumption$vat_base<-paste((formatC(round(table_c_consumption$vat_base,digits=1),format = "f",digits=1)),"%",sep="")

#consumption_time
table_c_consumption$consumption_time<-formatC(round(table_c_consumption$consumption_time,digits=0),format = "f",digits=0)

#fix US and Canada to add footnote markers
table_c_consumption$vat_rate[4]<-paste0(table_c_consumption$vat_rate[4]," (b)")
table_c_consumption$vat_rate[36]<-paste0(table_c_consumption$vat_rate[36]," (c)")

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

notes_2<-c("(a) In U.S. dollars (PPP).",
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
table_c_consumption<-rbind(headers,columns,table_c_consumption,notes_1,notes_2,notes_3,notes_4)

write.csv(table_c_consumption,"./final-outputs/table_c_consumption.csv",row.names = F)

#Table D Property####
#Raw Data
TableD_Property_raw<-subset(raw_data_2019,raw_data_2019$year==2019)
#names(TableD_Property_raw)

keep<-c("country","property_tax", 
        "property_tax_collections",
        "net_wealth",
        "estate_or_inheritance_tax",
        "transfer_tax",
        "asset_tax",
        "capital_duties",
        "financial_transaction_tax")
TableD_Property_raw<-TableD_Property_raw[keep]
TableD_Property_raw$property_taxes_deductible<-if_else(TableD_Property_raw$property_tax==0.5,1,0)

#Text Data
TableD_Property_text<-read_csv("./source-data/TableD_Property.csv")


colnames(TableD_Property_text)<-c("country","property_tax",
                                  "property_taxes_deductible",
                                  "property_tax_collections",
                                  "net_wealth",
                                  "estate_or_inheritance_tax",
                                  "transfer_tax",
                                  "asset_tax",
                                  "capital_duties",
                                  "financial_transaction_tax")
TableD_Property_text<-TableD_Property_text[2:37,]


#Replace raw data with text data for select columns
replace<-c("property_tax","estate_or_inheritance_tax","transfer_tax","asset_tax")
TableD_Property_text<-TableD_Property_text[replace]
TableD_Property<-TableD_Property_raw[,!names(TableD_Property_raw) %in% replace]
TableD_Property<-cbind(TableD_Property,TableD_Property_text)

TableD_Property<-TableD_Property[c("country","property_tax", 
                                   "property_taxes_deductible",
                                   "property_tax_collections",
                                   "net_wealth",
                                   "estate_or_inheritance_tax",
                                   "transfer_tax",
                                   "asset_tax",
                                   "capital_duties",
                                   "financial_transaction_tax")]

#Format variables
#property_taxes_deductible
TableD_Property$property_taxes_deductible<-if_else(TableD_Property$property_taxes_deductible==1,"Yes","No")

#property_tax_collections
TableD_Property$property_tax_collections<-paste((formatC(round(TableD_Property$property_tax_collections,digits=1),format = "f",digits=1)),"%",sep="")

#net_wealth
TableD_Property$net_wealth<-if_else(TableD_Property$net_wealth==1,"Yes","No")

#capital_duties
TableD_Property$capital_duties<-if_else(TableD_Property$capital_duties==1,"Yes","No")

#financial_transaction_tax
TableD_Property$financial_transaction_tax<-if_else(TableD_Property$financial_transaction_tax==1,"Yes","No")


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
           "Real Property Taxes property_taxes_deductible",
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

write.csv(TableD_Property,"./final-outputs/Table D Property.csv",row.names = F)

#Table E International####
#Raw Data
TableE_International_raw<-subset(raw_data_2019,raw_data_2019$year==2019)
names(TableE_International_raw)

keep<-c("country",
        "dividends_exemption",
        "capital_gains_exemption",
        "country_limitations",
        "dividends_withholding_tax",
        "interest_withholding_tax",
        "royalties_withholding_tax",
        "tax_treaties",
        "cfc_rules",
        "thin_capitalization_rules")
TableE_International_raw<-TableE_International_raw[keep]
TableE_International_raw$cfc_income<-TableE_International_raw$cfc_rules
TableE_International_raw$cfc_exemption<-TableE_International_raw$cfc_rules

#Text Data
TableE_International_text<-read_csv("./source-data/TableE_International.csv")


colnames(TableE_International_text)<-c("country",
                                       "dividends_exemption",
                                       "capital_gains_exemption",
                                       "country_limitations",
                                       "dividends_withholding_tax",
                                       "interest_withholding_tax",
                                       "royalties_withholding_tax",
                                       "tax_treaties",
                                       "cfc_rules",
                                       "cfc_income",
                                       "cfc_exemption",
                                       "thin_capitalization_rules")
TableE_International_text<-TableE_International_text[2:37,]


#Replace raw data with text data for select columns
replace<-c("country_limitations","cfc_rules","cfc_exemption","cfc_income","thin_capitalization_rules")
TableE_International_text<-TableE_International_text[replace]
TableE_International<-TableE_International_raw[,!names(TableE_International_raw) %in% replace]
TableE_International<-cbind(TableE_International,TableE_International_text)

TableE_International<-TableE_International[c("country",
                                             "dividends_exemption",
                                             "capital_gains_exemption",
                                             "country_limitations",
                                             "dividends_withholding_tax",
                                             "interest_withholding_tax",
                                             "royalties_withholding_tax",
                                             "tax_treaties",
                                             "cfc_rules",
                                             "cfc_income",
                                             "cfc_exemption",
                                             "thin_capitalization_rules")]

#Format variables
#dividends_exemption
TableE_International$dividends_exemption<-TableE_International$dividends_exemption*100
TableE_International$dividends_exemption<-paste((formatC(round(TableE_International$dividends_exemption,digits=1),format = "f",digits=1)),"%",sep="")


#capital_gains_exemption
TableE_International$capital_gains_exemption<-TableE_International$capital_gains_exemption*100
TableE_International$capital_gains_exemption<-paste((formatC(round(TableE_International$capital_gains_exemption,digits=1),format = "f",digits=1)),"%",sep="")

#dividends_withholding_tax
TableE_International$dividends_withholding_tax<-TableE_International$dividends_withholding_tax*100
TableE_International$dividends_withholding_tax<-paste((formatC(round(TableE_International$dividends_withholding_tax,digits=1),format = "f",digits=1)),"%",sep="")

#interest_withholding_tax
TableE_International$interest_withholding_tax<-TableE_International$interest_withholding_tax*100
TableE_International$interest_withholding_tax<-paste((formatC(round(TableE_International$interest_withholding_tax,digits=1),format = "f",digits=1)),"%",sep="")

#royalties_withholding_tax
TableE_International$royalties_withholding_tax<-TableE_International$royalties_withholding_tax*100
TableE_International$royalties_withholding_tax<-paste((formatC(round(TableE_International$royalties_withholding_tax,digits=1),format = "f",digits=1)),"%",sep="")


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

write.csv(TableE_International,"./final-outputs/Table E International.csv",row.names = F)
