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

OECD_vars<-read_csv("OECDvars_data.csv")
Cap_Allowances<-read_csv("cap_allowances_data.csv")
CFC_Rules<-read_csv("CFC Rules Data.csv")

indexdata2014<-read_csv("indexdata2014.csv")
indexdata2014$year<-2014

indexdata2015<-read_csv("indexdata2015.csv")
indexdata2015$year<-2015

indexdata2016<-read_csv("indexdata2016.csv")
indexdata2016$year<-2016

indexdata2017<-read_csv("indexdata2017.csv")
indexdata2017$year<-2017

indexdata2018<-read_csv("indexdata2018.csv")
indexdata2018$year<-2018

indexdata2019<-read_csv("indexdata2019.csv")
indexdata2019$year<-2019

#Join cap allowances data with indexdata2019#

Cap_Allowances_Vars<-c("pdvmachines","pdvbuildings", "pdvintangibles")
indexdata2019<-indexdata2019[,!names(indexdata2019) %in% Cap_Allowances_Vars]

indexdata2019<-merge(indexdata2019,Cap_Allowances,by=c("country","year"))
indexdata2019<-indexdata2019[-c(41,45)]

#Join CFC rules data with indexdata2019

CFC_Rules_var<-c("cfcrules")
indexdata2019<-indexdata2019[,!names(indexdata2019) %in% CFC_Rules_var]

indexdata2019<-merge(indexdata2019,CFC_Rules,by=c("country"))
indexdata2019<-indexdata2019[-c(43:45,47:48)]

indexdata_old<-rbind(indexdata2014,indexdata2015,indexdata2016,indexdata2017,indexdata2018,indexdata2019)
#Rename progressivity variable
indexdata_old$threshold_1->indexdata_old$progressivity

#Remove variables from indexdata_old that are in OECD data
OECDvars<-c("corprate","divrate", "incrate", "progressivity", "taxwedge")
indexdata_old<-indexdata_old[,!names(indexdata_old) %in% OECDvars]

#Join OECD data with indexdata_old####

indexdata_OECD_vars<-merge(indexdata_old,OECD_vars,by=c("country","year"))

write.csv(subset(indexdata_OECD_vars,indexdata_OECD_vars$year==2014),file = "indexdata2014.csv",row.names=F)
write.csv(subset(indexdata_OECD_vars,indexdata_OECD_vars$year==2015),file = "indexdata2015.csv",row.names=F)
write.csv(subset(indexdata_OECD_vars,indexdata_OECD_vars$year==2016),file = "indexdata2016.csv",row.names=F)
write.csv(subset(indexdata_OECD_vars,indexdata_OECD_vars$year==2017),file = "indexdata2017.csv",row.names=F)
write.csv(subset(indexdata_OECD_vars,indexdata_OECD_vars$year==2018),file = "indexdata2018.csv",row.names=F)
write.csv(subset(indexdata_OECD_vars,indexdata_OECD_vars$year==2019),file = "indexdata2019.csv",row.names=F)
