#Standard Withholding Tax Rates

###Code works for 2022 and subsequent years

#dividends
dividend_rates<-get_dataset("OECD.CTP.TPS,DSD_WHT@DF_WHT_STANDARD,1.0", filter="BEL+AUT+AUS+CZE+CRI+COL+CHL+CAN+GRC+DEU+FRA+FIN+EST+DNK+JPN+ITA+ISR+IRL+ISL+HUN+NLD+MEX+LUX+LTU+LVA+KOR+SVN+SVK+PRT+POL+NOR+NZL+USA+GBR+TUR+CHE+SWE+ESP..A.WHT_DIV..STA.")
dividend_rates<-dividend_rates[c(6,7,5)]
colnames(dividend_rates)<-c("ISO_3","year","dividends")

#interest
interest_rates<-get_dataset("OECD.CTP.TPS,DSD_WHT@DF_WHT_STANDARD,1.0", filter="BEL+AUT+AUS+CZE+CRI+COL+CHL+CAN+GRC+DEU+FRA+FIN+EST+DNK+JPN+ITA+ISR+IRL+ISL+HUN+NLD+MEX+LUX+LTU+LVA+KOR+SVN+SVK+PRT+POL+NOR+NZL+USA+GBR+TUR+CHE+SWE+ESP..A.WHT_INT..STA.")
interest_rates<-interest_rates[c(6,7,5)]
colnames(interest_rates)<-c("ISO_3","year","interest")

#royalties
royalties_rates<-get_dataset("OECD.CTP.TPS,DSD_WHT@DF_WHT_STANDARD,1.0", filter="BEL+AUT+AUS+CZE+CRI+COL+CHL+CAN+GRC+DEU+FRA+FIN+EST+DNK+JPN+ITA+ISR+IRL+ISL+HUN+NLD+MEX+LUX+LTU+LVA+KOR+SVN+SVK+PRT+POL+NOR+NZL+USA+GBR+TUR+CHE+SWE+ESP..A.WHT_ROY..STA.")
royalties_rates<-royalties_rates[c(6,7,5)]
colnames(royalties_rates)<-c("ISO_3","year","royalties")

# ISO_3 and country merge
withholding_rates <- merge(dividend_rates, interest_rates, by=c("ISO_3","year"))
withholding_rates <- merge(withholding_rates, royalties_rates, by=c("ISO_3","year"))

#Create current year from prior year values
withholding_rates_current <- subset(withholding_rates, year == 2024)
withholding_rates_current$year <- 2025
withholding_rates <- rbind(withholding_rates, withholding_rates_current)

withholding_rates <- merge(withholding_rates,iso_country_codes,by="ISO_3")
withholding_rates <- withholding_rates[c("ISO_2","ISO_3","country","year","dividends","interest", "royalties")]

write.csv(withholding_rates, file = paste(intermediate_outputs,"oecd_withholding_rates.csv",sep=""), row.names = FALSE)
