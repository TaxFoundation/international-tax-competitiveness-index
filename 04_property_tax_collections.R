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

imf_capital_stock_data <- read_excel("source-data/imf_capital_stock_data.xlsx", 
                                     sheet = "Data")

imf_capital_stock_data<-subset(imf_capital_stock_data,imf_capital_stock_data$year>2011)

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


imf_capital_stock_data<-subset(imf_capital_stock_data,imf_capital_stock_data$isocode%in% OECD_Countries)
imf_capital_stock_data$capital_stock<-imf_capital_stock_data$kpriv_n
imf_capital_stock_data$capital_stock<-as.numeric(imf_capital_stock_data$capital_stock)
imf_capital_stock_data$capital_stock<-(imf_capital_stock_data$capital_stock)*1000


imf_capital_stock_data<-imf_capital_stock_data[c("isocode","country","year","capital_stock")]
imf_capital_stock_data<-subset(imf_capital_stock_data,imf_capital_stock_data$year!=2015)


#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
iso_country_codes <- read_csv("./source-data/iso_country_codes.csv")
colnames(iso_country_codes)<-c("country","ISO_2","ISO_3")
ISO_OECD<-subset(iso_country_codes,iso_country_codes$ISO_3%in%OECD_Countries)
ISO_2_OECD<-print(ISO_OECD$ISO_2)


databaseID <- 'IFS'
checkquery = FALSE
IFS.available.codes <- DataStructureMethod('IFS')
## All OECD Countries Gross Fixed Capital Formation Millions in National Currency
queryfilter <- list(CL_FREQ="A", CL_AREA_IFS=ISO_2_OECD, CL_INDICATOR_IFS =c("NFI_SA_XDC"))

GFCF_2014<- data.frame(CompactDataMethod(databaseID, queryfilter, '2014-01-01', '2014-12-31', checkquery))
GFCF_2014<-data.frame(GFCF_2014$X.REF_AREA,unnest(GFCF_2014$Obs))
colnames(GFCF_2014)<-c("ISO_2","year","gross_fixed_capital_formation")


GFCF_2015<- data.frame(CompactDataMethod(databaseID, queryfilter, '2015-01-01', '2015-12-31', checkquery))
GFCF_2015<-data.frame(GFCF_2015$X.REF_AREA,unnest(GFCF_2015$Obs))
colnames(GFCF_2015)<-c("ISO_2","year","gross_fixed_capital_formation")

GFCF_2016<- data.frame(CompactDataMethod(databaseID, queryfilter, '2016-01-01', '2016-12-31', checkquery))
GFCF_2016<-data.frame(GFCF_2016$X.REF_AREA,unnest(GFCF_2016$Obs))
colnames(GFCF_2016)<-c("ISO_2","year","gross_fixed_capital_formation")

GFCF_2017<- data.frame(CompactDataMethod(databaseID, queryfilter, '2017-01-01', '2017-12-31', checkquery))
GFCF_2017<-data.frame(GFCF_2017$X.REF_AREA,unnest(GFCF_2017$Obs))
colnames(GFCF_2017)<-c("ISO_2","year","gross_fixed_capital_formation")

GFCF<-rbind(GFCF_2014,GFCF_2015,GFCF_2016,GFCF_2017)
GFCF<-merge(GFCF,iso_country_codes,by="ISO_2")
GFCF$gross_fixed_capital_formation<-as.numeric(GFCF$gross_fixed_capital_formation)

#Depreciate capital stock and add GFCF

#2015
capital_stock_15<-merge(subset(GFCF,GFCF$year==2014),subset(imf_capital_stock_data,imf_capital_stock_data$year==2014),by="country")
capital_stock_15$year<-"2015"
capital_stock_15$capital_stock<-(capital_stock_15$capital_stock*(1-.1077))+(capital_stock_15$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_15<-capital_stock_15[c("country","isocode","year","capital_stock")]

#2016
capital_stock_16<-merge(subset(GFCF,GFCF$year==2015),subset(capital_stock_15),by="country")
capital_stock_16$year<-"2016"
capital_stock_16$capital_stock<-(capital_stock_16$capital_stock*(1-.1077))+(capital_stock_16$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_16<-capital_stock_16[c("country","isocode","year","capital_stock")]

#2017
capital_stock_17<-merge(subset(GFCF,GFCF$year==2016),capital_stock_16,by="country")
capital_stock_17$year<-"2017"
capital_stock_17$capital_stock<-(capital_stock_17$capital_stock*(1-.1077))+(capital_stock_17$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_17<-capital_stock_17[c("country","isocode","year","capital_stock")]

capital_stock_12_17<-rbind(imf_capital_stock_data,capital_stock_15,capital_stock_16,capital_stock_17)


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

property_tax_revenue<-get_dataset("REV",filter=list(c("NES"),c("4100"),c("TAXNAT"),c(OECD_Countries)), start_time = 2012)
property_tax_revenue<-property_tax_revenue[c("COU","obsTime","obsValue")]
colnames(property_tax_revenue)<-c("isocode","year","property_tax_collections")

#Missing country/years are simply prior year values
isocode<-c("AUS","GRC","MEX")
year<-c("2017","2017","2017")
property_tax_collections<-c("29.232000","3.672000","40.356644")
missing<-data.frame(isocode,year,property_tax_collections)

property_tax_revenue<-rbind(property_tax_revenue,missing)
property_tax_revenue$property_tax_collections<-as.numeric(property_tax_revenue$property_tax_collections)
property_tax_revenue$property_tax_collections<-(property_tax_revenue$property_tax_collections)*1000

#Merge Property Tax Revenues data with Capital Stock Data
Property_Tax<-merge(property_tax_revenue,capital_stock_12_17,by=c("isocode","year"))
Property_Tax$property_tax_collections<-(Property_Tax$property_tax_collections/Property_Tax$capital_stock)*100
Property_Tax<-Property_Tax[c("country","year","property_tax_collections","isocode")]
colnames(Property_Tax)<-c("country","year","property_tax_collections","ISO_3") 
write.csv(Property_Tax, file = "./intermediate-outputs/property_tax_data.csv", row.names = FALSE)

