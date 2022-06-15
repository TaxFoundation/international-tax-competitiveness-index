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


#The following section is only needed when there is no recent update of the IMF's "Investment and Capital Stock Database" (https://infrastructuregovern.imf.org/content/PIMA/Home/Knowledge-Hub/Publications.html#Data) 
#IFS.available.codes <- DataStructureMethod("IFS")
#CodeSearch(IFS.available.codes,"CL_INDICATOR_IFS", "Formation")

databaseID <- "IFS"
checkquery = FALSE

# All OECD Countries Gross Fixed Capital Formation Millions in National Currency
queryfilter <- list(CL_FREQ="A", CL_AREA_IFS=ISO_2_OECD, CL_INDICATOR_IFS =c("NFI_XDC"))
GFCF_2019 <- data.frame(CompactDataMethod(databaseID, queryfilter, startdate= "2019-01-01", enddate = "2019-12-31",
                                  checkquery))
GFCF_2019<- GFCF_2019[-c(1,3:5)]
GFCF_2019<-data.frame(GFCF_2019$X.REF_AREA,GFCF_2019$Obs)
colnames(GFCF_2019)<-c("ISO_2","year","gross_fixed_capital_formation")


GFCF_2020 <- data.frame(CompactDataMethod(databaseID, queryfilter, startdate= "2020-01-01", enddate = "2020-12-31",
                                          checkquery))
GFCF_2020<- GFCF_2020[-c(1,3:5)]
GFCF_2020<-data.frame(GFCF_2020$X.REF_AREA,GFCF_2020$Obs)
colnames(GFCF_2020)<-c("ISO_2","year","gross_fixed_capital_formation")

GFCF<-rbind(GFCF_2019,GFCF_2020)
GFCF<-merge(GFCF,iso_country_codes,by="ISO_2")
GFCF$gross_fixed_capital_formation<-as.numeric(GFCF$gross_fixed_capital_formation)

#Depreciate capital stock and add GFCF

#2019
capital_stock_19<-merge(subset(imf_capital_stock_data,imf_capital_stock_data$year==2018),subset(GFCF,GFCF$year==2019),by="country")
capital_stock_19$year<-"2019"
capital_stock_19$capital_stock<-(capital_stock_19$capital_stock*(1-.1077))+(capital_stock_19$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_19<-capital_stock_19[-c(2,3)]
names(capital_stock_19)
capital_stock_19<-capital_stock_19[c("country","capital_stock","ISO_2","ISO_3.y","year.y")]
colnames(capital_stock_19)<-c("country","capital_stock","ISO_2","ISO_3","year")


#2020
capital_stock_20<-merge(capital_stock_19,subset(GFCF,GFCF$year==2020),by="country")
capital_stock_20$year<-"2020"
capital_stock_20$capital_stock<-(capital_stock_20$capital_stock*(1-.1077))+(capital_stock_20$gross_fixed_capital_formation*(1-(.1077/2)))
capital_stock_20<-capital_stock_20[c("country","capital_stock","ISO_2.x","ISO_3.y","year")]
colnames(capital_stock_20)<-c("country","capital_stock","ISO_2","ISO_3","year")


#property tax revenues####
#Table_II1#
dataset_list <- get_datasets()
#search_dataset("revenues", dataset_list)

#dataset<-("REV")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$TAX
#dstruc$TRANSACT
#dstruc$GOV

property_tax_revenue <- get_dataset("REV",filter=list(c("NES"),c("4100"),c("TAXNAT"),c(oecd_countries)), start_time = 2012)
property_tax_revenue <- property_tax_revenue[c("COU","Time","ObsValue")]
colnames(property_tax_revenue) <- c("isocode","year","property_tax_collections")

#Missing country/years are simply prior year values
isocode <- c("AUS","GRC","MEX")
year <- c("2019","2019","2019")
property_tax_collections <- c("32.694","3.594","49.444688")
missing <- data.frame(isocode,year,property_tax_collections)
property_tax_revenue <- rbind(property_tax_revenue,missing)

property_tax_revenue$property_tax_collections <- as.numeric(property_tax_revenue$property_tax_collections)
property_tax_revenue$property_tax_collections <- (property_tax_revenue$property_tax_collections)*1000

#Merge Property Tax Revenues data with Capital Stock Data
property_tax <- merge(property_tax_revenue, imf_capital_stock_data, by=c("isocode","year"))

property_tax$property_tax_collections <- (property_tax$property_tax_collections/property_tax$capital_stock)*100

property_tax <- property_tax[c("country","year","property_tax_collections","isocode")]
colnames(property_tax) <- c("country","year","property_tax_collections","ISO_3")
property_tax <- property_tax[c("ISO_3","country","year","property_tax_collections")]

write.csv(property_tax, file = paste(intermediate_outputs,"property_tax_data.csv",sep=""), row.names = FALSE)
