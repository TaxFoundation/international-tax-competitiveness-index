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
CFC_Rules <- read_csv("./source-data/CFC Rules.csv")
CFC_Rules$Score<-rowMeans(CFC_Rules[,2:4])

#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO-2","ISO-3")

colnames(CFC_Rules)<-c("country","exists","active","exemption", "cfcrules")
data<-merge(CFC_Rules,ISO_Country_Codes,by="country")

write.csv(data, file = "CFC Rules Data.csv",row.names=F)
