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

using(plyr)
using(dplyr)
using(tidyverse)
using(readxl)
using(xlsx)
using(scales)

#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO-2","ISO-3")

#Reordering columns for source data####

indexdata2014<-read_csv("./source-data/indexdata2014.csv")

indexdata2014<-merge(indexdata2014,ISO_Country_Codes,by=c("country"))
indexdata2014<-indexdata2014[c("ISO-2","ISO-3","country",
                               "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                               "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                               "vat_rate","threshold_vat","base_vat","consumption_time",
                               "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                               "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]

write.csv(indexdata2014,"./source-data/indexdata2014.csv",row.names = F)

indexdata2015<-read_csv("./source-data/indexdata2015.csv")
indexdata2015<-merge(indexdata2015,ISO_Country_Codes,by=c("country"))
indexdata2015<-indexdata2015[c("ISO-2","ISO-3","country",
                               "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                               "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                               "vat_rate","threshold_vat","base_vat","consumption_time",
                               "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                               "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]
write.csv(indexdata2015,"./source-data/indexdata2015.csv",row.names = F)


indexdata2016<-read_csv("./source-data/indexdata2016.csv")
indexdata2016<-merge(indexdata2016,ISO_Country_Codes,by=c("country"))
indexdata2016<-indexdata2016[c("ISO-2","ISO-3","country",
                               "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                               "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                               "vat_rate","threshold_vat","base_vat","consumption_time",
                               "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                               "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]
write.csv(indexdata2016,"./source-data/indexdata2016.csv",row.names = F)



indexdata2017<-read_csv("./source-data/indexdata2017.csv")
indexdata2017<-merge(indexdata2017,ISO_Country_Codes,by=c("country"))
indexdata2017<-indexdata2017[c("ISO-2","ISO-3","country",
                               "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                               "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                               "vat_rate","threshold_vat","base_vat","consumption_time",
                               "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                               "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]
write.csv(indexdata2017,"./source-data/indexdata2017.csv",row.names = F)


indexdata2018<-read_csv("./source-data/indexdata2018.csv")
indexdata2018<-merge(indexdata2018,ISO_Country_Codes,by=c("country"))
indexdata2018<-indexdata2018[c("ISO-2","ISO-3","country",
                               "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                               "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                               "vat_rate","threshold_vat","base_vat","consumption_time",
                               "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                               "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]
write.csv(indexdata2018,"./source-data/indexdata2018.csv",row.names = F)


indexdata2019<-read_csv("./source-data/indexdata2019.csv")
indexdata2019<-merge(indexdata2019,ISO_Country_Codes,by=c("country"))
indexdata2019<-indexdata2019[c("ISO-2","ISO-3","country",
                               "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                               "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                               "vat_rate","threshold_vat","base_vat","consumption_time",
                               "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                               "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules"   )]
write.csv(indexdata2019,"./source-data/indexdata2019.csv",row.names = F)

