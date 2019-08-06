#main index code
rm(list=ls())
gc()

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


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

# Sets the working directory. This sets it to the "index" folder on my desktop
using(plyr)
using(dplyr)
using(tidyverse)
using(readxl)


#Clears all datasets and variables from memory



###Table 1####


###Table 2 Compare 2017, 2018, and 2019 results####
Table2_Changes<-merge(Final2018,Final2019,by="country")
Table2_Changes<-Table2_Changes[c(1,13,14,26,27)]
colnames(Table2_Changes)<-c("country", "2018 Rank","2018 Score","2019 Rank","2019 Score")
Table2_Changes<-merge(Final2017,Table2_Changes,by="country")
Table2_Changes<-Table2_Changes[c(1,13:18)]
colnames(Table2_Changes)<-c("Country","2017 Rank","2017 Score", "2018 Rank","2018 Score","2019 Rank","2019 Score")
Table2_Changes$'Change in Rank'<-(Table2_Changes$`2019 Rank`-Table2_Changes$`2018 Rank`)*(-1)
Table2_Changes$'Change in Score'<-Table2_Changes$`2019 Score`-Table2_Changes$`2018 Score`