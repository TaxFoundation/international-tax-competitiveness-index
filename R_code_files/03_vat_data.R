# VAT Source Data

#VAT Rates####

vat_rates <- read_excel(paste(source_data,"oecd_vat_gst_rates_ctt_trends.xlsx",sep=""), 
                                       range = "A2:U39")

vat_rates<-vat_rates[-c(2:7)]

colnames(vat_rates) <- c("country","2012","2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021","2022","2023","2024","2025")

#US VAT rate equivalent
columns <- names(vat_rates)
values <- c("United States","7.2","7.2","7.2","7.3","7.3","7.4","7.4","7.4","7.4","7.4","7.4","7.5","0","0")
US <- data.frame(columns, values)
US <- spread(US, columns, values)

vat_rates <- rbind(vat_rates, US)

#Canada VAT rate equivalent - https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/
columns <- names(vat_rates)
values <- c("Canada","15.6","15.6","15.6","10.6","10.6","12.4","12.4","12.4","12.4","12.4","12.4","12.4","12.4","12.3")
Canada <- data.frame(columns, values)
Canada <- spread(Canada, columns, values)

vat_rates <- subset(vat_rates, vat_rates$country!="Canada*")
vat_rates <- rbind(vat_rates, Canada)

vat_rates <- melt(vat_rates,id.vars=c("country"))
colnames(vat_rates) <- c("country", "year", "vat_rate")
vat_rates$country <- str_remove_all(vat_rates$country, "[*]")

#Rename Turkey (Türkiye) for consistency
vat_rates$country[vat_rates$country == "Türkiye"]<-"Turkey"

vat_rates_vrr<-subset(vat_rates,vat_rates$year!="2024")
#Costa Rica (for VAT Base calculation later)
vat_rates_vrr$year <- as.numeric(as.character(vat_rates_vrr$year))

vat_rates_vrr$vat_rate[vat_rates_vrr$country == "Costa Rica" & vat_rates_vrr$year < 2020] <- 13


vat_rates$year <- as.numeric(as.character(vat_rates$year))

vat_rates<-subset(vat_rates,vat_rates$year>=2014)


#Hardcoding Costa Rica before 2020
vat_rates$vat_rate[vat_rates$country == "Costa Rica" & vat_rates$year < 2020] <- 13


#Add 1-year lag to rates
#vat_rates$year <- as.numeric(as.character(vat_rates$year))+1

#Create current year from prior year values
#vat_current <- subset(vat_rates, year == 2023)
#vat_current$year <- 2024
#vat_rates <- rbind(vat_rates, vat_current)

# US still missing
write.csv(vat_rates,paste(intermediate_outputs,"vat_rates.csv",sep=""),row.names = FALSE)


#VAT Thresholds####
vat_thresholds_2014 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2014", range = "A4:D37")
vat_thresholds_2016 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2016", range = "A4:E41")
vat_thresholds_2018 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2018", range = "A4:E42")
vat_thresholds_2020 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2020", range = "A4:E43")
vat_thresholds_2022 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2022", range = "A4:E44")
vat_thresholds_2023 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2023", range = "A4:E44")
vat_thresholds_2024 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2024", range = "A4:E44")

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

#2023
vat_thresholds_2023 <- vat_thresholds_2023[-c(2:4)]
colnames(vat_thresholds_2023) <- c("country", "vat_threshold")
vat_thresholds_2023$country <- str_remove_all(vat_thresholds_2023$country, "[6*]")
vat_thresholds_2023$year <- "2023"

#2024
vat_thresholds_2024 <- vat_thresholds_2024[-c(2:4)]
colnames(vat_thresholds_2024) <- c("country", "vat_threshold")
vat_thresholds_2024$country <- str_remove_all(vat_thresholds_2023$country, "[6*]")
vat_thresholds_2024$year <- "2024"

#Combine years
vat_thresholds <- rbind(vat_thresholds_2014, vat_thresholds_2015, vat_thresholds_2016, 
                        vat_thresholds_2017, vat_thresholds_2018, vat_thresholds_2019, 
                        vat_thresholds_2020, vat_thresholds_2021, vat_thresholds_2022,
                        vat_thresholds_2023, vat_thresholds_2024)


#Change NAs to zeros and delete empty rows
vat_thresholds$country<-as.character(vat_thresholds$country)
vat_thresholds$country[is.na(vat_thresholds$country)] <- "0"
vat_thresholds$vat_threshold[is.na(vat_thresholds$vat_threshold)] <- 0
vat_thresholds <- subset(vat_thresholds, vat_thresholds$country!="0")

#Rename Turkey (Türkiye) from 2022
vat_thresholds$country[vat_thresholds$country == "Türkiye"]<-"Turkey"

