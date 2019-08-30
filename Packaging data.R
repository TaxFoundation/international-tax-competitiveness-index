#Packaging Data

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clears all datasets and variables from memory
rm(list=ls())

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

using(readr)
using(tidyverse)

CFC_Rules<-read_csv("./intermediate-outputs/CFC Rules Data.csv")
OECD_vars<-read_csv("./intermediate-outputs/OECDvars_data.csv")
Cap_Allowances<-read_csv("./intermediate-outputs/cap_allowances_data.csv")
vat_data<-read_csv("./intermediate-outputs/vat_data.csv")
Property_Tax<-read_csv("./intermediate-outputs/Property_Tax.csv")


indexdata2014<-read_csv("./source-data/indexdata2014.csv")
indexdata2014$year<-2014

indexdata2015<-read_csv("./source-data/indexdata2015.csv")
indexdata2015$year<-2015

indexdata2016<-read_csv("./source-data/indexdata2016.csv")
indexdata2016$year<-2016

indexdata2017<-read_csv("./source-data/indexdata2017.csv")
indexdata2017$year<-2017

indexdata2018<-read_csv("./source-data/indexdata2018.csv")
indexdata2018$year<-2018

indexdata2019<-read_csv("./source-data/indexdata2019.csv")
indexdata2019$year<-2019

indexdata_old<-rbind(indexdata2014,indexdata2015,indexdata2016,indexdata2017,indexdata2018,indexdata2019)


#Remove variables from indexdata_old that are in OECD data
OECDvars<-c("corporate_rate","top_income_rate", "threshold_top_income_rate", "tax_wedge","dividends_rate" )
indexdata_old<-indexdata_old[,!names(indexdata_old) %in% OECDvars]

#Join OECD data with indexdata_old####

indexdata_OECD_vars<-merge(indexdata_old,OECD_vars,by=c("country","ISO_2","ISO_3","year"))


#Join cap allowances data with indexdata2019####

Cap_Allowances_Vars<-c("machines_cost_recovery","buildings_cost_recovery", "intangibles_cost_recovery")
colnames(Cap_Allowances)<-c("ISO_3","year","machines_cost_recovery","buildings_cost_recovery", "intangibles_cost_recovery")

indexdata_OECD_vars<-indexdata_OECD_vars[,!names(indexdata_OECD_vars) %in% Cap_Allowances_Vars]

indexdata_cap_a_vars<-merge(indexdata_OECD_vars,Cap_Allowances,by=c("ISO_3","year"))

#Join VAT data with indexdata_cap_a_vars####

#Remove variables from indexdata_old that are in VAT data

vat_vars<-c("vat_rate","vat_threshold", "vat_base")
indexdata_cap_a_vars<-indexdata_cap_a_vars[,!names(indexdata_cap_a_vars) %in% vat_vars]

indexdata_VAT_vars<-merge(indexdata_cap_a_vars,vat_data,by=c("country","year"))

#Join Property tax data with indexdata_cap_a_vars####
prop_tax_vars<-c("property_tax_collections")

#Adjust years in Property tax data to account for two year lag
Property_Tax$year<-Property_Tax$year+2
Property_Tax<-Property_Tax[c("country","year","property_tax_collections")]
indexdata_VAT_vars<-indexdata_VAT_vars[,!names(indexdata_VAT_vars) %in% prop_tax_vars]
indexdata_prop_tax_vars<-merge(indexdata_VAT_vars,Property_Tax,by=c("country","year"))

#Join CFC rules data with indexdata2019####
CFC_Rules<-CFC_Rules[-c(2:4,7:8)]

CFC_Rules_var<-c("cfcrules")
indexdata_prop_tax_vars<-indexdata_prop_tax_vars[,!names(indexdata_prop_tax_vars) %in% CFC_Rules_var]

indexdata_CFC_var<-merge(indexdata_prop_tax_vars,CFC_Rules,by=c("country","year"))



indexdata_final<-indexdata_CFC_var

#Reorder columns ####
indexdata_final<-indexdata_final[c("ISO_2","ISO_3","country",
                                   "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                                   "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                                   "vat_rate","threshold_vat","base_vat","consumption_time",
                                   "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                                   "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]

write.csv(subset(indexdata_final,indexdata_final$year==2014),file = "./final-data/final_indexdata2014.csv",row.names=F)
write.csv(subset(indexdata_final,indexdata_final$year==2015),file = "./final-data/final_indexdata2015.csv",row.names=F)
write.csv(subset(indexdata_final,indexdata_final$year==2016),file = "./final-data/final_indexdata2016.csv",row.names=F)
write.csv(subset(indexdata_final,indexdata_final$year==2017),file = "./final-data/final_indexdata2017.csv",row.names=F)
write.csv(subset(indexdata_final,indexdata_final$year==2018),file = "./final-data/final_indexdata2018.csv",row.names=F)
write.csv(subset(indexdata_final,indexdata_final$year==2019),file = "./final-data/final_indexdata2019.csv",row.names=F)
