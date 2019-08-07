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

vat_rates <- read_excel("source-data/vat-gst-rates-ctt-trends.xlsx", 
                                       range = "A4:s39")

vat_rates<-vat_rates[-c(3:13)]

#US VAT rate equivalent
columns <- names(vat_rates)
values<-c("United States","","7.2","7.3","7.3","7.4","7.4","7.4")
US <- data.frame(columns, values)
US<-spread(US,columns,values)

vat_rates<-rbind(vat_rates,US)

#Canada VAT rate equivalent
columns <- names(vat_rates)
values<-c("Canada","","15.6","10.6","10.6","12.4","12.4","7.4")
Canada <- data.frame(columns, values)
Canada<-spread(Canada,columns,values)

vat_rates<-subset(vat_rates,vat_rates$X__1!="Canada*")
vat_rates<-rbind(vat_rates,Canada)

vat_rates<-vat_rates[-c(2)]
vat_rates<-melt(vat_rates,id.vars=c("X__1"))
colnames(vat_rates)<-c("country","year","vatrate")
vat_rates$country <- str_remove_all(vat_rates$country, "[*]")


write.csv(vat_rates,"./intermediate-outputs/vatrates.csv",row.names = FALSE)

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

vat_thresholds<-subset(vat_thresholds,vat_thresholds$country!="0")

#Add US for all years; Latvia for 2014 and 2015; Lithuania for 2014, 2015, 2016, 2017#
#
country<-c("United States","United States","United States","United States","United States","United States")
threshold<-c("0","0","0","0","0","0")
year<-c("2014","2015","2016","2017","2018","2019")
USA <- data.frame(country,threshold,year)

#Check source C:\Github\international-tax-competitiveness-index\source-data\VAT Thresholds_LVA and LTU_Previous Years.xlsx
country<-c("Latvia","Latvia")
threshold<-c("100402","100604")
year<-c("2014","2015")
LVA <- data.frame(country,threshold,year)

country<-c("Lithuania","Lithuania","Lithuania","Lithuania")
threshold<-c("101580","100897","100671","100223")
year<-c("2014","2015","2016","2017")
LTU <- data.frame(country,threshold,year)

vat_thresholds<-rbind(vat_thresholds,USA,LVA,LTU)

write.csv(vat_thresholds,"./intermediate-outputs/vat_thresholds.csv",row.names = FALSE)


#Vat Base
#Source data: https://doi.org/10.1787/888933890122
vat_base <- read_excel("source-data/vat-revenue-ratio-calculations.xlsx", 
                                             sheet = "Sheet1", range = "A7:U43")
vat_base <- vat_base[-c(2:18)]

vat_base$`2017`<-vat_base$`2016`
vat_base$`2018`<-vat_base$`2016`
vat_base$`2019`<-vat_base$`2016`


columns <- names(vat_base)
values<-c("United States","0.397","0.397","0.397","0.397","0.4","0.4")
US <- data.frame(columns, values)
US<-spread(US,columns,values)

vat_base<-rbind(vat_base,US)

vat_base<-melt(vat_base,id.vars=c("Country"))
colnames(vat_base)<-c("country","year","base")
#Change NAs to zeros
vat_base[is.na(vat_base)] <- 0

vat_base<-subset(vat_base,vat_base$country!="0")

write.csv(vat_base,"./intermediate-outputs/vat_base.csv",row.names = FALSE)



#Combine files
vat_base <- read_csv("./intermediate-outputs/vat_base.csv")
vat_rates <- read_csv("./intermediate-outputs/vatrates.csv")
vat_thresholds <- read_csv("./intermediate-outputs/vat_thresholds.csv")


vat_data<-merge(vat_rates,vat_thresholds,by=c("country","year"))
vat_data<-merge(vat_data,vat_base,by=c("country","year"))

write.csv(vat_data,file = "./intermediate-outputs/vat_data.csv",row.names=F)
