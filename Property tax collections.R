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



#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO-2","ISO-3")
ISO_OECD<-subset(ISO_Country_Codes,ISO_Country_Codes$`ISO-3`%in%OECD_Countries)
ISO_2_OECD<-print(ISO_OECD$`ISO-2`)


databaseID <- 'IFS'
startdate='2013-01-01'
enddate='2013-12-31'
checkquery = FALSE
IFS.available.codes <- DataStructureMethod('IFS')
## All Countries Gross Fixed Capital Formation Millions in National Currency
queryfilter <- list(CL_FREQ="A", CL_AREA_IFS=ISO_2_OECD, CL_INDICATOR_IFS =c("NFI_SA_XDC"))
GFCF_2013<- data.frame(CompactDataMethod(databaseID, queryfilter, '2013-01-01', '2013-12-31', checkquery))
GFCF_2013<-data.frame(GFCF_2013$X.REF_AREA,unnest(GFCF_2013$Obs))
colnames(GFCF_2013)<-c("ISO-2","year","Gross_Fixed_Cap_Form")

GFCF_2014<- data.frame(CompactDataMethod(databaseID, queryfilter, '2014-01-01', '2014-12-31', checkquery))
GFCF_2014<-data.frame(GFCF_2014$X.REF_AREA,unnest(GFCF_2014$Obs))
colnames(GFCF_2014)<-c("ISO-2","year","Gross_Fixed_Cap_Form")

GFCF_2015<- data.frame(CompactDataMethod(databaseID, queryfilter, '2015-01-01', '2015-12-31', checkquery))
GFCF_2015<-data.frame(GFCF_2015$X.REF_AREA,unnest(GFCF_2015$Obs))
colnames(GFCF_2015)<-c("ISO-2","year","Gross_Fixed_Cap_Form")

GFCF_2016<- data.frame(CompactDataMethod(databaseID, queryfilter, '2016-01-01', '2016-12-31', checkquery))
GFCF_2016<-data.frame(GFCF_2016$X.REF_AREA,unnest(GFCF_2016$Obs))
colnames(GFCF_2016)<-c("ISO-2","year","Gross_Fixed_Cap_Form")

GFCF_2017<- data.frame(CompactDataMethod(databaseID, queryfilter, '2017-01-01', '2017-12-31', checkquery))
GFCF_2017<-data.frame(GFCF_2017$X.REF_AREA,unnest(GFCF_2017$Obs))
colnames(GFCF_2017)<-c("ISO-2","year","Gross_Fixed_Cap_Form")

GFCF_2018<- data.frame(CompactDataMethod(databaseID, queryfilter, '2018-01-01', '2018-12-31', checkquery))
GFCF_2018<-data.frame(GFCF_2018$X.REF_AREA,unnest(GFCF_2018$Obs))
colnames(GFCF_2018)<-c("ISO-2","year","Gross_Fixed_Cap_Form")


GFCF<-rbind(GFCF_2013,GFCF_2014,GFCF_2015,GFCF_2016,GFCF_2017,GFCF_2018)
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