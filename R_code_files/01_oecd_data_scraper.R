#OECD data scraper

####OECD Data Scraper####

#corporate_rate####
#Table_II1#
#dataset_list<-get_datasets()
#dataset<-("Table_II1")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC

corporate_rate<-get_dataset("Table_II1",filter= list(c(oecd_countries),c("COMB_CIT_RATE")), start_time = 2014)
corporate_rate<-corporate_rate[c(1,4,5)]
colnames(corporate_rate)<-c("Country","Year","corporate_rate")
corporate_rate$corporate_rate<-corporate_rate$corporate_rate/100

#Fix France 2019 CIT rate - source: https://home.kpmg/us/en/home/insights/2019/07/tnf-france-revised-phase-down-of-corporate-income-tax-rate-enacted.html

corporate_rate<-corporate_rate[which(corporate_rate$corporate_rate!=0.3202300),]

France<-data.frame("FRA","2019","0.3443")
colnames(France)<-c("Country","Year","corporate_rate")

corporate_rate<-rbind(corporate_rate,France)


#r_and_d_credit####
#RDTAXSUB#
#dataset<-("RDSUB")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC

r_and_d_credit <- get_dataset("RDSUB",filter= list(c(oecd_countries), c("SME","LARGE"), c("PROFITABLE", "LOSS-MAKING")), start_time = 2013)
r_and_d_credit <- r_and_d_credit[c(1,2,3,5,6)]
colnames(r_and_d_credit) <- c("Country","Size","Profit", "Year","r_and_d_credit")
r_and_d_credit$Year <- as.numeric(r_and_d_credit$Year)
r_and_d_credit$r_and_d_credit <- as.numeric(r_and_d_credit$r_and_d_credit)

r_and_d_credit <- spread(r_and_d_credit,Year,r_and_d_credit)

r_and_d_credit2013 <- aggregate(r_and_d_credit$`2013`,by=list(r_and_d_credit$Country),FUN=mean)
r_and_d_credit2014 <- aggregate(r_and_d_credit$`2014`,by=list(r_and_d_credit$Country),FUN=mean)
r_and_d_credit2015 <- aggregate(r_and_d_credit$`2015`,by=list(r_and_d_credit$Country),FUN=mean)
r_and_d_credit2016 <- aggregate(r_and_d_credit$`2016`,by=list(r_and_d_credit$Country),FUN=mean)
r_and_d_credit2017 <- aggregate(r_and_d_credit$`2017`,by=list(r_and_d_credit$Country),FUN=mean)
r_and_d_credit2018 <- aggregate(r_and_d_credit$`2018`,by=list(r_and_d_credit$Country),FUN=mean)
r_and_d_credit2019 <- aggregate(r_and_d_credit$`2019`,by=list(r_and_d_credit$Country),FUN=mean)

countries <- r_and_d_credit2019$Group.1

r_and_d_credit <- data.frame(countries, r_and_d_credit2013$x, r_and_d_credit2014$x, r_and_d_credit2015$x,
                             r_and_d_credit2016$x, r_and_d_credit2017$x, r_and_d_credit2018$x, r_and_d_credit2019$x)

colnames(r_and_d_credit) <- c("Country","2013","2014","2015","2016","2017","2018","2019")
r_and_d_credit <- gather(r_and_d_credit,"Year","r_and_d_credit","2013","2014","2015","2016","2017","2018","2019")
r_and_d_credit$Year <- as.numeric(r_and_d_credit$Year)
r_and_d_credit$Year <- r_and_d_credit$Year+1


#top_income_rate####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

top_income_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("PER_ARATE")), start_time = 2013)
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

threshold<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("THRESHOLD")), start_time = 2013)
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

