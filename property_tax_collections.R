# Property Tax Collections Source Data

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

IMF_Capital_Stock_Data<-subset(IMF_Capital_Stock_Data,IMF_Capital_Stock_Data$year>2011)

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
IMF_Capital_Stock_Data$Cap_Stock<-IMF_Capital_Stock_Data$kpriv_n
IMF_Capital_Stock_Data$Cap_Stock<-as.numeric(IMF_Capital_Stock_Data$Cap_Stock)
IMF_Capital_Stock_Data$Cap_Stock<-(IMF_Capital_Stock_Data$Cap_Stock)*1000


IMF_Capital_Stock_Data<-IMF_Capital_Stock_Data[c("isocode","country","year","Cap_Stock")]
IMF_Capital_Stock_Data<-subset(IMF_Capital_Stock_Data,IMF_Capital_Stock_Data$year!=2015)


#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO_2","ISO_3")
ISO_OECD<-subset(ISO_Country_Codes,ISO_Country_Codes$ISO_3%in%OECD_Countries)
ISO_2_OECD<-print(ISO_OECD$ISO_2)


databaseID <- 'IFS'
checkquery = FALSE
IFS.available.codes <- DataStructureMethod('IFS')
## All OECD Countries Gross Fixed Capital Formation Millions in National Currency
queryfilter <- list(CL_FREQ="A", CL_AREA_IFS=ISO_2_OECD, CL_INDICATOR_IFS =c("NFI_SA_XDC"))

GFCF_2014<- data.frame(CompactDataMethod(databaseID, queryfilter, '2014-01-01', '2014-12-31', checkquery))
GFCF_2014<-data.frame(GFCF_2014$X.REF_AREA,unnest(GFCF_2014$Obs))
colnames(GFCF_2014)<-c("ISO_2","year","Gross_Fixed_Cap_Form")


GFCF_2015<- data.frame(CompactDataMethod(databaseID, queryfilter, '2015-01-01', '2015-12-31', checkquery))
GFCF_2015<-data.frame(GFCF_2015$X.REF_AREA,unnest(GFCF_2015$Obs))
colnames(GFCF_2015)<-c("ISO_2","year","Gross_Fixed_Cap_Form")

GFCF_2016<- data.frame(CompactDataMethod(databaseID, queryfilter, '2016-01-01', '2016-12-31', checkquery))
GFCF_2016<-data.frame(GFCF_2016$X.REF_AREA,unnest(GFCF_2016$Obs))
colnames(GFCF_2016)<-c("ISO_2","year","Gross_Fixed_Cap_Form")

GFCF_2017<- data.frame(CompactDataMethod(databaseID, queryfilter, '2017-01-01', '2017-12-31', checkquery))
GFCF_2017<-data.frame(GFCF_2017$X.REF_AREA,unnest(GFCF_2017$Obs))
colnames(GFCF_2017)<-c("ISO_2","year","Gross_Fixed_Cap_Form")

GFCF<-rbind(GFCF_2014,GFCF_2015,GFCF_2016,GFCF_2017)
GFCF<-merge(GFCF,ISO_Country_Codes,by="ISO_2")
GFCF$Gross_Fixed_Cap_Form<-as.numeric(GFCF$Gross_Fixed_Cap_Form)

#Depreciate capital stock and add GFCF

#2015
Cap_Stock_15<-merge(subset(GFCF,GFCF$year==2014),subset(IMF_Capital_Stock_Data,IMF_Capital_Stock_Data$year==2014),by="country")
Cap_Stock_15$year<-"2015"
Cap_Stock_15$Cap_Stock<-(Cap_Stock_15$Cap_Stock*(1-.1077))+(Cap_Stock_15$Gross_Fixed_Cap_Form*(1-(.1077/2)))
Cap_Stock_15<-Cap_Stock_15[c("country","isocode","year","Cap_Stock")]

#2016
Cap_Stock_16<-merge(subset(GFCF,GFCF$year==2015),subset(Cap_Stock_15),by="country")
Cap_Stock_16$year<-"2016"
Cap_Stock_16$Cap_Stock<-(Cap_Stock_16$Cap_Stock*(1-.1077))+(Cap_Stock_16$Gross_Fixed_Cap_Form*(1-(.1077/2)))
Cap_Stock_16<-Cap_Stock_16[c("country","isocode","year","Cap_Stock")]

#2017
Cap_Stock_17<-merge(subset(GFCF,GFCF$year==2016),Cap_Stock_16,by="country")
Cap_Stock_17$year<-"2017"
Cap_Stock_17$Cap_Stock<-(Cap_Stock_17$Cap_Stock*(1-.1077))+(Cap_Stock_17$Gross_Fixed_Cap_Form*(1-(.1077/2)))
Cap_Stock_17<-Cap_Stock_17[c("country","isocode","year","Cap_Stock")]

Cap_Stock_12_17<-rbind(IMF_Capital_Stock_Data,Cap_Stock_15,Cap_Stock_16,Cap_Stock_17)


#property tax revenues####
#Table_II1#
dataset_list<-get_datasets()
#search_dataset("revenues", dataset_list)

#dataset<-("REV")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$TAX
#dstruc$TRANSACT
#dstruc$GOV

Property_Tax_Rev<-get_dataset("REV",filter=list(c("NES"),c("4100"),c("TAXNAT"),c(OECD_Countries)), start_time = 2012)
Property_Tax_Rev<-Property_Tax_Rev[c("COU","obsTime","obsValue")]
colnames(Property_Tax_Rev)<-c("isocode","year","property_tax_collections")

#Missing country/years are simply prior year values
isocode<-c("AUS","GRC","MEX")
year<-c("2017","2017","2017")
property_tax_collections<-c("29.232000","3.672000","40.356644")
missing<-data.frame(isocode,year,property_tax_collections)

Property_Tax_Rev<-rbind(Property_Tax_Rev,missing)
Property_Tax_Rev$property_tax_collections<-as.numeric(Property_Tax_Rev$property_tax_collections)
Property_Tax_Rev$property_tax_collections<-(Property_Tax_Rev$property_tax_collections)*1000

#Merge Property Tax Revenues data with Capital Stock Data
Property_Tax<-merge(Property_Tax_Rev,Cap_Stock_12_17,by=c("isocode","year"))
Property_Tax$property_tax_collections<-(Property_Tax$property_tax_collections/Property_Tax$Cap_Stock)*100
Property_Tax<-Property_Tax[c("country","year","property_tax_collections","isocode")]
colnames(Property_Tax)<-c("country","year","property_tax_collections","ISO_3") 
write.csv(Property_Tax, file = "./intermediate-outputs/Property_Tax.csv", row.names = FALSE)