#Add US for all years; Latvia for 2014 and 2015; Lithuania for 2014, 2015, 2016, 2017; Colombia for 2014-2019, and Costa Rica for all years up to 2021#
country <- c("United States","United States","United States","United States","United States","United States", "United States", "United States", "United States", "United States","United States")
vat_threshold <- c("0","0","0","0","0","0","0","0","0","0","0")
year <- c("2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024")
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

#country <- c("United Kingdom","United Kingdom")
#vat_threshold <- c("123188","125000")
#year <- c("2022","2023")
#GBR <- data.frame(country, vat_threshold, year)

vat_thresholds <- rbind(vat_thresholds, USA, LVA, LTU, COL, CRI)

#Create current year from prior year values
vat_current <- subset(vat_thresholds, year == 2024)
vat_current$year <- 2025
vat_thresholds <- rbind(vat_thresholds, vat_current)


write.csv(vat_thresholds,paste(intermediate_outputs,"vat_thresholds.csv",sep=""),row.names = FALSE)


#Vat Base####

#VRR = vat_revenue/[(Consumption-VAT revenue)*standard VAT rate]
vat_revenue <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD,1.1","COL+CHL+CAN+BEL+AUT+AUS+FRA+FIN+EST+DNK+CZE+CRI+ISR+IRL+ISL+HUN+GRC+DEU+KOR+JPN+ITA+NZL+NLD+MEX+LUX+LTU+LVA+PRT+ESP+SVN+SVK+POL+NOR+GBR+TUR+CHE+SWE..S13.T_5111..XDC.")
vat_revenue <- vat_revenue[c(8,12,7)]
colnames(vat_revenue) <- c("country","year","vat_revenue")

#Replace US VAT revenue with US sales tax revenue
US_sales_revenue <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD,1.1","USA..S13.T_5112..XDC.") 
US_sales_revenue <- US_sales_revenue[c(8,12,7)]
colnames(US_sales_revenue) <- c("country","year","vat_revenue")

#combine
#US_sales_revenue<-rbind(US_sales_revenue,missing_us)

#vat_revenue<-subset(vat_revenue,vat_revenue$country!="USA")

#missing
missing_greece <- subset(vat_revenue, subset = country == "GRC" & year == "2022")
missing_greece$year<-2023

missing_australia <- subset(vat_revenue, subset = country == "AUS" & year == "2022")
missing_australia$year<-2023

#combine
vat_revenue<-rbind(vat_revenue,US_sales_revenue,missing_greece, missing_australia)

#Cutoff
vat_revenue<-subset(vat_revenue, year >= 2012)

colnames(vat_revenue) <- c("ISO_3","year","vat_revenue")
vat_revenue<-merge(vat_revenue,iso_country_codes,by="ISO_3")


#Final Consumption
final_consumption <- get_dataset("OECD.SDD.NAD,DSD_NAMAIN10@DF_TABLE1_EXPENDITURE,2.0","A.AUS+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LVA+LTU+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA+AUT+BEL+CAN+CHL+COL+CRI+CZE.S1M..P3....XDC.V..")
final_consumption<-final_consumption[c(12,15,10)]
#relabel
colnames(final_consumption) <- c("ISO_3","year","final_consumption")
#Cutoff
final_consumption<-subset(final_consumption, year >= 2012)

#missing
missing_costarica <- subset(final_consumption, subset = ISO_3 == "CRI" & year == "2022")
missing_costarica$year<-2023

#combine
final_consumption<-rbind(final_consumption,missing_costarica)

final_consumption<-merge(final_consumption,iso_country_codes,by="ISO_3")

#turn into billions
final_consumption$final_consumption<-as.numeric(final_consumption$final_consumption)
final_consumption$final_consumption<-final_consumption$final_consumption/1000

vat_rates_vrr<-merge(vat_rates_vrr,iso_country_codes,by="country")
vat_rates_vrr<-vat_rates_vrr[c("country","year","vat_rate")]
final_consumption<-final_consumption[c("country","year","final_consumption")]

#combine rates, revenue, consumption data
vat_base<-merge(vat_rates_vrr,vat_revenue,by=c("country","year"))
vat_base<-merge(vat_base,final_consumption,by=c("country","year"))

vat_base$vat_rate<-as.numeric(vat_base$vat_rate)
vat_base$vat_revenue<-as.numeric(vat_base$vat_revenue)
vat_base$final_consumption<-as.numeric(vat_base$final_consumption)

vat_base$vat_base<-vat_base$vat_revenue/((vat_base$final_consumption-vat_base$vat_revenue)*(vat_base$vat_rate/100))


#Add 2-year lag to base
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
