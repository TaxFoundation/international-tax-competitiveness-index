# VAT Source Data

#VAT Rates####

vat_rates <- read_excel(paste(source_data,"oecd_vat_gst_rates_ctt_trends.xlsx",sep=""), 
                                       range = "A2:r39")

vat_rates<-vat_rates[-c(2:7)]

colnames(vat_rates) <- c("country","2012","2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021","2022")

#US VAT rate equivalent
columns <- names(vat_rates)
values <- c("United States","7.2","7.2","7.2","7.3","7.3","7.4","7.4","7.4","7.4","7.4","7.4")
US <- data.frame(columns, values)
US <- spread(US, columns, values)

vat_rates <- rbind(vat_rates, US)

#Canada VAT rate equivalent - https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/
columns <- names(vat_rates)
values <- c("Canada","15.6","15.6","15.6","10.6","10.6","12.4","12.4","12.4","12.4","12.4","12.4")
Canada <- data.frame(columns, values)
Canada <- spread(Canada, columns, values)

vat_rates <- subset(vat_rates, vat_rates$country!="Canada*")
vat_rates <- rbind(vat_rates, Canada)

vat_rates <- melt(vat_rates,id.vars=c("country"))
colnames(vat_rates) <- c("country", "year", "vat_rate")
vat_rates$country <- str_remove_all(vat_rates$country, "[*]")

vat_rates_vrr<-subset(vat_rates,vat_rates$year!="2021"&vat_rates$year!="2022")

vat_rates<-subset(vat_rates,vat_rates$year!="2012"&vat_rates$year!="2013")

write.csv(vat_rates,paste(intermediate_outputs,"vat_rates.csv",sep=""),row.names = FALSE)


#VAT Thresholds####
vat_thresholds_2014 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2014", range = "a4:d37")
vat_thresholds_2016 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2016", range = "a4:e41")
vat_thresholds_2018 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2018", range = "A4:e42")
vat_thresholds_2020 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2020", range = "A4:e43")
vat_thresholds_2022 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2022", range = "A4:e43")

#2014
vat_thresholds_2014 <- vat_thresholds_2014[-c(2:3)]
colnames(vat_thresholds_2014) <- c("country","vat_threshold")
vat_thresholds_2014$country <- str_remove_all(vat_thresholds_2014$country, "[*]")
vat_thresholds_2014$year <- "2014"

#2015
vat_thresholds_2015 <- vat_thresholds_2014
vat_thresholds_2015$year <- "2015"

#2016
vat_thresholds_2016 <- vat_thresholds_2016[-c(2:4)]
colnames(vat_thresholds_2016) <- c("country","vat_threshold")
vat_thresholds_2016$country <- str_remove_all(vat_thresholds_2016$country, "[(f)*]")
vat_thresholds_2016$year <- "2016"

#2017
vat_thresholds_2017 <- vat_thresholds_2016
vat_thresholds_2017$year <- "2017"

#2018
vat_thresholds_2018 <- vat_thresholds_2018[-c(2:4)]
colnames(vat_thresholds_2018) <- c("country", "vat_threshold")
vat_thresholds_2018$country <- str_remove_all(vat_thresholds_2018$country, "[6*]")
vat_thresholds_2018$year <- "2018"

#2019
vat_thresholds_2019 <- vat_thresholds_2018
vat_thresholds_2019$year <- "2019"

#2020
vat_thresholds_2020 <- vat_thresholds_2020[-c(2:4)]
colnames(vat_thresholds_2020) <- c("country", "vat_threshold")
vat_thresholds_2020$country <- str_remove_all(vat_thresholds_2020$country, "[6*]")
vat_thresholds_2020$year <- "2020"

#2021
vat_thresholds_2021 <- vat_thresholds_2020
vat_thresholds_2021$year <- "2021"

#2022
vat_thresholds_2022 <- vat_thresholds_2022[-c(2:4)]
colnames(vat_thresholds_2022) <- c("country", "vat_threshold")
vat_thresholds_2022$country <- str_remove_all(vat_thresholds_2022$country, "[6*]")
vat_thresholds_2022$year <- "2022"


#Combine years
vat_thresholds <- rbind(vat_thresholds_2014, vat_thresholds_2015, vat_thresholds_2016, 
                        vat_thresholds_2017, vat_thresholds_2018, vat_thresholds_2019, 
                        vat_thresholds_2020, vat_thresholds_2021, vat_thresholds_2022)

#Change NAs to zeros and delete empty rows
vat_thresholds$country<-as.character(vat_thresholds$country)
vat_thresholds$country[is.na(vat_thresholds$country)] <- "0"
vat_thresholds$vat_threshold[is.na(vat_thresholds$vat_threshold)] <- 0
vat_thresholds <- subset(vat_thresholds, vat_thresholds$country!="0")


#Add US for all years; Latvia for 2014 and 2015; Lithuania for 2014, 2015, 2016, 2017; Colombia for 2014-2019, and Costa Rica for all years up to 2021#
country <- c("United States","United States","United States","United States","United States","United States", "United States", "United States", "United States")
vat_threshold <- c("0","0","0","0","0","0","0","0","0")
year <- c("2014","2015","2016","2017","2018","2019","2020","2021","2022")
USA <- data.frame(country, vat_threshold, year)

