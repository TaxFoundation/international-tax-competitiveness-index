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
corporate_rate<-corporate_rate[c(2,3,5)]
colnames(corporate_rate)<-c("country","corporate_rate","year")

corporate_rate$corporate_rate <- as.numeric(corporate_rate$corporate_rate)
corporate_rate$corporate_rate <- corporate_rate$corporate_rate/100


#r_and_d_credit####
#RDTAXSUB#
#dataset<-("RDSUB")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC

r_and_d_credit <- get_dataset("RDSUB",filter= list(c(oecd_countries), c("SME","LARGE"), c("PROFITABLE", "LOSS-MAKING")), start_time = 2013)
r_and_d_credit <- r_and_d_credit[c(1,2,3,4,6)]
colnames(r_and_d_credit) <- c("country","r_and_d_credit","Profit", "Size", "year")
r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
r_and_d_credit$r_and_d_credit <- as.numeric(r_and_d_credit$r_and_d_credit)

r_and_d_credit <- spread(r_and_d_credit,year,r_and_d_credit)

r_and_d_credit2013 <- aggregate(r_and_d_credit$`2013`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2014 <- aggregate(r_and_d_credit$`2014`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2015 <- aggregate(r_and_d_credit$`2015`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2016 <- aggregate(r_and_d_credit$`2016`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2017 <- aggregate(r_and_d_credit$`2017`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2018 <- aggregate(r_and_d_credit$`2018`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2019 <- aggregate(r_and_d_credit$`2019`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2020 <- aggregate(r_and_d_credit$`2020`,by=list(r_and_d_credit$country),FUN=mean)
r_and_d_credit2021 <- aggregate(r_and_d_credit$`2021`,by=list(r_and_d_credit$country),FUN=mean)

countries <- r_and_d_credit2021$Group.1

r_and_d_credit <- data.frame(countries, r_and_d_credit2013$x, r_and_d_credit2014$x, r_and_d_credit2015$x,
                             r_and_d_credit2016$x, r_and_d_credit2017$x, r_and_d_credit2018$x, r_and_d_credit2019$x, r_and_d_credit2020$x, r_and_d_credit2021$x)

colnames(r_and_d_credit) <- c("country","2013","2014","2015","2016","2017","2018","2019","2020","2021")
r_and_d_credit <- gather(r_and_d_credit,"year","r_and_d_credit","2013","2014","2015","2016","2017","2018","2019","2020","2021")
r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
r_and_d_credit$year <- r_and_d_credit$year+1


#top_income_rate####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

top_income_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("TOP_TRATE")), start_time = 2013)
top_income_rate<-top_income_rate[c(1,2,6)]
colnames(top_income_rate)<-c("country","top_income_rate","year")

top_income_rate$year<-as.numeric(top_income_rate$year)

#Chile increased its top personal income tax rate from 35% to 40% as of 2020
top_income_rate[c('top_income_rate')][top_income_rate$country == "CHL" & top_income_rate$year >= 2019,] <- "40"
top_income_rate$top_income_rate<-as.numeric(top_income_rate$top_income_rate)

top_income_rate$year<-top_income_rate$year+1
top_income_rate$top_income_rate<-top_income_rate$top_income_rate/100

#all_in_rate
all_in_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("PER_ARATE")), start_time = 2013)
all_in_rate<-all_in_rate[c(1,2,6)]
colnames(all_in_rate)<-c("country","all_in_rate","year")

all_in_rate$year<-as.numeric(all_in_rate$year)
all_in_rate$all_in_rate<-as.numeric(all_in_rate$all_in_rate)

all_in_rate$year<-all_in_rate$year+1
all_in_rate$all_in_rate<-all_in_rate$all_in_rate/100


#take the max of top rate or all-in rate
top_income_rate<-merge(top_income_rate,all_in_rate, by=c("country","year"))
top_income_rate$top_income_rate<-pmax(top_income_rate$top_income_rate,top_income_rate$all_in_rate)

#threshold_top_income_rate####
#Table_I7#
#dataset<-("Table_I7")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_I7_TAX

threshold<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("THRESHOLD")), start_time = 2013)
threshold<-threshold[c(1,2,6)]
colnames(threshold)<-c("country","threshold_top_income_rate","year")
threshold$year<-as.numeric(threshold$year)
threshold$year<-threshold$year+1


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

martax_wedge<-martax_wedge[c(1,2,4,6)]
colnames(martax_wedge)<-c("country","income","martax_wedge","year")
martax_wedge$martax_wedge<-as.numeric(martax_wedge$martax_wedge)
martax_wedge<-spread(martax_wedge,year,martax_wedge)

martax_wedge2013<-aggregate(martax_wedge$`2013`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2014<-aggregate(martax_wedge$`2014`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2015<-aggregate(martax_wedge$`2015`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2016<-aggregate(martax_wedge$`2016`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2017<-aggregate(martax_wedge$`2017`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2018<-aggregate(martax_wedge$`2018`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2019<-aggregate(martax_wedge$`2019`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2020<-aggregate(martax_wedge$`2020`,by=list(martax_wedge$country),FUN=mean)
martax_wedge2021<-aggregate(martax_wedge$`2021`,by=list(martax_wedge$country),FUN=mean)


#avgtax_wedge
#Table_I5#
#dataset<-("Table_I5")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$INCOMEAW
#dstruc$CL_TABLE_I4_MARGRATES

avgtax_wedge<-get_dataset("Table_I5",filter= list(c(oecd_countries),c("67","100","133","167"),c("TOT_TAX_WEDGE")), start_time = 2013)

avgtax_wedge<-avgtax_wedge[c(2,3,4,6)]
colnames(avgtax_wedge)<-c("country","income","avgtax_wedge","year")
avgtax_wedge$avgtax_wedge<-as.numeric(avgtax_wedge$avgtax_wedge)

avgtax_wedge<-spread(avgtax_wedge,year,avgtax_wedge)

avgtax_wedge2013<-aggregate(avgtax_wedge$`2013`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2014<-aggregate(avgtax_wedge$`2014`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2015<-aggregate(avgtax_wedge$`2015`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2016<-aggregate(avgtax_wedge$`2016`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2017<-aggregate(avgtax_wedge$`2017`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2018<-aggregate(avgtax_wedge$`2018`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2019<-aggregate(avgtax_wedge$`2019`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2020<-aggregate(avgtax_wedge$`2020`,by=list(avgtax_wedge$country),FUN=mean)
avgtax_wedge2021<-aggregate(avgtax_wedge$`2021`,by=list(avgtax_wedge$country),FUN=mean)


countries<-avgtax_wedge2020$Group.1

tax_wedge2013<-martax_wedge2013$x/avgtax_wedge2013$x
tax_wedge2014<-martax_wedge2014$x/avgtax_wedge2014$x
tax_wedge2015<-martax_wedge2015$x/avgtax_wedge2015$x
tax_wedge2016<-martax_wedge2016$x/avgtax_wedge2016$x
tax_wedge2017<-martax_wedge2017$x/avgtax_wedge2017$x
tax_wedge2018<-martax_wedge2018$x/avgtax_wedge2018$x
tax_wedge2019<-martax_wedge2019$x/avgtax_wedge2019$x
tax_wedge2020<-martax_wedge2020$x/avgtax_wedge2020$x
tax_wedge2021<-martax_wedge2020$x/avgtax_wedge2021$x


tax_wedge<-data.frame(countries,tax_wedge2013,tax_wedge2014,tax_wedge2015,tax_wedge2016,tax_wedge2017,tax_wedge2018,tax_wedge2019,tax_wedge2020,tax_wedge2021)

colnames(tax_wedge)<-c("country","2013","2014","2015","2016","2017","2018","2019","2020","2021")
tax_wedge<-gather(tax_wedge,"year","tax_wedge","2013","2014","2015","2016","2017","2018","2019","2020","2021")
tax_wedge$year<-as.numeric(tax_wedge$year)
tax_wedge$year<-tax_wedge$year+1

tax_wedge[c('tax_wedge')][tax_wedge$country == "COL" & tax_wedge$year >=2014,] <- 0



#dividends_rate####
#Table_II4#
#dataset<-("Table_II4")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR_DESC
#dstruc$CL_TABLE_II4_STAT_DIV_TAX

dividends_rate<-get_dataset("Table_II4",filter= list(c(oecd_countries),c("NET_PERS_TAX")), start_time = 2014)
dividends_rate<-dividends_rate[c(1,2,5)]
colnames(dividends_rate)<-c("country","dividends_rate","year")

dividends_rate$dividends_rate<-as.numeric(dividends_rate$dividends_rate)
dividends_rate$dividends_rate<-dividends_rate$dividends_rate/100

#corporate_other_rev####
taxes<-c("1300","6100")
corporate_other_rev <- get_dataset("REV", filter= list(c("NES"),c(taxes),c("TAXPER")),start_time = 2012)
corporate_other_rev<-corporate_other_rev[c(1,3,5,7)]
colnames(corporate_other_rev)<-c("country","corporate_other_rev","tax","year")
corporate_other_rev<-spread(corporate_other_rev,tax,corporate_other_rev)
corporate_other_rev$`1300`<-as.numeric(corporate_other_rev$`1300`)
corporate_other_rev$`1300`[is.na(corporate_other_rev$`1300`)] <- 0
corporate_other_rev$`6100`<-as.numeric(corporate_other_rev$`6100`)
corporate_other_rev$`6100`[is.na(corporate_other_rev$`6100`)] <- 0

corporate_other_rev$corporate_other_rev<-corporate_other_rev$`1300`+corporate_other_rev$`6100`
corporate_other_rev<-corporate_other_rev[c(1,2,5)]

corporate_other_rev<-subset(corporate_other_rev,country%in%oecd_countries)

corporate_other_rev$corporate_other_rev<-as.numeric(corporate_other_rev$corporate_other_rev)
corporate_other_rev$year<-as.numeric(corporate_other_rev$year)

#Add in Australia, Greece, and Japan 2019 numbers
#Australia: 2020 data not available -> use 2019 data
missing_australia <- subset(corporate_other_rev, subset = country == "AUS" & year == "2019")
missing_australia[missing_australia$year == 2019, "year"] <- 2020

#Japan: 2020 data not available -> use 2019 data
missing_japan <- subset(corporate_other_rev, subset = country == "JPN" & year == "2019")
missing_japan[missing_japan$year == 2019, "year"] <- 2020

#Greece: 2020 data not available -> use 2019 data
missing_greece <- subset(corporate_other_rev, subset = country == "GRC" & year == "2019")
missing_greece[missing_greece$year == 2019, "year"] <- 2020

#combine
corporate_other_rev<-rbind(corporate_other_rev,missing_australia,missing_japan,missing_greece)
corporate_other_rev$year<-corporate_other_rev$year+2

#personal_other_rev####
taxes<-c("2400")
personal_other_rev <- get_dataset("REV", filter= list(c("NES"),c(taxes),c("TAXPER")),start_time = 2012)
personal_other_rev<-personal_other_rev[c(1,3,7)]
colnames(personal_other_rev)<-c("country","personal_other_rev","year")

personal_other_rev<-subset(personal_other_rev,country%in%oecd_countries)

personal_other_rev$personal_other_rev<-as.numeric(personal_other_rev$personal_other_rev)
personal_other_rev$year<-as.numeric(personal_other_rev$year)

#Add in Australia, Greece, Hungary, and Japan 2019 numbers
#Australia: 2020 data not available -> use 2019 data
missing_australia <- subset(personal_other_rev, subset = country == "AUS" & year == "2019")
missing_australia[missing_australia$year == 2019, "year"] <- 2020

#Hungary: 2020 data not available -> use 2019 data
missing_hungary <- subset(personal_other_rev, subset = country == "HUN" & year == "2019")
missing_hungary[missing_hungary$year == 2019, "year"] <- 2020

#Japan: 2020 data not available -> use 2019 data
missing_japan <- subset(personal_other_rev, subset = country == "JPN" & year == "2019")
missing_japan[missing_japan$year == 2019, "year"] <- 2020

#Greece: 2020 data not available -> use 2019 data
missing_greece <- subset(personal_other_rev, subset = country == "GRC" & year == "2019")
missing_greece[missing_greece$year == 2019, "year"] <- 2020

#combine
personal_other_rev<-rbind(personal_other_rev,missing_australia,missing_japan,missing_hungary,missing_greece)
personal_other_rev$year<-personal_other_rev$year+2

#End OECD data scraper#

#output####

OECDvars_data <- merge(corporate_rate, r_and_d_credit, by=c("country","year"))
OECDvars_data <- merge(OECDvars_data, top_income_rate, by=c("country","year"))
OECDvars_data <- merge(OECDvars_data, threshold, by=c("country","year"))
OECDvars_data <- merge(OECDvars_data, tax_wedge, by=c("country","year"))
OECDvars_data <- merge(OECDvars_data, dividends_rate, by=c("country","year"))
OECDvars_data <- merge(OECDvars_data, corporate_other_rev, by=c("country","year"))
OECDvars_data <- merge(OECDvars_data, personal_other_rev, by=c("country","year"))


colnames(OECDvars_data) <- c("ISO_3","year","corporate_rate","r_and_d_credit", "top_income_rate", "threshold_top_income_rate", "tax_wedge", "dividends_rate","corporate_other_rev","personal_other_rev")
OECDvars_data <- merge(OECDvars_data,iso_country_codes,by="ISO_3")

OECDvars_data <- OECDvars_data[c("ISO_2","ISO_3","country","year","corporate_rate","r_and_d_credit", "top_income_rate", "threshold_top_income_rate", "tax_wedge", "dividends_rate","corporate_other_rev","personal_other_rev")]

write.csv(OECDvars_data, file = paste(intermediate_outputs,"oecd_variables_data.csv",sep=""), row.names = FALSE)
