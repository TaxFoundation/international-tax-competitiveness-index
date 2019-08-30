#OECD data scraper

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

using(OECD)
using(tidyverse)
using(readxl)

####OECD Data Scraper####
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

#corporate_rate####
#Table_II1#
dataset_list<-get_datasets()
#dataset<-("Table_II1")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC

corporate_rate<-get_dataset("Table_II1",filter= list(c(OECD_Countries),c("COMB_CIT_RATE")), start_time = 2014)
corporate_rate<-corporate_rate[c(1,4,5)]
colnames(corporate_rate)<-c("Country","Year","corporate_rate")
corporate_rate$corporate_rate<-corporate_rate$corporate_rate/100

#Fix France 2019 CIT rate - source: https://www.pwc.com/us/en/tax-services/publications/insights/assets/pwc-france-proposes-digital-tax-delay-in-corporate-rate-reduction.pdf

corporate_rate<-corporate_rate[which(corporate_rate$corporate_rate!=0.3202300),]

France<-data.frame("FRA","2019","0.3443")
colnames(France)<-c("Country","Year","corporate_rate")

corporate_rate<-rbind(corporate_rate,France)


#top_income_rate####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

top_income_rate<-get_dataset("Table_I7",filter= list(c(OECD_Countries),c("PER_ARATE")), start_time = 2013)
top_income_rate<-top_income_rate[c(1,5,6)]
colnames(top_income_rate)<-c("Country","Year","top_income_rate")
top_income_rate$Year<-as.numeric(top_income_rate$Year)
top_income_rate$Year<-top_income_rate$Year+1
top_income_rate$top_income_rate<-top_income_rate$top_income_rate/100



#threshold_top_income_rate####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

threshold<-get_dataset("Table_I7",filter= list(c(OECD_Countries),c("THRESHOLD")), start_time = 2013)
threshold<-threshold[c(1,5,6)]
colnames(threshold)<-c("Country","Year","threshold_top_income_rate")
threshold$Year<-as.numeric(threshold$Year)
threshold$Year<-threshold$Year+1

#tax_wedge####
#martax_wedge
#Table_I4#
#dataset<-("Table_I4")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$INCOMEAW
#dstruc$CL_TABLE_I4_MARGRATES

martax_wedge<-get_dataset("Table_I4",filter= list(c(OECD_Countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

martax_wedge<-martax_wedge[c(1,2,5,6)]
colnames(martax_wedge)<-c("Country","Income","Year","martax_wedge")
martax_wedge<-spread(martax_wedge,Year,martax_wedge)

martax_wedge2013<-aggregate(martax_wedge$`2013`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2014<-aggregate(martax_wedge$`2014`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2015<-aggregate(martax_wedge$`2015`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2016<-aggregate(martax_wedge$`2016`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2017<-aggregate(martax_wedge$`2017`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2018<-aggregate(martax_wedge$`2018`,by=list(martax_wedge$Country),FUN=mean)


#avgtax_wedge
#Table_I5#
#dataset<-("Table_I5")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$INCOMEAW
#dstruc$CL_TABLE_I4_MARGRATES

avgtax_wedge<-get_dataset("Table_I5",filter= list(c(OECD_Countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

avgtax_wedge<-avgtax_wedge[c(1,2,5,6)]
colnames(avgtax_wedge)<-c("Country","Income","Year","avgtax_wedge")
avgtax_wedge<-spread(avgtax_wedge,Year,avgtax_wedge)


avgtax_wedge2013<-aggregate(avgtax_wedge$`2013`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2014<-aggregate(avgtax_wedge$`2014`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2015<-aggregate(avgtax_wedge$`2015`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2016<-aggregate(avgtax_wedge$`2016`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2017<-aggregate(avgtax_wedge$`2017`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2018<-aggregate(avgtax_wedge$`2018`,by=list(avgtax_wedge$Country),FUN=mean)

countries<-avgtax_wedge2018$Group.1


tax_wedge2013<-martax_wedge2013$x/avgtax_wedge2013$x
tax_wedge2014<-martax_wedge2014$x/avgtax_wedge2014$x
tax_wedge2015<-martax_wedge2015$x/avgtax_wedge2015$x
tax_wedge2016<-martax_wedge2016$x/avgtax_wedge2016$x
tax_wedge2017<-martax_wedge2017$x/avgtax_wedge2017$x
tax_wedge2018<-martax_wedge2018$x/avgtax_wedge2018$x

tax_wedge<-data.frame(countries,tax_wedge2013,tax_wedge2014,tax_wedge2015,tax_wedge2016,tax_wedge2017,tax_wedge2018)

colnames(tax_wedge)<-c("Country","2013","2014","2015","2016","2017","2018")
tax_wedge<-gather(tax_wedge,"Year","tax_wedge","2013","2014","2015","2016","2017","2018")
tax_wedge$Year<-as.numeric(tax_wedge$Year)
tax_wedge$Year<-tax_wedge$Year+1

#dividends_rate####
#Table_II4#
#dataset<-("Table_II4")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_II4_STAT_DIV_TAX

dividends_rate<-get_dataset("Table_II4",filter= list(c(OECD_Countries),c("NET_PERS_TAX")), start_time = 2014)
dividends_rate<-dividends_rate[c(1,4,5)]
colnames(dividends_rate)<-c("Country","Year","dividends_rate")
dividends_rate$dividends_rate<-dividends_rate$dividends_rate/100


#End OECD data scraper#
#Output

OECDvars_data<-merge(corporate_rate,dividends_rate,by=c("Country","Year"))
OECDvars_data<-merge(OECDvars_data,top_income_rate,by=c("Country","Year"))
OECDvars_data<-merge(OECDvars_data,threshold,by=c("Country","Year"))
OECDvars_data<-merge(OECDvars_data,tax_wedge,by=c("Country","Year"))

#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO-2","ISO-3")

colnames(OECDvars_data)<-c("ISO-3","year","corporate_rate","dividends_rate", "top_income_rate", "threshold_top_income_rate", "tax_wedge")
OECDvars_data<-merge(OECDvars_data,ISO_Country_Codes,by="ISO-3")

write.csv(OECDvars_data, file = "./intermediate-outputs/OECDvars_data.csv", row.names = FALSE)