country <- c("Latvia", "Latvia")
vat_threshold <- c("100402", "100604")
year <- c("2014", "2015")
LVA <- data.frame(country, vat_threshold, year)

country <- c("Lithuania", "Lithuania", "Lithuania", "Lithuania")
vat_threshold <- c("101580", "100897", "100671", "100223")
year <- c("2014", "2015", "2016", "2017")
LTU <- data.frame(country,vat_threshold,year)

country <- c("Colombia","Colombia","Colombia","Colombia","Colombia","Colombia")
vat_threshold <- c("0","0","0","0","0","0")
year <- c("2014","2015","2016","2017","2018","2019")
COL <- data.frame(country, vat_threshold, year)

country <- c("Costa Rica","Costa Rica","Costa Rica","Costa Rica","Costa Rica","Costa Rica","Costa Rica","Costa Rica")
vat_threshold <- c("0","0","0","0","0","0","0","0")
year <- c("2014","2015","2016","2017","2018","2019","2020","2021")
CRI <- data.frame(country, vat_threshold, year)

vat_thresholds <- rbind(vat_thresholds, USA, LVA, LTU, COL, CRI)

#Rename Turkey (Türkiye) for 2022
vat_thresholds$country[vat_thresholds$country == "Türkiye"]<-"Turkey"

write.csv(vat_thresholds,paste(intermediate_outputs,"vat_thresholds.csv",sep=""),row.names = FALSE)


#Vat Base####

#VRR = vat_revenue/[(Consumption-VAT revenue)*standard VAT rate]
vat_revenue <- get_dataset("REV", filter= list(c("NES"),c("5111"),c("TAXNAT")),start_time = 2012)
vat_revenue <- subset(vat_revenue,vat_revenue$COU%in%oecd_countries)
vat_revenue <- vat_revenue[c(1,3,7)]

#missing
missing_australia <- subset(vat_revenue, subset = COU == "AUS" & Time == "2019")
missing_greece <- subset(vat_revenue, subset = COU == "GRC" & Time == "2019")
missing_japan <- subset(vat_revenue, subset = COU == "JPN" & Time == "2019")

missing_australia$Time<-2020
missing_greece$Time<-2020
missing_japan$Time<-2020

#Replace US VAT revenue with US sales tax revenue
US_sales_revenue <- get_dataset("REV", filter= list(c("NES"),c("5112"),c("TAXNAT"),c("USA")),start_time = 2012)
US_sales_revenue <- US_sales_revenue[c(1,3,7)]

#combine
US_sales_revenue<-rbind(US_sales_revenue,missing_us)

vat_revenue<-subset(vat_revenue,vat_revenue$COU!="USA")

#combine
vat_revenue<-rbind(vat_revenue,missing_australia,missing_greece,US_sales_revenue)

#relabel
colnames(vat_revenue)<-c("ISO_3","vat_revenue","year")

#Final Consumption
final_consumption <- get_dataset("SNA_TABLE1", filter= list(c(oecd_countries),c("P3"),c("C")),start_time = 2012, end_time = 2021)
final_consumption<-final_consumption[c(1,4,8)]

#missing
#missing_turkey <- subset(final_consumption, subset = LOCATION == "TUR" & Time == "2019")
#missing_turkey$Time<-2020

#combine
final_consumption<-rbind(final_consumption,missing_turkey)

#relabel
colnames(final_consumption)<-c("ISO_3","final_consumption","year")

#turn into billions
final_consumption$final_consumption<-as.numeric(final_consumption$final_consumption)
final_consumption$final_consumption<-final_consumption$final_consumption/1000

vat_rates_vrr<-merge(vat_rates_vrr,iso_country_codes,by="country")

#combine rates, revenue, consumption data
vat_base<-merge(vat_rates_vrr,vat_revenue,by=c("ISO_3","year"))
vat_base<-merge(vat_base,final_consumption,by=c("ISO_3","year"))

vat_base$vat_rate<-as.numeric(vat_base$vat_rate)
vat_base$vat_revenue<-as.numeric(vat_base$vat_revenue)
vat_base$final_consumption<-as.numeric(vat_base$final_consumption)

vat_base$vat_base<-vat_base$vat_revenue/((vat_base$final_consumption-vat_base$vat_revenue)*(vat_base$vat_rate/100))


#Add 2-year lag
vat_base$year <- as.character.Date(vat_base$year)
vat_base$year <- as.numeric(vat_base$year)
vat_base$year <- vat_base$year+2

write.csv(vat_base,paste(intermediate_outputs,"vat_base.csv",sep=""), row.names = FALSE)

#Combine files####
vat_base <- read_csv(paste(intermediate_outputs,"vat_base.csv",sep=""))
vat_base<-vat_base[c(2,3,8)]
vat_rates <- read_csv(paste(intermediate_outputs,"vat_rates.csv",sep=""))
vat_thresholds <- read_csv(paste(intermediate_outputs,"vat_thresholds.csv",sep=""))

vat_data <- merge(vat_rates, vat_thresholds, by=c("country","year"))
vat_data <- merge(vat_data,vat_base,by=c("country", "year"))

vat_data <- merge(vat_data,iso_country_codes,by=c("country"))
vat_data <- vat_data[c("ISO_2","ISO_3","country","year","vat_rate","vat_threshold","vat_base")]

write.csv(vat_data,file = paste(intermediate_outputs,"vat_data.csv",sep=""),row.names=F)
