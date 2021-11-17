#World Bank Doing Business Index Data###

#Import data
wb_dbi_data <- read_excel(paste(source_data,"wb_dbi_historical_data.xlsx",sep=""),
                               range = "A4:ED3610")
#Drop unnecessary columns
wb_dbi_data <- wb_dbi_data[,-c(3:4,6:118,120:125,127,129,133:134)]

#Join with country names
pwc_paying_taxes<-merge(pwc_paying_taxes,iso_country_codes,by=c("country"),all=T)

#Subset for OECD countries
pwc_paying_taxes<-subset(pwc_paying_taxes,pwc_paying_taxes$ISO_3 %in% oecd_countries)