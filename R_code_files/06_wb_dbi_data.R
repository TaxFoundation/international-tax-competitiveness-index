#World Bank Doing Business Index Data###

#Import data
wb_dbi_data <- read_excel(paste(source_data,"wb_dbi_historical_data.xlsx",sep=""),
                               range = "A4:ED3610")
#Drop unnecessary columns
wb_dbi_data <- wb_dbi_data[,-c(3:4,6:118,120:125,127,129,131,133:134)]

#Rename columns
colnames(wb_dbi_data)<-c("ISO_3","country","year","total_hours","vat_refund_comply","vat_refund_receive","corporate_correction_comply","corporate_correction_complete")

#Join with country names
wb_dbi_data<-merge(wb_dbi_data,iso_country_codes,by=c("ISO_3","country"),all=T)

#Subset for OECD countries
wb_dbi_data<-subset(wb_dbi_data,wb_dbi_data$ISO_3 %in% oecd_countries)

#subset for 2014-2020
wb_dbi_data<-subset(wb_dbi_data,wb_dbi_data$year>2013)
