#OECD data scraper
####OECD Data Scraper####

#corporate_rate####

#corporate_rate<-get_dataset("Table_II1",filter= list(c(oecd_countries),c("COMB_CIT_RATE")), start_time = 2014)
#corporate_rate<-corporate_rate[c(2,3,5)]
#colnames(corporate_rate)<-c("country","corporate_rate","year")

corporate_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_CIT@DF_CIT,1.0", filter="BEL+AUT+AUS+EST+DNK+CZE+CRI+COL+CHL+CAN+ISL+HUN+GRC+DEU+FRA+FIN+LVA+KOR+JPN+ITA+ISR+IRL+NLD+MEX+LUX+LTU+SVN+SVK+PRT+POL+NOR+NZL+TUR+USA+GBR+CHE+SWE+ESP.A.CIT_C.ST..S13..")
corporate_rate<-corporate_rate[c(5,7,11)]
colnames(corporate_rate)<-c("corporate_rate","ISO_3","year")

corporate_rate$corporate_rate <- as.numeric(corporate_rate$corporate_rate)
corporate_rate$corporate_rate <- corporate_rate$corporate_rate/100

#Missing Slovakia
#missing_slovakia <- c(0.21,"SVK",2024)
#corporate_rate <- rbind(corporate_rate, missing_slovakia)

#Missing Turkey
#missing_turkey <- c(0.25,"TUR",2024)
#corporate_rate <- rbind(corporate_rate, missing_turkey)

write.csv(corporate_rate, file = paste(intermediate_outputs,"oecd_corporate_rate.csv",sep=""), row.names = FALSE)

#r_and_d_credit####

#r_and_d_credit <- get_dataset("RDSUB",filter= list(c(oecd_countries), c("SME","LARGE"), c("PROFITABLE", "LOSS-MAKING")), start_time = 2013)
#r_and_d_credit <- r_and_d_credit[c(1,2,3,4,6)]
#colnames(r_and_d_credit) <- c("country","r_and_d_credit","Profit", "Size", "year")
#r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
#r_and_d_credit$r_and_d_credit <- as.numeric(r_and_d_credit$r_and_d_credit)

#r_and_d_credit <- spread(r_and_d_credit,year,r_and_d_credit)

r_and_d_credit <- get_dataset("OECD.STI.STP,DSD_RDTAX@DF_RDSUB,1.0","TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE.A....")
r_and_d_credit <- r_and_d_credit[c(4,6,7,8,9)]
colnames(r_and_d_credit) <- c("r_and_d_credit","profit","ISO_3","size","year")
r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
r_and_d_credit$r_and_d_credit <- as.numeric(r_and_d_credit$r_and_d_credit)

r_and_d_credit <- spread(r_and_d_credit,year,r_and_d_credit)

