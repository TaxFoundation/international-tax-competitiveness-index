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
using(plyr)
using(reshape2)
using(countrycode)
using(tidyverse)
using(readxl)
using(stringr)

#VAT Rates

vat_data <- read_excel("source-data/vat-gst-rates-ctt-trends.xlsx", 
                                       range = "A4:s39")

columns <- names(vat_data)
values<-c("United States","","","","","","","","","","","","","7.2","7.3","7.3","7.4","7.4","7.4")
US <- data.frame(columns, values)
US<-spread(US,columns,values)

vat_data<-rbind(vat_data,US)

vat_data<-vat_data[-c(2)]
vat_data<-melt(vat_data,id.vars=c("X__1"))
colnames(vat_data)<-c("country","year","vatrate")
vat_data$country <- str_remove_all(vat_data$country, "[*]")


#write.csv(vat_data,"vatrates.csv",row.names = FALSE)

#VAT Thresholds
vat_thresholds_2018 <- read_excel("source-data/vat-gst-annual-turnover-concessions-ctt-trends.xlsx", sheet = "2018", range = "A4:e42")
vat_thresholds_2016 <- read_excel("source-data/vat-gst-annual-turnover-concessions-ctt-trends.xlsx", sheet = "2016", range = "a4:e41")
vat_thresholds_2014 <- read_excel("source-data/vat-gst-annual-turnover-concessions-ctt-trends.xlsx", sheet = "2014", range = "a4:d37")



vat_thresholds_2018<-vat_thresholds_2018[-c(2:4)]
colnames(vat_thresholds_2018)<-c("country","threshold")
vat_thresholds_2018$country <- str_remove_all(vat_thresholds_2018$country, "[6*]")
vat_thresholds_2018$year<-"2018"
vat_thresholds_2019<-vat_thresholds_2018
vat_thresholds_2019$year<-"2019"

vat_thresholds_2016<-vat_thresholds_2016[-c(2:4)]
colnames(vat_thresholds_2016)<-c("country","threshold")
vat_thresholds_2016$country <- str_remove_all(vat_thresholds_2016$country, "[(f)*]")
vat_thresholds_2016$year<-"2016"
vat_thresholds_2017<-vat_thresholds_2016
vat_thresholds_2017$year<-"2017"

vat_thresholds_2014<-vat_thresholds_2014[-c(2:3)]
colnames(vat_thresholds_2014)<-c("country","threshold")
vat_thresholds_2014$country <- str_remove_all(vat_thresholds_2014$country, "[*]")
vat_thresholds_2014$year<-"2014"
vat_thresholds_2015<-vat_thresholds_2014
vat_thresholds_2015$year<-"2015"

vat_thresholds<-rbind(vat_thresholds_2014,vat_thresholds_2015,vat_thresholds_2016,vat_thresholds_2017,vat_thresholds_2018,vat_thresholds_2019)

#Change NAs to zeros
vat_thresholds[is.na(vat_thresholds)] <- 0


#Add US for all years; Latvia for 2014 and 2015; Lithuania for 2014, 2015, 2016, 2017#
#
columns<-names(vat_thresholds)
US_2014<-c("United States","0","2014")
US_2015<-c("United States","0","2015")
US_2016<-c("United States","0","2016")
US_2017<-c("United States","0","2017")
US_2018<-c("United States","0","2018")
US_2019<-c("United States","0","2019")



additional_countries <- data.frame(columns, US_2014, US_2015, US_2016,US_2017,US_2018,US_2019)
US<-gather(columns,values)

