#CFC Rules Model

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
CFC_Rules_2014 <- read_csv("./source-data/cfc_rules_2014.csv")
CFC_Rules_2015 <- read_csv("./source-data/cfc_rules_2015.csv")
CFC_Rules_2016 <- read_csv("./source-data/cfc_rules_2016.csv")
CFC_Rules_2017 <- read_csv("./source-data/cfc_rules_2017.csv")
CFC_Rules_2018 <- read_csv("./source-data/cfc_rules_2018.csv")
CFC_Rules_2019 <- read_csv("./source-data/cfc_rules_2019.csv")

CFC_Rules<-rbind(CFC_Rules_2014,CFC_Rules_2015,CFC_Rules_2016,CFC_Rules_2017,CFC_Rules_2018,CFC_Rules_2019)

CFC_Rules$cfc_rules<-rowMeans(CFC_Rules[,5:7])


write.csv(CFC_Rules, file = "./intermediate-outputs/cfc_rules_data.csv",row.names=F)