martax_wedge<-get_dataset("Table_I4",filter= list(c(oecd_countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

martax_wedge<-martax_wedge[c(1,2,5,6)]
colnames(martax_wedge)<-c("Country","Income","Year","martax_wedge")
martax_wedge<-spread(martax_wedge,Year,martax_wedge)

martax_wedge2013<-aggregate(martax_wedge$`2013`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2014<-aggregate(martax_wedge$`2014`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2015<-aggregate(martax_wedge$`2015`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2016<-aggregate(martax_wedge$`2016`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2017<-aggregate(martax_wedge$`2017`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2018<-aggregate(martax_wedge$`2018`,by=list(martax_wedge$Country),FUN=mean)
martax_wedge2019<-aggregate(martax_wedge$`2019`,by=list(martax_wedge$Country),FUN=mean)

#avgtax_wedge
#Table_I5#
#dataset<-("Table_I5")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$INCOMEAW
#dstruc$CL_TABLE_I4_MARGRATES

avgtax_wedge<-get_dataset("Table_I5",filter= list(c(oecd_countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

avgtax_wedge<-avgtax_wedge[c(1,2,5,6)]
colnames(avgtax_wedge)<-c("Country","Income","Year","avgtax_wedge")
avgtax_wedge<-spread(avgtax_wedge,Year,avgtax_wedge)

avgtax_wedge2013<-aggregate(avgtax_wedge$`2013`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2014<-aggregate(avgtax_wedge$`2014`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2015<-aggregate(avgtax_wedge$`2015`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2016<-aggregate(avgtax_wedge$`2016`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2017<-aggregate(avgtax_wedge$`2017`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2018<-aggregate(avgtax_wedge$`2018`,by=list(avgtax_wedge$Country),FUN=mean)
avgtax_wedge2019<-aggregate(avgtax_wedge$`2019`,by=list(avgtax_wedge$Country),FUN=mean)

countries<-avgtax_wedge2019$Group.1

tax_wedge2013<-martax_wedge2013$x/avgtax_wedge2013$x
tax_wedge2014<-martax_wedge2014$x/avgtax_wedge2014$x
tax_wedge2015<-martax_wedge2015$x/avgtax_wedge2015$x
tax_wedge2016<-martax_wedge2016$x/avgtax_wedge2016$x
tax_wedge2017<-martax_wedge2017$x/avgtax_wedge2017$x
tax_wedge2018<-martax_wedge2018$x/avgtax_wedge2018$x
tax_wedge2019<-martax_wedge2019$x/avgtax_wedge2019$x

tax_wedge<-data.frame(countries,tax_wedge2013,tax_wedge2014,tax_wedge2015,
                      tax_wedge2016,tax_wedge2017,tax_wedge2018,tax_wedge2019)

colnames(tax_wedge)<-c("Country","2013","2014","2015","2016","2017","2018","2019")
tax_wedge<-gather(tax_wedge,"Year","tax_wedge","2013","2014","2015","2016","2017","2018","2019")
tax_wedge$Year<-as.numeric(tax_wedge$Year)
tax_wedge$Year<-tax_wedge$Year+1


#dividends_rate####
#Table_II4#
#dataset<-("Table_II4")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_II4_STAT_DIV_TAX

dividends_rate<-get_dataset("Table_II4",filter= list(c(oecd_countries),c("NET_PERS_TAX")), start_time = 2014)
dividends_rate<-dividends_rate[c(1,4,5)]
colnames(dividends_rate)<-c("Country","Year","dividends_rate")
dividends_rate$dividends_rate<-dividends_rate$dividends_rate/100
#Japan is missing from the 2020 data###


#End OECD data scraper#

#Output####

OECDvars_data <- merge(corporate_rate, r_and_d_credit, by=c("Country","Year"))
OECDvars_data <- merge(OECDvars_data, dividends_rate, by=c("Country","Year"))
OECDvars_data <- merge(OECDvars_data, top_income_rate, by=c("Country","Year"))
OECDvars_data <- merge(OECDvars_data, threshold, by=c("Country","Year"))
OECDvars_data <- merge(OECDvars_data, tax_wedge, by=c("Country","Year"))

colnames(OECDvars_data) <- c("ISO_3","year","corporate_rate","r_and_d_credit", "dividends_rate", "top_income_rate", "threshold_top_income_rate", "tax_wedge")
OECDvars_data <- merge(OECDvars_data,iso_country_codes,by="ISO_3")

write.csv(OECDvars_data, file = paste(intermediate_outputs,"oecd_variables_data.csv",sep=""), row.names = FALSE)