r_and_d_credit2013 <- aggregate(r_and_d_credit$`2013`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2014 <- aggregate(r_and_d_credit$`2014`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2015 <- aggregate(r_and_d_credit$`2015`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2016 <- aggregate(r_and_d_credit$`2016`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2017 <- aggregate(r_and_d_credit$`2017`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2018 <- aggregate(r_and_d_credit$`2018`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2019 <- aggregate(r_and_d_credit$`2019`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2020 <- aggregate(r_and_d_credit$`2020`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2021 <- aggregate(r_and_d_credit$`2021`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2022 <- aggregate(r_and_d_credit$`2022`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2023 <- aggregate(r_and_d_credit$`2023`,by=list(r_and_d_credit$ISO_3),FUN=mean)
r_and_d_credit2024 <- aggregate(r_and_d_credit$`2024`,by=list(r_and_d_credit$ISO_3),FUN=mean)


ISO_3 <- r_and_d_credit2022$Group.1

r_and_d_credit <- data.frame(ISO_3, r_and_d_credit2013$x, r_and_d_credit2014$x, r_and_d_credit2015$x,
                             r_and_d_credit2016$x, r_and_d_credit2017$x, r_and_d_credit2018$x, r_and_d_credit2019$x,
                             r_and_d_credit2020$x, r_and_d_credit2021$x, r_and_d_credit2022$x, r_and_d_credit2023$x,
                             r_and_d_credit2024$x)

colnames(r_and_d_credit) <- c("ISO_3","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024")
r_and_d_credit <- gather(r_and_d_credit,"year","r_and_d_credit","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024")
r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
r_and_d_credit$year <- r_and_d_credit$year+1

write.csv(r_and_d_credit, file = paste(intermediate_outputs,"oecd_r_and_d_credit.csv",sep=""), row.names = FALSE)


#top_income_rate####

#top_income_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("TOP_TRATE")), start_time = 2013)
#top_income_rate<-top_income_rate[c(1,2,6)]
#colnames(top_income_rate)<-c("country","top_income_rate","year")

top_income_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..TS_PIT..S13......")
top_income_rate<-top_income_rate[c(10,11,14)]
colnames(top_income_rate)<-c("top_income_rate","ISO_3","year")

top_income_rate$year<-as.numeric(top_income_rate$year)

#Chile increased its top personal income tax rate from 35% to 40% as of 2020
#top_income_rate[c('top_income_rate')][top_income_rate$country == "CHL" & top_income_rate$year >= 2019,] <- "40"

#Colombia increased its top personal income tax rate from 33% to 39% as of 2019 and it has not changed since
#top_income_rate[c('top_income_rate')][top_income_rate$country == "COL" & top_income_rate$year >= 2019,] <- "39"

top_income_rate$top_income_rate<-as.numeric(top_income_rate$top_income_rate)

#top_income_rate$year<-top_income_rate$year+1

top_income_rate$top_income_rate<-top_income_rate$top_income_rate/100

#all_in_rate

#all_in_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("PER_ARATE")), start_time = 2013)
#all_in_rate<-all_in_rate[c(1,2,6)]
#colnames(all_in_rate)<-c("country","all_in_rate","year")

all_in_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..PIT_SSC_R_TH..S13......")
all_in_rate<-all_in_rate[c(10,11,14)]
colnames(all_in_rate)<-c("all_in_rate","ISO_3","year")


all_in_rate$year<-as.numeric(all_in_rate$year)
all_in_rate$all_in_rate<-as.numeric(all_in_rate$all_in_rate)

#all_in_rate$year<-all_in_rate$year+1
all_in_rate$all_in_rate<-all_in_rate$all_in_rate/100

#Create current year from prior year values
top_rate_current <- subset(top_income_rate, year == 2024)
top_rate_current$year <- 2025
top_income_rate <- rbind(top_income_rate, top_rate_current)

all_in_current <- subset(all_in_rate, year == 2024)
all_in_current$year <- 2025
all_in_rate <- rbind(all_in_rate, all_in_current)

#take the max of top rate or all-in rate
top_income_rate<-merge(top_income_rate,all_in_rate, by=c("ISO_3","year"))
top_income_rate$top_income_rate<-pmax(top_income_rate$top_income_rate,top_income_rate$all_in_rate)

#Missing Netherlands
#missing_netherlands <- c("NLD",2014,0.52,0.526)
#top_income_rate <- rbind(top_income_rate, missing_netherlands)

#threshold_top_income_rate####

#threshold<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("THRESHOLD")), start_time = 2013)
#threshold<-threshold[c(1,2,6)]

threshold<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..TS_PIT_TH..S13......")
threshold<-threshold[c(10,11,14)]
colnames(threshold)<-c("threshold_top_income_rate","ISO_3","year")

threshold$year<-as.numeric(threshold$year)
threshold$year<-threshold$year+1

#Missing Netherlands
#missing_netherlands <- c(1.179464,"NLD",2014)
#threshold <- rbind(threshold, missing_netherlands)
#missing_netherlands <- c(1.221825,"NLD",2015)
#threshold <- rbind(threshold, missing_netherlands)

#tax_wedge####

#martax_wedge

martax_wedge<-get_dataset("OECD.CTP.TPS,DSD_TAX_WAGES_COMP@DF_TW_COMP,",".MR_TW_PE.PT_COS_LB.S_C0.AW167+AW67+AW100._Z.A")

martax_wedge<-martax_wedge[c(5,9,10,11)]
colnames(martax_wedge)<-c("income","martax_wedge","ISO_3","year")
martax_wedge$martax_wedge<-as.numeric(martax_wedge$martax_wedge)
martax_wedge<-spread(martax_wedge,year,martax_wedge)

martax_wedge2013<-aggregate(martax_wedge$`2013`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2014<-aggregate(martax_wedge$`2014`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2015<-aggregate(martax_wedge$`2015`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2016<-aggregate(martax_wedge$`2016`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2017<-aggregate(martax_wedge$`2017`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2018<-aggregate(martax_wedge$`2018`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2019<-aggregate(martax_wedge$`2019`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2020<-aggregate(martax_wedge$`2020`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2021<-aggregate(martax_wedge$`2021`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2022<-aggregate(martax_wedge$`2022`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2023<-aggregate(martax_wedge$`2023`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2024<-aggregate(martax_wedge$`2024`,by=list(martax_wedge$ISO_3),FUN=mean)


#avgtax_wedge

avgtax_wedge<-get_dataset("OECD.CTP.TPS,DSD_TAX_WAGES_COMP@DF_TW_COMP,",".AV_TW.PT_COS_LB.S_C0.AW167+AW67+AW100._Z.A")

avgtax_wedge<-avgtax_wedge[c(5,9,10,11)]
colnames(avgtax_wedge)<-c("income","avgtax_wedge","ISO_3","year")
avgtax_wedge$avgtax_wedge<-as.numeric(avgtax_wedge$avgtax_wedge)

avgtax_wedge<-spread(avgtax_wedge,year,avgtax_wedge)

avgtax_wedge2013<-aggregate(avgtax_wedge$`2013`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2014<-aggregate(avgtax_wedge$`2014`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2015<-aggregate(avgtax_wedge$`2015`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2016<-aggregate(avgtax_wedge$`2016`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2017<-aggregate(avgtax_wedge$`2017`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2018<-aggregate(avgtax_wedge$`2018`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2019<-aggregate(avgtax_wedge$`2019`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2020<-aggregate(avgtax_wedge$`2020`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2021<-aggregate(avgtax_wedge$`2021`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2022<-aggregate(avgtax_wedge$`2022`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2022<-aggregate(avgtax_wedge$`2022`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2023<-aggregate(avgtax_wedge$`2023`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2024<-aggregate(avgtax_wedge$`2024`,by=list(avgtax_wedge$ISO_3),FUN=mean)

countries<-avgtax_wedge2020$Group.1

tax_wedge2013<-martax_wedge2013$x/avgtax_wedge2013$x
tax_wedge2014<-martax_wedge2014$x/avgtax_wedge2014$x
tax_wedge2015<-martax_wedge2015$x/avgtax_wedge2015$x
tax_wedge2016<-martax_wedge2016$x/avgtax_wedge2016$x
tax_wedge2017<-martax_wedge2017$x/avgtax_wedge2017$x
tax_wedge2018<-martax_wedge2018$x/avgtax_wedge2018$x
tax_wedge2019<-martax_wedge2019$x/avgtax_wedge2019$x
tax_wedge2020<-martax_wedge2020$x/avgtax_wedge2020$x
tax_wedge2021<-martax_wedge2021$x/avgtax_wedge2021$x # Previously: tax_wedge2021<-martax_wedge2020$x/avgtax_wedge2021$x
tax_wedge2022<-martax_wedge2022$x/avgtax_wedge2022$x
tax_wedge2023<-martax_wedge2023$x/avgtax_wedge2023$x
tax_wedge2024<-martax_wedge2024$x/avgtax_wedge2024$x

tax_wedge<-data.frame(countries,tax_wedge2013,tax_wedge2014,tax_wedge2015,tax_wedge2016,tax_wedge2017,tax_wedge2018,tax_wedge2019,tax_wedge2020,tax_wedge2021,tax_wedge2022, tax_wedge2023, tax_wedge2024)

colnames(tax_wedge)<-c("ISO_3","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024")
tax_wedge<-gather(tax_wedge,"year","tax_wedge","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024")
tax_wedge$year<-as.numeric(tax_wedge$year)
tax_wedge$year<-tax_wedge$year+1

tax_wedge[c('tax_wedge')][tax_wedge$ISO_3 == "COL" & tax_wedge$year >=2014,] <- 0

#Remove aggregates
tax_wedge <- tax_wedge[!tax_wedge$ISO_3 %in% c("EU22OECD", "OECD_REP"), ]

write.csv(tax_wedge, file = paste(intermediate_outputs,"oecd_taxwedge.csv",sep=""), row.names = FALSE)

#dividends_rate####

dividends_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_CIT@DF_CIT_DIVD_INCOME,1.0", filter="CHE+TUR+GBR+USA+SVK+SVN+ESP+SWE+MEX+NLD+NZL+NOR+POL+PRT+LVA+LTU+LUX+ISL+IRL+ISR+ITA+JPN+KOR+FIN+DNK+EST+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE.A.NPT.....")
dividends_rate<-dividends_rate[c(5,7,11)]
colnames(dividends_rate)<-c("dividends_rate","ISO_3","year")

dividends_rate$dividends_rate<-as.numeric(dividends_rate$dividends_rate)
dividends_rate$dividends_rate<-dividends_rate$dividends_rate/100

#Missing Slovakia
#missing_slovakia <- c(0.07,"SVK",2024)
#dividends_rate <- rbind(dividends_rate, missing_slovakia)
 
dividends_rate<-subset(dividends_rate,year>2013)

#corporate_other_rev####
corporate_other_rev <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD",
                                   "TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE..S13.T_6100+T_1300..PT_B1GQ.A")
corporate_other_rev<-corporate_other_rev[c(8,7,9,12)]
colnames(corporate_other_rev)<-c("country","corporate_other_rev","tax","year")
corporate_other_rev<-corporate_other_rev[corporate_other_rev$year >=2012,]

corporate_other_rev<-spread(corporate_other_rev,tax,corporate_other_rev)
corporate_other_rev$`1300`<-as.numeric(corporate_other_rev$`1300`)
corporate_other_rev$`1300`[is.na(corporate_other_rev$`1300`)] <- 0
corporate_other_rev$`6100`<-as.numeric(corporate_other_rev$`6100`)
corporate_other_rev$`6100`[is.na(corporate_other_rev$`6100`)] <- 0

corporate_other_rev$corporate_other_rev<-corporate_other_rev$`1300`+corporate_other_rev$`6100`
corporate_other_rev<-corporate_other_rev[c(1,2,5)]

corporate_other_rev<-subset(corporate_other_rev,country%in%oecd_countries)

corporate_other_rev$year<-as.numeric(corporate_other_rev$year)
corporate_other_rev$corporate_other_rev<-as.numeric(corporate_other_rev$corporate_other_rev)

#Add in Australia 2022 numbers
#Australia: 2023 data not available -> use 2022 data
missing_australia <- subset(corporate_other_rev, subset = country == "AUS" & year == "2022")
missing_australia[missing_australia$year == 2022, "year"] <- 2023
missing_australia$corporate_other_rev<-as.numeric(missing_australia$corporate_other_rev)

#combine
corporate_other_rev<-rbind(corporate_other_rev,missing_australia)
corporate_other_rev$year<-corporate_other_rev$year+2

write.csv(corporate_other_rev, file = paste(intermediate_outputs,"oecd_corporate_other_rev.csv",sep=""), row.names = FALSE)
corporate_other_rev<-read.csv(paste(intermediate_outputs,"oecd_corporate_other_rev.csv",sep=""))

corporate_other_rev <- corporate_other_rev %>%
  rename(ISO_3 = country)

#personal_other_rev####
personal_other_rev <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD",
                                   "TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE..S13.T_2400..PT_B1GQ.A")
personal_other_rev<-personal_other_rev[c(8,7,9,12)]
colnames(personal_other_rev)<-c("country","personal_other_rev","tax","year")
personal_other_rev<-personal_other_rev[personal_other_rev$year >=2012,]

personal_other_rev<-subset(personal_other_rev,country%in%oecd_countries)

personal_other_rev$personal_other_rev<-as.numeric(personal_other_rev$personal_other_rev)
personal_other_rev$personal_other_rev[is.na(personal_other_rev$personal_other_rev)] <- 0

personal_other_rev$year<-as.numeric(personal_other_rev$year)


#Add in Australia 2022 numbers
#Australia: 2023 data not available -> use 2022 data
missing_australia <- subset(personal_other_rev, subset = country == "AUS" & year == "2022")
missing_australia[missing_australia$year == 2022, "year"] <- 2023
missing_australia$personal_other_rev<-as.numeric(missing_australia$personal_other_rev)

#combine
personal_other_rev<-rbind(personal_other_rev,missing_australia)
personal_other_rev$year<-personal_other_rev$year+2

write.csv(personal_other_rev, file = paste(intermediate_outputs,"oecd_personal_other_rev.csv",sep=""), row.names = FALSE)
personal_other_rev<-read.csv(paste(intermediate_outputs,"oecd_personal_other_rev.csv",sep=""))

personal_other_rev <- personal_other_rev %>%
  rename(ISO_3 = country)

#End OECD data scraper#

#output####

# ISO_3 and country merge

OECDvars_data <- merge(corporate_rate, r_and_d_credit, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, top_income_rate, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, threshold, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, tax_wedge, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, dividends_rate, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, corporate_other_rev, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, personal_other_rev, by=c("ISO_3","year"))

#drop all_in_rate
OECDvars_data <- OECDvars_data[-c(6)]

colnames(OECDvars_data) <- c("ISO_3","year","corporate_rate","r_and_d_credit", "top_income_rate", "threshold_top_income_rate", "tax_wedge", "dividends_rate","corporate_other_rev","personal_other_rev")
OECDvars_data <- merge(OECDvars_data,iso_country_codes,by="ISO_3")

OECDvars_data <- OECDvars_data[c("ISO_2","ISO_3","country","year","corporate_rate","r_and_d_credit", "top_income_rate", "threshold_top_income_rate", "tax_wedge", "dividends_rate","corporate_other_rev","personal_other_rev")]

write.csv(OECDvars_data, file = paste(intermediate_outputs,"oecd_variables_data.csv",sep=""), row.names = FALSE)
