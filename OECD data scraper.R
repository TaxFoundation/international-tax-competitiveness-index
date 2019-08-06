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

#corprate####
#Table_II1#
dataset_list<-get_datasets()
#dataset<-("Table_II1")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC

corprate<-get_dataset("Table_II1",filter= list(c(OECD_Countries),c("COMB_CIT_RATE")), start_time = 2014)
corprate<-corprate[c(1,4,5)]
colnames(corprate)<-c("Country","Year","corprate")
corprate$corprate<-corprate$corprate/100

#Fix France 2019 CIT rate - source: https://www.pwc.com/us/en/tax-services/publications/insights/assets/pwc-france-proposes-digital-tax-delay-in-corporate-rate-reduction.pdf

corprate<-corprate[which(corprate$corprate!=0.3202300),]

France<-data.frame("FRA","2019","0.3443")
colnames(France)<-c("Country","Year","corprate")

corprate<-rbind(corprate,France)

#divrate####
#Table_II4#
#dataset<-("Table_II4")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_II4_STAT_DIV_TAX

divrate<-get_dataset("Table_II4",filter= list(c(OECD_Countries),c("NET_PERS_TAX")), start_time = 2014)
divrate<-divrate[c(1,4,5)]
colnames(divrate)<-c("Country","Year","divrate")
divrate$divrate<-divrate$divrate/100

#incrate####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

incrate<-get_dataset("Table_I7",filter= list(c(OECD_Countries),c("TOP_TRATE")), start_time = 2013)
incrate<-incrate[c(1,5,6)]
colnames(incrate)<-c("Country","Year","incrate")
incrate$Year<-as.numeric(incrate$Year)
incrate$Year<-incrate$Year+1
incrate$incrate<-incrate$incrate/100



#progressivity####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

threshold<-get_dataset("Table_I7",filter= list(c(OECD_Countries),c("THRESHOLD")), start_time = 2013)
threshold<-threshold[c(1,5,6)]
colnames(threshold)<-c("Country","Year","progressivity")
threshold$Year<-as.numeric(threshold$Year)
threshold$Year<-threshold$Year+1

#taxwedge####
#martaxwedge
#Table_I4#
#dataset<-("Table_I4")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$INCOMEAW
#dstruc$CL_TABLE_I4_MARGRATES

martaxwedge<-get_dataset("Table_I4",filter= list(c(OECD_Countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

martaxwedge<-martaxwedge[c(1,2,5,6)]
colnames(martaxwedge)<-c("Country","Income","Year","martaxwedge")
martaxwedge<-spread(martaxwedge,Year,martaxwedge)

martaxwedge2013<-aggregate(martaxwedge$`2013`,by=list(martaxwedge$Country),FUN=mean)
martaxwedge2014<-aggregate(martaxwedge$`2014`,by=list(martaxwedge$Country),FUN=mean)
martaxwedge2015<-aggregate(martaxwedge$`2015`,by=list(martaxwedge$Country),FUN=mean)
martaxwedge2016<-aggregate(martaxwedge$`2016`,by=list(martaxwedge$Country),FUN=mean)
martaxwedge2017<-aggregate(martaxwedge$`2017`,by=list(martaxwedge$Country),FUN=mean)
martaxwedge2018<-aggregate(martaxwedge$`2018`,by=list(martaxwedge$Country),FUN=mean)


#avgtaxwedge
#Table_I5#
#dataset<-("Table_I5")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$INCOMEAW
#dstruc$CL_TABLE_I4_MARGRATES

avgtaxwedge<-get_dataset("Table_I5",filter= list(c(OECD_Countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

avgtaxwedge<-avgtaxwedge[c(1,2,5,6)]
colnames(avgtaxwedge)<-c("Country","Income","Year","avgtaxwedge")
avgtaxwedge<-spread(avgtaxwedge,Year,avgtaxwedge)


avgtaxwedge2013<-aggregate(avgtaxwedge$`2013`,by=list(avgtaxwedge$Country),FUN=mean)
avgtaxwedge2014<-aggregate(avgtaxwedge$`2014`,by=list(avgtaxwedge$Country),FUN=mean)
avgtaxwedge2015<-aggregate(avgtaxwedge$`2015`,by=list(avgtaxwedge$Country),FUN=mean)
avgtaxwedge2016<-aggregate(avgtaxwedge$`2016`,by=list(avgtaxwedge$Country),FUN=mean)
avgtaxwedge2017<-aggregate(avgtaxwedge$`2017`,by=list(avgtaxwedge$Country),FUN=mean)
avgtaxwedge2018<-aggregate(avgtaxwedge$`2018`,by=list(avgtaxwedge$Country),FUN=mean)

countries<-avgtaxwedge2018$Group.1


taxwedge2013<-martaxwedge2013$x/avgtaxwedge2013$x
taxwedge2014<-martaxwedge2014$x/avgtaxwedge2014$x
taxwedge2015<-martaxwedge2015$x/avgtaxwedge2015$x
taxwedge2016<-martaxwedge2016$x/avgtaxwedge2016$x
taxwedge2017<-martaxwedge2017$x/avgtaxwedge2017$x
taxwedge2018<-martaxwedge2018$x/avgtaxwedge2018$x

taxwedge<-data.frame(countries,taxwedge2013,taxwedge2014,taxwedge2015,taxwedge2016,taxwedge2017,taxwedge2018)

colnames(taxwedge)<-c("Country","2013","2014","2015","2016","2017","2018")
taxwedge<-gather(taxwedge,"Year","taxwedge","2013","2014","2015","2016","2017","2018")
taxwedge$Year<-as.numeric(taxwedge$Year)
taxwedge$Year<-taxwedge$Year+1



#End OECD data scraper#
#Output

OECDvars_data<-merge(corprate,divrate,by=c("Country","Year"))
OECDvars_data<-merge(OECDvars_data,incrate,by=c("Country","Year"))
OECDvars_data<-merge(OECDvars_data,threshold,by=c("Country","Year"))
OECDvars_data<-merge(OECDvars_data,taxwedge,by=c("Country","Year"))

#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO-2","ISO-3")

colnames(OECDvars_data)<-c("ISO-3","year","corprate","divrate", "incrate", "progressivity", "taxwedge")
OECDvars_data<-merge(OECDvars_data,ISO_Country_Codes,by="ISO-3")

write.csv(OECDvars_data, file = "./intermediate-outputs/OECDvars_data.csv", row.names = FALSE)
