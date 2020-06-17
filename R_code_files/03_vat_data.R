# VAT Source Data

#VAT Rates####

vat_rates <- read_excel(paste(source_data,"oecd_vat_gst_rates_ctt_trends.xlsx",sep=""), 
                                       range = "A4:T39")

vat_rates<-vat_rates[-c(3:13)]

colnames(vat_rates) <- c("country", "year", "2014", "2015", "2016", "2017", "2018", "2019", "2020")

#US VAT rate equivalent
columns <- names(vat_rates)
values <- c("United States","","7.2","7.3","7.3","7.4","7.4","7.4","7.4")
US <- data.frame(columns, values)
US <- spread(US, columns, values)

vat_rates <- rbind(vat_rates, US)

#Canada VAT rate equivalent - https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/
columns <- names(vat_rates)
values <- c("Canada","","15.6","10.6","10.6","12.4","12.4","12.4","12.4")
Canada <- data.frame(columns, values)
Canada <- spread(Canada, columns, values)

vat_rates <- subset(vat_rates, vat_rates$country!="Canada*")
vat_rates <- rbind(vat_rates, Canada)

vat_rates <- vat_rates[-c(2)]
vat_rates <- melt(vat_rates,id.vars=c("country"))
colnames(vat_rates) <- c("country", "year", "vat_rate")
vat_rates$country <- str_remove_all(vat_rates$country, "[*]")

write.csv(vat_rates,paste(intermediate_outputs,"vat_rates.csv",sep=""),row.names = FALSE)


#VAT Thresholds####

vat_thresholds_2020 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2020", range = "A4:e42")
vat_thresholds_2018 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2018", range = "A4:e42")
vat_thresholds_2016 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2016", range = "a4:e41")
vat_thresholds_2014 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2014", range = "a4:d37")

#2020
vat_thresholds_2020 <- vat_thresholds_2020[-c(2:4)]
colnames(vat_thresholds_2020) <- c("country", "vat_threshold")
vat_thresholds_2020$country <- str_remove_all(vat_thresholds_2020$country, "[6*]")
vat_thresholds_2020$year <- "2020"

#2018
vat_thresholds_2018 <- vat_thresholds_2018[-c(2:4)]
colnames(vat_thresholds_2018) <- c("country", "vat_threshold")
vat_thresholds_2018$country <- str_remove_all(vat_thresholds_2018$country, "[6*]")
vat_thresholds_2018$year <- "2018"

#2019
vat_thresholds_2019 <- vat_thresholds_2018
vat_thresholds_2019$year <- "2019"

#2016
vat_thresholds_2016 <- vat_thresholds_2016[-c(2:4)]
colnames(vat_thresholds_2016) <- c("country","vat_threshold")
vat_thresholds_2016$country <- str_remove_all(vat_thresholds_2016$country, "[(f)*]")
vat_thresholds_2016$year <- "2016"

#2017
vat_thresholds_2017 <- vat_thresholds_2016
vat_thresholds_2017$year <- "2017"

#2014
vat_thresholds_2014 <- vat_thresholds_2014[-c(2:3)]
colnames(vat_thresholds_2014) <- c("country","vat_threshold")
vat_thresholds_2014$country <- str_remove_all(vat_thresholds_2014$country, "[*]")
vat_thresholds_2014$year <- "2014"

#2015
vat_thresholds_2015 <- vat_thresholds_2014
vat_thresholds_2015$year <- "2015"

#Combine years
vat_thresholds <- rbind(vat_thresholds_2014, vat_thresholds_2015, vat_thresholds_2016, vat_thresholds_2017, vat_thresholds_2018, vat_thresholds_2019, vat_thresholds_2020)

#Change NAs to zeros and delete empty rows
vat_thresholds[is.na(vat_thresholds)] <- 0
vat_thresholds <- subset(vat_thresholds, vat_thresholds$country!="0")

#Add US for all years; Latvia for 2014 and 2015; Lithuania for 2014, 2015, 2016, 2017#
country <- c("United States","United States","United States","United States","United States","United States", "United States")
vat_threshold <- c("0","0","0","0","0","0","0")
year <- c("2014","2015","2016","2017","2018","2019","2020")
USA <- data.frame(country, vat_threshold, year)

country <- c("Latvia", "Latvia")
vat_threshold <- c("100402", "100604")
year <- c("2014", "2015")
LVA <- data.frame(country, vat_threshold, year)

country <- c("Lithuania", "Lithuania", "Lithuania", "Lithuania")
vat_threshold <- c("101580", "100897", "100671", "100223")
year <- c("2014", "2015", "2016", "2017")
LTU <- data.frame(country,vat_threshold,year)

vat_thresholds <- rbind(vat_thresholds, USA, LVA, LTU)

write.csv(vat_thresholds,paste(intermediate_outputs,"vat_thresholds.csv",sep=""),row.names = FALSE)


#Vat Base####
#Source data: https://doi.org/10.1787/888933890122
vat_base <- read_excel(paste(source_data,"oecd_vat_revenue_ratio_calculations.xlsx",sep=""), 
                                             sheet = "Sheet1", range = "A7:W43")
vat_base <- vat_base[-c(2:16)]

columns <- names(vat_base)
values<-c("United States","0.397","0.397","0.397","0.397","0.4","0.4","0.4")
US <- data.frame(columns, values)
US <- spread(US, columns, values)

vat_base <- rbind(vat_base, US)

vat_base <- melt(vat_base, id.vars=c("Country"))
colnames(vat_base) <- c("country","year","vat_base")

#Change NAs to zeros and delete those rows
vat_base[is.na(vat_base)] <- 0
vat_base <- subset(vat_base,country!="0")

#Add 2-year lag
vat_base$year <- as.character.Date(vat_base$year)
vat_base$year <- as.numeric(vat_base$year)
vat_base$year <- vat_base$year+2

write.csv(vat_base,paste(intermediate_outputs,"vat_base.csv",sep=""), row.names = FALSE)


#Combine files####
vat_base <- read_csv(paste(intermediate_outputs,"vat_base.csv",sep=""))
vat_rates <- read_csv(paste(intermediate_outputs,"vat_rates.csv",sep=""))
vat_thresholds <- read_csv(paste(intermediate_outputs,"vat_thresholds.csv",sep=""))

vat_data <- merge(vat_rates, vat_thresholds, by=c("country","year"))
vat_data <- merge(vat_data,vat_base,by=c("country", "year"))

vat_data <- merge(vat_data,iso_country_codes,by=c("country"))
vat_data <- vat_data[c("ISO_2","ISO_3","country","year","vat_rate","vat_threshold","vat_base")]

write.csv(vat_data,file = paste(intermediate_outputs,"vat_data.csv",sep=""),row.names=F)