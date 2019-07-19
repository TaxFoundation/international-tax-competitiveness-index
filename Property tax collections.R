# VAT Source Data

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

using(OECD)
using(IMFData)
using(plyr)
using(reshape2)
using(countrycode)
using(tidyverse)
using(readxl)
using(stringr)


#IMF Capital Stock Data

IMF_Capital_Stock_Data <- read_excel("source-data/IMF Capital Stock Data.xlsx", 
                                     sheet = "Data")

IMF_Capital_Stock_Data<-subset(IMF_Capital_Stock_Data,IMF_Capital_Stock_Data$year==2013)

OECD_Countries<-c("AUS",
                  "AUT",
                  "BEL",
                  "CAN",
                  "CHL",
                  "CZE",
                  "DNK",
                  "EST",
                  "FIN",
                  "FRA",
                  "DEU",
                  "GRC",
                  "HUN",
                  "ISL",
                  "IRL",
                  "ISR",
                  "ITA",
                  "JPN",
                  "KOR",
                  "LVA",
                  "LUX",
                  "LTU",
                  "MEX",
                  "NLD",
                  "NZL",
                  "NOR",
                  "POL",
                  "PRT",
                  "SVK",
                  "SVN",
                  "ESP",
                  "SWE",
                  "CHE",
                  "TUR",
                  "GBR",
                  "USA")

IMF_Capital_Stock_Data<-subset(IMF_Capital_Stock_Data,IMF_Capital_Stock_Data$isocode%in% OECD_Countries)
IMF_Capital_Stock_Data$Cap_Stock_13<-IMF_Capital_Stock_Data$kpriv_n
IMF_Capital_Stock_Data$Cap_Stock_13<-as.numeric(IMF_Capital_Stock_Data$Cap_Stock_13)
IMF_Capital_Stock_Data$Cap_Stock_13<-IMF_Capital_Stock_Data$Cap_Stock_13*1000


IFS.available.codes <- DataStructureMethod('IFS') # Get dimension code of IFS dataset
CodeSearch(IFS.available.codes,'CL_INDICATOR_IFS', 'NFI') 


IFS.available.codes$CL_AREA_IFS

databaseID <- 'IFS'
startdate='2013-01-01'
enddate='2018-12-31'
checkquery = FALSE
IFS.available.codes <- DataStructureMethod('IFS')
## All Countries Gross Fixed Capital Formation Millions in National Currency
queryfilter <- list(CL_FREQ="", CL_AREA_IFS="DE", CL_INDICATOR_IFS =c("NFI_SA_XDC"))
GFCF.query <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery)
GFCF.query[,1:5]
germany<-as.data.frame(GFCF.query$Obs[[1]])
GFCF.query$Obs[[2]]

#corprate####
#Table_II1#
dataset_list<-get_datasets()
search_dataset("gross fixed", dataset_list)

dataset<-("SNA_TABLE8A")
dstruc<-get_data_structure(dataset)
str(dstruc, max.level = 1)
dstruc$VAR_DESC
dstruc$TRANSACT
dstruc$ACTIVITY

#