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
CFC_Rules_2014 <- read_csv("./source-data/cfcrules2014.csv")
CFC_Rules_2015 <- read_csv("./source-data/cfcrules2015.csv")
CFC_Rules_2016 <- read_csv("./source-data/cfcrules2016.csv")
CFC_Rules_2017 <- read_csv("./source-data/cfcrules2017.csv")
CFC_Rules_2018 <- read_csv("./source-data/cfcrules2018.csv")
CFC_Rules_2019 <- read_csv("./source-data/cfcrules2019.csv")

CFC_Rules<-rbind(CFC_Rules_2014,CFC_Rules_2015,CFC_Rules_2016,CFC_Rules_2017,CFC_Rules_2018,CFC_Rules_2019)

CFC_Rules$Score<-rowMeans(CFC_Rules[,2:4])

#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO-2","ISO-3")

colnames(CFC_Rules)<-c("country","exists","active","exemption","year", "cfcrules")
data<-merge(CFC_Rules,ISO_Country_Codes,by="country")

write.csv(data, file = "./intermediate-outputs/CFC Rules Data.csv",row.names=F)
