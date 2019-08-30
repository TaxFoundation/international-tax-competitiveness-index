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

variable_names<-c("ISO_2","ISO_3","country",
                "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                "vat_rate","vat_threshold","vat_base","consumption_time",
                "property_tax", "collections_property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","controlled_foreign_corporation_rules","thin_capitalization_rules")


indexdata2014<-read_csv("./source-data/indexdata2014.csv")
colnames(indexdata2014)<-variable_names
write.csv(indexdata2014,"./source-data/indexdata2014.csv",row.names = F)

indexdata2015<-read_csv("./source-data/indexdata2015.csv")
colnames(indexdata2015)<-variable_names
write.csv(indexdata2015,"./source-data/indexdata2015.csv",row.names = F)

indexdata2016<-read_csv("./source-data/indexdata2016.csv")
colnames(indexdata2016)<-variable_names
write.csv(indexdata2016,"./source-data/indexdata2016.csv",row.names = F)

indexdata2017<-read_csv("./source-data/indexdata2017.csv")
colnames(indexdata2017)<-variable_names
write.csv(indexdata2017,"./source-data/indexdata2017.csv",row.names = F)

indexdata2018<-read_csv("./source-data/indexdata2018.csv")
colnames(indexdata2018)<-variable_names
write.csv(indexdata2018,"./source-data/indexdata2018.csv",row.names = F)

indexdata2019<-read_csv("./source-data/indexdata2019.csv")
colnames(indexdata2019)<-variable_names
write.csv(indexdata2019,"./source-data/indexdata2019.csv",row.names = F)