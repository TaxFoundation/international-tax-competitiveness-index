# Property Tax Collections Source Data

#IMF Capital Stock Data

imf_capital_stock_data <- read_excel(paste(source_data,"imf_capital_stock_data.xlsx",sep=""), 
                                     sheet = "Dataset")

imf_capital_stock_data <- subset(imf_capital_stock_data,imf_capital_stock_data$year>2011)

imf_capital_stock_data <- subset(imf_capital_stock_data, imf_capital_stock_data$isocode%in%oecd_countries)
imf_capital_stock_data$capital_stock <- imf_capital_stock_data$kpriv_n
imf_capital_stock_data$capital_stock <- as.numeric(imf_capital_stock_data$capital_stock)
imf_capital_stock_data$capital_stock <- (imf_capital_stock_data$capital_stock)*1000

imf_capital_stock_data<-imf_capital_stock_data[c("isocode","country","year","capital_stock")]
colnames(imf_capital_stock_data)<-c("ISO_3","country","year","capital_stock")
ISO_OECD<-subset(iso_country_codes,iso_country_codes$ISO_3%in%oecd_countries)
ISO_2_OECD<-print(ISO_OECD$ISO_2)


#Roll the IMF capital stock forward from 2018 using annual Gross Fixed Capital
#Formation (current prices, national currency). The legacy IFS SDMX service
#(dataservices.imf.org) was retired by the IMF, so GFCF is pulled from the new
#IMF Data Portal SDMX 3.0 API: National Economic Accounts (NEA), Annual Data
#(dataflow IMF.STA/ANEA), indicator P51G "Gross fixed capital formation".
#Key dimensions: COUNTRY.INDICATOR.PRICE_TYPE(V=current).TYPE_OF_TRANSFORMATION(XDC=domestic currency).FREQUENCY(A)
gfcf_url <- paste0("https://api.imf.org/external/sdmx/3.0/data/dataflow/IMF.STA/ANEA/+/",
                   paste(oecd_countries, collapse = "+"), ".P51G.V.XDC.A")

gfcf_response <- GET(gfcf_url, add_headers(Accept = "application/vnd.sdmx.data+csv;version=2.0.0"))
stop_for_status(gfcf_response)

GFCF <- read.csv(text = content(gfcf_response, as = "text", encoding = "UTF-8"), stringsAsFactors = FALSE)
GFCF <- GFCF[c("COUNTRY","TIME_PERIOD","OBS_VALUE")]
colnames(GFCF) <- c("ISO_3","year","gross_fixed_capital_formation")

# ANEA values are in units of national currency; the IMF capital stock (kpriv_n*1000)
# and the legacy IFS GFCF were in millions, so rescale GFCF to millions.
GFCF$gross_fixed_capital_formation <- as.numeric(GFCF$gross_fixed_capital_formation)/1000000
GFCF <- subset(GFCF, GFCF$year>=2019 & GFCF$year<=2024)

# attach country name and ISO_2 (the roll-forward merges below are by "country")
GFCF <- merge(GFCF, iso_country_codes, by="ISO_3")

#Depreciate capital stock and add GFCF

