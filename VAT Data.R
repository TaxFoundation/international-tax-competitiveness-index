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


write.csv(vat_data,"vatrates.csv",row.names = FALSE)

#VAT Thresholds
vat_thresholds <- read_excel("source-data/vat-gst-annual-turnover-concessions-ctt-trends.xlsx", range = "A4:e42")

vat_thresholds<-vat_thresholds[-c(2:4)]
colnames(vat_thresholds)<-c("country","threshold")

vat_thresholds$country <- stringr::str_replace(vat_thresholds$country, '\\*', '')
vat_thresholds$country <- str_remove_all(vat_thresholds$country, "[6*]")

