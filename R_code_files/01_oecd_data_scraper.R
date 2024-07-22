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
missing_slovakia <- c(0.21,"SVK",2024)
corporate_rate <- rbind(corporate_rate, missing_slovakia)

#Missing Turkey
missing_turkey <- c(0.25,"TUR",2024)
corporate_rate <- rbind(corporate_rate, missing_turkey)

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

ISO_3 <- r_and_d_credit2022$Group.1

r_and_d_credit <- data.frame(ISO_3, r_and_d_credit2013$x, r_and_d_credit2014$x, r_and_d_credit2015$x,
                             r_and_d_credit2016$x, r_and_d_credit2017$x, r_and_d_credit2018$x, r_and_d_credit2019$x, r_and_d_credit2020$x, r_and_d_credit2021$x, r_and_d_credit2022$x, r_and_d_credit2023$x)

colnames(r_and_d_credit) <- c("ISO_3","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023")
r_and_d_credit <- gather(r_and_d_credit,"year","r_and_d_credit","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023")
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


#take the max of top rate or all-in rate
top_income_rate<-merge(top_income_rate,all_in_rate, by=c("ISO_3","year"))
top_income_rate$top_income_rate<-pmax(top_income_rate$top_income_rate,top_income_rate$all_in_rate)

#threshold_top_income_rate####

#threshold<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("THRESHOLD")), start_time = 2013)
#threshold<-threshold[c(1,2,6)]

threshold<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..TS_PIT_TH..S13......")
threshold<-threshold[c(10,11,14)]
colnames(threshold)<-c("threshold_top_income_rate","ISO_3","year")

threshold$year<-as.numeric(threshold$year)
#threshold$year<-threshold$year+1

#tax_wedge####

#New API: 2023 values
martax_wedge<-get_dataset("OECD.CTP.TPS,DSD_TAX_WAGES_DECOMP@DF_TW_DECOMP,1.0",".MR_TW.PT_COS_LB.S_C0.AW167+AW133+AW100+AW67..A")

martax_wedge<-martax_wedge[c("REF_AREA","INCOME_PRINCIPAL","ObsValue","TIME_PERIOD")]
colnames(martax_wedge)<-c("ISO_3","income","martax_wedge","year")
martax_wedge$martax_wedge<-as.numeric(martax_wedge$martax_wedge)
martax_wedge<-spread(martax_wedge,year,martax_wedge)

martax_wedge2023<-aggregate(martax_wedge$`2023`,by=list(martax_wedge$ISO_3),FUN=mean)

avgtax_wedge<-get_dataset("OECD.CTP.TPS,DSD_TAX_WAGES_DECOMP@DF_TW_DECOMP,1.0",".AV_TW.PT_COS_LB.S_C0.AW167+AW133+AW100+AW67..A")

avgtax_wedge<-avgtax_wedge[c("REF_AREA","INCOME_PRINCIPAL","ObsValue","TIME_PERIOD")]
colnames(avgtax_wedge)<-c("ISO_3","income","avgtax_wedge","year")
avgtax_wedge$avgtax_wedge<-as.numeric(avgtax_wedge$avgtax_wedge)
avgtax_wedge<-spread(avgtax_wedge,year,avgtax_wedge)

avgtax_wedge2023<-aggregate(avgtax_wedge$`2023`,by=list(avgtax_wedge$ISO_3),FUN=mean)

tax_wedge2023<-martax_wedge2023$x/avgtax_wedge2023$x

tax_wedge2023 <- merge(x = martax_wedge2023,y = avgtax_wedge2023,by = "Group.1",suffixes = c("_x", "_y"))
tax_wedge2023$tax_wedge <- tax_wedge2023$x_x / tax_wedge2023$x_y
tax_wedge2023<-tax_wedge2023[c("Group.1","tax_wedge")]
colnames(tax_wedge2023)<-c("ISO_3","tax_wedge")

write.csv(tax_wedge2023, file = paste(intermediate_outputs,"oecd_taxwedge2023.csv",sep=""), row.names = FALSE)
"
#martax_wedge

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
martax_wedge2022<-aggregate(martax_wedge$`2022`,by=list(martax_wedge$country),FUN=mean)

#avgtax_wedge

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
avgtax_wedge2022<-aggregate(avgtax_wedge$`2022`,by=list(avgtax_wedge$country),FUN=mean)


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


tax_wedge<-data.frame(countries,tax_wedge2013,tax_wedge2014,tax_wedge2015,tax_wedge2016,tax_wedge2017,tax_wedge2018,tax_wedge2019,tax_wedge2020,tax_wedge2021,tax_wedge2022)