#2019
capital_stock_19<-merge(subset(imf_capital_stock_data,imf_capital_stock_data$year==2018),subset(GFCF,GFCF$year==2019),by="country")
capital_stock_19$year<-"2019"
capital_stock_19$capital_stock<-(capital_stock_19$capital_stock*(1-.1077))+(capital_stock_19$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_19<-capital_stock_19[-c(2,3)]
capital_stock_19<-capital_stock_19[c("country","capital_stock","ISO_3.y","year.y")]
colnames(capital_stock_19)<-c("country","capital_stock","ISO_3","year")


#2020
capital_stock_20<-merge(capital_stock_19,subset(GFCF,GFCF$year==2020),by="country")
capital_stock_20$year<-"2020"
capital_stock_20$capital_stock<-(capital_stock_20$capital_stock*(1-.1077))+(capital_stock_20$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_20<-capital_stock_20[c("country","capital_stock","ISO_3.y","year")]
colnames(capital_stock_20)<-c("country","capital_stock","ISO_3","year")


#2021
capital_stock_21<-merge(capital_stock_20,subset(GFCF,GFCF$year==2021),by="country")
capital_stock_21$year<-"2021"
capital_stock_21$capital_stock<-(capital_stock_21$capital_stock*(1-.1077))+(capital_stock_21$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_21<-capital_stock_21[c("country","capital_stock","ISO_3.y","year")]
colnames(capital_stock_21)<-c("country","capital_stock","ISO_3","year")


#2022
capital_stock_22<-merge(capital_stock_21,subset(GFCF,GFCF$year==2022),by="country")
capital_stock_22$year<-"2022"
capital_stock_22$capital_stock<-(capital_stock_22$capital_stock*(1-.1077))+(capital_stock_22$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_22<-capital_stock_22[c("country","capital_stock","ISO_3.y","year")]
colnames(capital_stock_22)<-c("country","capital_stock","ISO_3","year")


#2023
capital_stock_23<-merge(capital_stock_22,subset(GFCF,GFCF$year==2023),by="country")
capital_stock_23$year<-"2023"
capital_stock_23$capital_stock<-(capital_stock_23$capital_stock*(1-.1077))+(capital_stock_23$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_23<-capital_stock_23[c("country","capital_stock","ISO_3.y","year")]
colnames(capital_stock_23)<-c("country","capital_stock","ISO_3","year")


#2024
capital_stock_24<-merge(capital_stock_23,subset(GFCF,GFCF$year==2024),by="country")
capital_stock_24$year<-"2024"
capital_stock_24$capital_stock<-(capital_stock_24$capital_stock*(1-.1077))+(capital_stock_24$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_24<-capital_stock_24[c("country","capital_stock","ISO_3.y","year")]
colnames(capital_stock_24)<-c("country","capital_stock","ISO_3","year")

#combine
imf_capital_stock_data<-subset(imf_capital_stock_data,imf_capital_stock_data$year<2019)

imf_capital_stock_data<-rbind(imf_capital_stock_data,capital_stock_19,capital_stock_20,capital_stock_21,capital_stock_22,capital_stock_23,capital_stock_24)

#property tax revenues####

property_tax_revenue <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD",
                                   "TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE..S13.T_4100..USD.A")
property_tax_revenue<-property_tax_revenue[c(8,12,7)]
colnames(property_tax_revenue) <- c("ISO_3","year","property_tax_collections")
property_tax_revenue<-property_tax_revenue[property_tax_revenue$year >=2012,]

#Missing country/years are simply prior year values.
#Drop rows the OECD has not yet populated (present but NA) so the hardcoded
#carry-forward values below are the ones used.
property_tax_revenue <- property_tax_revenue[!is.na(property_tax_revenue$property_tax_collections),]

#As of the 2026 update the OECD has not yet published 2024 recurrent property
#tax (T_4100) for Australia and Greece, so carry forward their 2023 values.
ISO_3 <- c("AUS","GRC")
year <- c("2024","2024")
property_tax_collections <- c("30.042699","3.405995")
missing <- data.frame(ISO_3,year,property_tax_collections)
property_tax_revenue <- rbind(property_tax_revenue,missing)

property_tax_revenue$property_tax_collections <- as.numeric(property_tax_revenue$property_tax_collections)
property_tax_revenue$property_tax_collections <- (property_tax_revenue$property_tax_collections)*1000

#Merge Property Tax Revenues data with Capital Stock Data
property_tax <- merge(property_tax_revenue, imf_capital_stock_data, by=c("ISO_3","year"))

property_tax$property_tax_collections <- (property_tax$property_tax_collections/property_tax$capital_stock)*100

property_tax <- property_tax[c("country","year","property_tax_collections","ISO_3")]
colnames(property_tax) <- c("country","year","property_tax_collections","ISO_3")
property_tax <- property_tax[c("ISO_3","country","year","property_tax_collections")]

write.csv(property_tax, file = paste(intermediate_outputs,"property_tax_data.csv",sep=""), row.names = FALSE)