colnames(tax_wedge)<-c("country","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")
tax_wedge<-gather(tax_wedge,"year","tax_wedge","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")
tax_wedge$year<-as.numeric(tax_wedge$year)
tax_wedge$year<-tax_wedge$year+1

tax_wedge[c('tax_wedge')][tax_wedge$country == "COL" & tax_wedge$year >=2014,] <- 0
"


#dividends_rate####

#dividends_rate <- get_dataset("OECD,DF_TABLE_II4,1.0","")

#dividends_rate<-get_dataset("Table_II4",filter= list(c(oecd_countries),c("NET_PERS_TAX")), start_time = 2014)
#dividends_rate<-dividends_rate[c(1,2,5)]

#dividends_rate<-read_csv(paste(source_data,"oecd_table_ii4_overall-dividends-rate.csv",sep=""))
#dividends_rate<-dividends_rate[c(5,9,11)]
#colnames(dividends_rate)<-c("ISO_3","year","dividends_rate")

dividends_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_CIT@DF_CIT_DIVD_INCOME,1.0", filter="CHE+TUR+GBR+USA+SVK+SVN+ESP+SWE+MEX+NLD+NZL+NOR+POL+PRT+LVA+LTU+LUX+ISL+IRL+ISR+ITA+JPN+KOR+FIN+DNK+EST+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE.A.NPT.....")
dividends_rate<-dividends_rate[c(5,7,11)]
colnames(dividends_rate)<-c("dividends_rate","ISO_3","year")

dividends_rate$dividends_rate<-as.numeric(dividends_rate$dividends_rate)
dividends_rate$dividends_rate<-dividends_rate$dividends_rate/100

# OLD API: Corporate and personal other revenue

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

#Add in Australia and Greece 2021 numbers
#Australia: 2022 data not available -> use 2020 data
missing_australia <- subset(corporate_other_rev, subset = country == "AUS" & year == "2020")
missing_australia[missing_australia$year == 2021, "year"] <- 2022

#Greece: 2022 data not available -> use 2020 data
missing_greece <- subset(corporate_other_rev, subset = country == "GRC" & year == "2020")
missing_greece[missing_greece$year == 2021, "year"] <- 2022

#combine
corporate_other_rev<-rbind(corporate_other_rev,missing_australia,missing_greece)
corporate_other_rev$year<-corporate_other_rev$year+2

write.csv(corporate_other_rev, file = paste(intermediate_outputs,"oecd_corporate_other_rev.csv",sep=""), row.names = FALSE)
corporate_other_rev<-read.csv(paste(intermediate_outputs,"oecd_corporate_other_rev.csv",sep=""))


#personal_other_rev####
taxes<-c("2400")
personal_other_rev <- get_dataset("REV", filter= list(c("NES"),c(taxes),c("TAXPER")),start_time = 2012)
personal_other_rev<-personal_other_rev[c(1,3,7)]
colnames(personal_other_rev)<-c("country","personal_other_rev","year")

personal_other_rev<-subset(personal_other_rev,country%in%oecd_countries)

personal_other_rev$personal_other_rev<-as.numeric(personal_other_rev$personal_other_rev)
personal_other_rev$year<-as.numeric(personal_other_rev$year)

#Add in Australia, Greece, Hungary, and Japan 2021 numbers
#Australia: 2021 data not available -> use 2021 data
missing_australia <- subset(personal_other_rev, subset = country == "AUS" & year == "2021")
missing_australia[missing_australia$year == 2021, "year"] <- 2022

#Hungary: 2021 data not available -> use 2021 data
missing_hungary <- subset(personal_other_rev, subset = country == "HUN" & year == "2021")
missing_hungary[missing_hungary$year == 2021, "year"] <- 2022

#Japan: 2021 data not available -> use 2021 data
missing_japan <- subset(personal_other_rev, subset = country == "JPN" & year == "2021")
missing_japan[missing_japan$year == 2021, "year"] <- 2022

#Greece: 2021 data not available -> use 2021 data
missing_greece <- subset(personal_other_rev, subset = country == "GRC" & year == "2021")
missing_greece[missing_greece$year == 2021, "year"] <- 2022

#combine
personal_other_rev<-rbind(personal_other_rev,missing_australia,missing_japan,missing_hungary,missing_greece)
personal_other_rev$year<-personal_other_rev$year+2

write.csv(personal_other_rev, file = paste(intermediate_outputs,"oecd_personal_other_rev.csv",sep=""), row.names = FALSE)
personal_other_rev<-read.csv(paste(intermediate_outputs,"oecd_personal_other_rev.csv",sep=""))


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
