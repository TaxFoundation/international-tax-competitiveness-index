# capital allowance model

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clears all datasets and variables from memory
rm(list=ls())

using<-function(...,prompt=TRUE){
  libs<-sapply(substitute(list(...))[-1],deparse)
  req<-unlist(lapply(libs,require,character.only=TRUE))
  need<-libs[req==FALSE]
  n<-length(need)
  installAndRequire<-function(){
    install.packages(need)
    lapply(need,require,character.only=TRUE)
  }
  if(n>0){
    libsmsg<-if(n>2) paste(paste(need[1:(n-1)],collapse=", "),",",sep="") else need[1]
    if(n>1){
      libsmsg<-paste(libsmsg," and ", need[n],sep="")
    }
    libsmsg<-paste("The following packages count not be found: ",libsmsg,"n\r\n\rInstall missing packages?",collapse="")
    if(prompt==FALSE){
      installAndRequire()
    }else if(winDialog(type=c("yesno"),libsmsg)=="YES"){
      installAndRequire()
    }
  }
}

using(OECD)
using(plyr)
using(reshape2)
using(countrycode)
using(tidyverse)
using(readxl)

cbt<-read.csv("./data/CBT_tax_database_web_2019_all_ame.csv", header = TRUE, fill = TRUE, sep = ",")


# copy 2018 cbt data to 2019
year2019_preliminary<-cbt[cbt$year==2018,]
year2019_preliminary$year <- 2019
cbt <- rbind(cbt, year2019_preliminary)

# gdp data
gdp <- read.csv("./data/USDA_ERSInternationalMacroeconomicDataSet_GDP.csv", header = TRUE, fill = TRUE, sep = ",", fileEncoding = "UTF-8-BOM", check.names=FALSE)
gdp <- melt(gdp, id.vars = c("Country"))
gdp$Country <- countrycode(gdp$Country, 'country.name', 'iso3c')
names(gdp)[names(gdp) == 'Country'] <- 'country'
names(gdp)[names(gdp) == 'variable'] <- 'year'
names(gdp)[names(gdp) == 'value'] <- 'gdp'

#Alternative GDP source data 
#GDP Data cleaning
#Read in USDA data
USDA_Projected<- read_excel("./data/ProjectedRealGDPValues.xlsx", range = "A11:K232")
USDA_Projected<-USDA_Projected[,-c(2:8)]
USDA_Historical<-read_excel("./data/HistoricalRealGDPValues.xls", range = "A11:AL232")
gdp<-merge(USDA_Historical,USDA_Projected,by="Country")
colnames(gdp)[1]<-"Country"
gdp<-na.omit(gdp)
gdp <- subset(gdp, Country!="AsiaLessJapan" & Country!="EastAsiaLessJapan")

gdp <- melt(gdp, id.vars = c("Country"))
gdp$Country <- countrycode(gdp$Country, 'country.name', 'iso3c')
names(gdp)[names(gdp) == 'Country'] <- 'country'
names(gdp)[names(gdp) == 'variable'] <- 'year'
names(gdp)[names(gdp) == 'value'] <- 'gdp'
gdp<-na.omit(gdp)


# merge GDP with CBT tax data
data <- merge(cbt, gdp, by = c("country", "year"))

# drop non OECD countries
# Note: we dont have data on latvia
data <- data[which(data$country=="AUS" 
                   | data$country=="AUT"
                   | data$country=="BEL" 
                   | data$country=="CAN" 
                   | data$country=="CHL" 
                   | data$country=="CZE" 
                   | data$country=="DNK" 
                   | data$country=="EST" 
                   | data$country=="FIN" 
                   | data$country=="FRA"
                   | data$country=="DEU"
                   | data$country=="GRC"
                   | data$country=="HUN"
                   | data$country=="ISL"
                   | data$country=="IRL"
                   | data$country=="ISR"
                   | data$country=="ITA"
                   | data$country=="JPN"
                   | data$country=="KOR"
                   | data$country=="LVA"
                   | data$country=="LTU"
                   | data$country=="LUX"
                   | data$country=="MEX"
                   | data$country=="NLD"
                   | data$country=="NZL"
                   | data$country=="NOR"
                   | data$country=="POL"
                   | data$country=="PRT"
                   | data$country=="SVK"
                   | data$country=="SVN"
                   | data$country=="ESP"
                   | data$country=="SWE"
                   | data$country=="CHE"
                   | data$country=="TUR"
                   | data$country=="GBR"
                   | data$country=="USA"),]

#Defining OECD Countries
OECD_Countries<-c("AUS",
                  "AUT",
                  "BEL",
                  "CAN",
                  "CHL",
                  "CZE",
                  "DNK",
                  "EST",
                  "FIN",
                  "FRA",
                  "DEU",
                  "GRC",
                  "HUN",
                  "ISL",
                  "IRL",
                  "ISR",
                  "ITA",
                  "JPN",
                  "KOR",
                  "LUX",
                  "MEX",
                  "NLD",
                  "NZL",
                  "NOR",
                  "POL",
                  "PRT",
                  "SVK",
                  "SVN",
                  "ESP",
                  "SWE",
                  "CHE",
                  "TUR",
                  "GBR",
                  "USA",
                  "LVA",
                  "LTU")

#Defining OECD_Europe Countries
Europe_OECD_Countries<-c("AUT",
                     "BEL",
                     "BGR",
                     "CZE",
                     "HRV",
                     "DNK",
                     "EST",
                     "FIN",
                     "FRA",
                     "DEU",
                     "GRC",
                     "HUN",
                     "IRL",
                     "ISL",
                     "ITA",
                     "LVA",
                     "LTU",
                     "LUX",
                     "NLD",
                     "NOR",
                     "POL",
                     "PRT",
                     "ROU",
                     "SVK",
                     "SVN",
                     "ESP",
                     "SWE",
                     "CHE",
                     "TUR",
                     "GBR")

#Defining OECD_EU Countries
EU_OECD_Countries<-c("AUT",
                         "BEL",
                         "BGR",
                         "CZE",
                         "HRV",
                         "DNK",
                         "EST",
                         "FIN",
                         "FRA",
                         "DEU",
                         "GRC",
                         "HUN",
                         "IRL",
                         "ITA",
                         "LVA",
                         "LTU",
                         "LUX",
                         "NLD",
                         "POL",
                         "PRT",
                         "ROU",
                         "SVK",
                         "SVN",
                         "ESP",
                         "SWE",
                         "GBR")

#Gross fixed capital formation (GFCF)
#investment<-read.csv("investment.csv", header = TRUE, fill = TRUE, sep = ",")
#investment <- investment[c("country", "year", "investment")]
#data <- merge(data, investment, by = c("country", "year"))
#write.csv(data, file = "data2.csv")

SL<-function(rate,i){
  pdv<-((rate*(1+i))/i)*(1-(1^(1/rate)/(1+i)^(1/rate)))
  return(pdv)
}

SL2<-function(rate1,year1,rate2,year2,i){
  SL1 <- ((rate1*(1+i))/i)*(1-(1^year1)/(1+i)^year1)
  SL2 <- ((rate2*(1+i))/i)*(1-(1^year2)/(1+i)^year2) / (1+i)^year1
  pdv <-  SL1 + SL2
  return(pdv)
  
}

# SL3 is treated as SL2
SL3<-function(year1,rate1,year2,rate2,year3,rate3,i){
  pdv <- 0
  for (x in 0:(year1-1)){
    pdv <- pdv + (rate1 / ((1+i)^x))
  }
  for (x in year1:(year2-1)){
    pdv <- pdv + (rate2 / ((1+i)^x))
  }
  for (x in year2:(year3-1)){
    pdv <- pdv + (rate3 / ((1+i)^x))
  }
  return(pdv)
}


DB<-function(rate,i){
  pdv<- (rate*(1+i))/(i+rate)
  return(pdv)
}

initialDB<-function(rate1,rate2,i){
  pdv<- rate1 + ((rate2*(1+i))/(i+rate2)*(1-rate1))/(1+i)
  return(pdv)
}

DBSL1<-function(rate1,year1,rate2,year2,i){
  value <- 1
  DB <- 0
  SL <- 0
  for (x in 0:(year1-1)){
    DB <- DB + (rate1*(1-rate1)^x)/(1+i)^x
  }
  SL <- ((rate2*(1+i))/i)*(1-(1^(year2)/(1+i)^(year2)))/(1+i)^(year1)
  return(DB+SL)
}

DBSL2<-function(rate1,year1,rate2,year2,i){
  top<- (rate1+(rate2/((1+i)^year1))/year2 )*(1+i)
  bottom <- i + (rate1+(rate2/((1+i)^year1))/year2)
  return(top/bottom)
}

SLITA<-function(rate,year,i){
  pdv <- rate + (((rate*2)*(1+i))/i)*(1-(1^(2)/(1+i)^(2)))/(1+i) + ((rate*(1+i))/i)*(1-(1^(year-3)/(1+i)^(year-3)))/(1+i)^3
  return(pdv)
}

CZK<-function(rate,i){
  value<-1
  pdv <- 0
  years<-round(((1/rate)-1))
  for (x in 0:years){
    if (x == 0){
      pdv <- pdv + rate
      value <- value - rate
    } else {
      pdv<- pdv + (((value*2)/((1/rate)-x+1))/(1+i)^x)
      value <- value - ((value*2)/((1/rate)-x+1))
    }
  }
  return(pdv)
}

#debug summarys
summary(data)
summary(data$taxdepbuildtype)
summary(data$taxdepmachtype)
summary(data$taxdepintangibltype)

#Need to replace odd depreciation systems (SL3, DB DB SL)
#going to treat DB DB SL as DB with switch to SL
#Going to treat SL3 as SL2
data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")] <- as.data.frame(sapply(data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")], function(x) gsub("SL3", "SL2", x)))
data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")] <- as.data.frame(sapply(data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")], function(x) gsub("DB DB SL", "initialDB", x)))

#Ireland's machine schedules are messed up. I assume that these are the fixes:
data[c('taxdepmachtimedb')][data$country == "IRL" & data$year >=1988 & data$year<=1991,]<-1

#The coding of the 3-schedule Straightline ACRS for Machines is wrong
#Since this model does not support 3-schedule, it is assumed to be a 2 schedule
data[c('taxdepmachtimesl')][data$country == "USA" & data$year >1980 & data$year<1987,]<-4


#data[c('taxdeprbuildtimesl')][data$country == "USA" & data$year == 2018,] <- 40
#data[c('taxdeprbuildsl')][data$country == "USA" & data$year == 2018,] <- 0.025


#calculate capital cost allowances

#machines
#DB
data$machines[data$taxdepmachtype == "DB" & !is.na(data$taxdepmachtype)]<-DB(data$taxdeprmachdb[data$taxdepmachtype == "DB" & !is.na(data$taxdepmachtype)],0.075)
#SL
data$machines[data$taxdepmachtype == "SL" & !is.na(data$taxdepmachtype)]<-SL(data$taxdeprmachsl[data$taxdepmachtype == "SL" & !is.na(data$taxdepmachtype)],0.075)
#initialDB
data$machines[data$taxdepmachtype == "initialDB" & !is.na(data$taxdepmachtype)]<-initialDB(data$taxdeprmachdb[data$taxdepmachtype == "initialDB" & !is.na(data$taxdepmachtype)],
  data$taxdeprmachsl[data$taxdepmachtype == "initialDB" & !is.na(data$taxdepmachtype)], 0.075)
#DB or SL
data$machines[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepintangibltype)]<-DBSL2(data$taxdeprmachdb[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)],
  data$taxdepmachtimedb[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)],
  data$taxdeprmachsl[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)],
  data$taxdepmachtimesl[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)], 0.075)
#SL2
data$machines[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)]<-SL2(data$taxdeprmachdb[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)],
  data$taxdepmachtimedb[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)],
  data$taxdeprmachsl[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)],
  data$taxdepmachtimesl[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)], 0.075)
#SLITA
data$machines[data$taxdepmachtype == "SLITA" & !is.na(data$taxdepmachtype)]<-SL(data$taxdeprmachsl[data$taxdepmachtype == "SLITA" & !is.na(data$taxdepmachtype)],0.075)
#CZK
for (x in 1:length(data$taxdeprmachdb)){
  if(grepl("CZK",data$taxdepmachtype[x]) == TRUE){
    data$machines[x]<-CZK(data$taxdeprmachdb[x], 0.075)
  }
}

#buildings
#DB
data$buildings[data$taxdepbuildtype == "DB" & !is.na(data$taxdepbuildtype)]<-DB(data$taxdeprbuilddb[data$taxdepbuildtype == "DB" & !is.na(data$taxdepbuildtype)],0.075)
#SL
data$buildings[data$taxdepbuildtype == "SL" & !is.na(data$taxdepbuildtype)]<-SL(data$taxdeprbuildsl[data$taxdepbuildtype == "SL" & !is.na(data$taxdepbuildtype)],0.075)
#initialDB
data$buildings[data$taxdepbuildtype == "initialDB" & !is.na(data$taxdepbuildtype)]<-initialDB(data$taxdeprbuilddb[data$taxdepbuildtype == "initialDB" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildsl[data$taxdepbuildtype == "initialDB" & !is.na(data$taxdepbuildtype)], 0.075)
#DB or SL
data$buildings[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)]<-DBSL2(data$taxdeprbuilddb[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildtimedb[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildsl[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildtimesl[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)], 0.075)
#SL2
data$buildings[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)]<-SL2(data$taxdeprbuilddb[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildtimedb[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildsl[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)],
  data$taxdeprbuildtimesl[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)], 0.075)
#SLITA
data$buildings[data$taxdepbuildtype == "SLITA" & !is.na(data$taxdepbuildtype)]<-SL(data$taxdeprbuildsl[data$taxdepbuildtype == "SLITA" & !is.na(data$taxdepbuildtype)],0.075)
#CZK
for (x in 1:length(data$taxdeprbuilddb)){
  if(grepl("CZK",data$taxdepbuildtype[x]) == TRUE){
    data$buildings[x]<-CZK(data$taxdeprbuilddb[x], 0.075)
  }
}

#intangibles
#DB
data$intangibles[data$taxdepintangibltype == "DB" & !is.na(data$taxdepintangibltype)]<-DB(data$taxdeprintangibldb[data$taxdepintangibltype == "DB" & !is.na(data$taxdepintangibltype)], 0.075)
#SL
data$intangibles[data$taxdepintangibltype == "SL" & !is.na(data$taxdepintangibltype)]<-SL(data$taxdeprintangiblsl[data$taxdepintangibltype == "SL" & !is.na(data$taxdepintangibltype)], 0.075)
#initialDB
data$intangibles[data$taxdepintangibltype == "initialDB" & !is.na(data$taxdepintangibltype)]<-initialDB(data$taxdeprintangibldb[data$taxdepintangibltype == "initialDB" & !is.na(data$taxdepintangibltype)],
  data$taxdeprintangiblsl[data$taxdepintangibltype == "initialDB" & !is.na(data$taxdepintangibltype)], 0.075)
#DB or SL
data$intangibles[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)]<-DBSL2(data$taxdeprintangibldb[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)],
  data$taxdepintangibltimedb[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)],
  data$taxdeprintangiblsl[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)],
  data$taxdepintangibltimesl[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)], 0.075)

#In 2000, Estonia moved to a cash-flow type business tax. All allowances need to be coded as 1
data[c('intangibles','machines','buildings')][data$country == "EST" & data$year >=2000,]<-1

#Latvia too as of 2018 :)
data[c('intangibles','machines','buildings')][data$country == "LVA" & data$year >=2018,]<-1

#In fall 2018, Canada introduced full expensing for machinery
data[c('machines')][data$country == "CAN" & data$year >2018,]<-1

# fix USA data to include bonus dep for machines
data[c('machines')][data$country == "USA" & data$year == 2002,] <- (data[c('machines')][data$country == "USA" & data$year == 2002,] * 0.70) + 0.30
data[c('machines')][data$country == "USA" & data$year == 2003,] <- (data[c('machines')][data$country == "USA" & data$year == 2003,] * 0.70) + 0.30
data[c('machines')][data$country == "USA" & data$year == 2004,] <- (data[c('machines')][data$country == "USA" & data$year == 2004,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2008,] <- (data[c('machines')][data$country == "USA" & data$year == 2008,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2009,] <- (data[c('machines')][data$country == "USA" & data$year == 2009,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2010,] <- (data[c('machines')][data$country == "USA" & data$year == 2010,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2011,] <- (data[c('machines')][data$country == "USA" & data$year == 2011,] * 0.00) + 1.00
data[c('machines')][data$country == "USA" & data$year == 2012,] <- (data[c('machines')][data$country == "USA" & data$year == 2012,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2013,] <- (data[c('machines')][data$country == "USA" & data$year == 2013,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2014,] <- (data[c('machines')][data$country == "USA" & data$year == 2014,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2015,] <- (data[c('machines')][data$country == "USA" & data$year == 2015,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2016,] <- (data[c('machines')][data$country == "USA" & data$year == 2016,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2017,] <- (data[c('machines')][data$country == "USA" & data$year == 2017,] * 0.50) + 0.50
data[c('machines')][data$country == "USA" & data$year == 2018,] <- (data[c('machines')][data$country == "USA" & data$year == 2018,] * 0.00) + 1.00
data[c('machines')][data$country == "USA" & data$year == 2019,] <- (data[c('machines')][data$country == "USA" & data$year == 2019,] * 0.00) + 1.00


# fix corp rates
data[c('total')][data$country == "USA" & data$year == 2018,] <- 0.258
data[c('total')][data$country == "USA" & data$year == 2019,] <- 0.258

data[c('total')][data$country == "ISR" & data$year == 2017,] <- 0.24
data[c('total')][data$country == "ISR" & data$year == 2018,] <- 0.23
data[c('total')][data$country == "ISR" & data$year == 2019,] <- 0.23

data[c('total')][data$country == "JPN" & data$year == 2018,] <- 0.297
data[c('total')][data$country == "JPN" & data$year == 2019,] <- 0.297

data[c('total')][data$country == "KOR" & data$year == 2018,] <- 0.25
data[c('total')][data$country == "KOR" & data$year == 2019,] <- 0.275

data[c('total')][data$country == "NOR" & data$year == 2018,] <- 0.23
data[c('total')][data$country == "NOR" & data$year == 2019,] <- 0.23

data[c('total')][data$country == "TUR" & data$year == 2018,] <- 0.22
data[c('total')][data$country == "TUR" & data$year == 2019,] <- 0.22

data[c('total')][data$country == "BEL" & data$year == 2018,] <- 0.296
data[c('total')][data$country == "BEL" & data$year == 2019,] <- 0.296

data[c('total')][data$country == "LVA" & data$year == 2018,] <- 0.2
data[c('total')][data$country == "LVA" & data$year == 2019,] <- 0.2

#write.csv(data, file = "prelim_data.csv")

#coplot
coplot(machines ~ year|country, type="l", data=data)
coplot(buildings ~ year|country, type="l", data=data)
coplot(intangibles ~ year|country, type="l", data=data)

#Counting missing values
ddply(data,
  .(year),
  summarize,
  sum(is.na(machines)),
  sum(is.na(buildings)),
  sum(is.na(intangibles))
)

#Mean imputation for missing values
for (i in 1983:2019){
  data$machines[is.na(data$machines) & data$year == i] <- mean(data$machines[data$year == i], na.rm = TRUE)
  data$buildings[is.na(data$buildings) & data$year == i] <- mean(data$buildings[data$year == i], na.rm = TRUE)
  data$intangibles[is.na(data$intangibles) & data$year == i] <- mean(data$intangibles[data$year == i], na.rm = TRUE)
}

#Counting missing values after imputation
ddply(data,
  .(year),
  summarize,
  sum(is.na(machines)),
  sum(is.na(buildings)),
  sum(is.na(intangibles))
)

#write.csv(data, file = "prelim_data_with_missing.csv")

#Average Cost Recovery (weighted by capital stock); sourced to Devereux in 2012
data$weighted_machines<-data$machines*.4391081
data$weighted_buildings<-data$buildings*.4116638
data$weighted_intangibles<-data$intangibles*.1492281

data$waverage<-rowSums(data[,c("weighted_machines","weighted_buildings","weighted_intangibles")])
data$average<-rowMeans(data[,c("machines","buildings","intangibles")])

#write.csv(data, file = "prelim_data_averages.csv")

#year.2016<-data[data$year==2016,]
#year.2012<-data[data$year==2012,]
year.2019<-data[data$year==2019,]
year.2017<-data[data$year==2017,]

#write.csv(year.2017, file = "capallow_data_2017.csv")

#country.USA<-data[data$country=="USA",]
#country.AUT<-data[data$country=="AUT",]
#country.ISR<-data[data$country=="ISR",]
#country.JPN<-data[data$country=="JPN",]
#country.GBR<-data[data$country=="GBR",]

#write.csv(year.2016, file = "prelim_data_2016.csv")

#data.noUSA<-data[data$country!="USA",]


timeseries<-ddply(data, 
  .(year),
  summarize,
  averagerate = mean(total, na.rm = TRUE),
  waveragerate = weighted.mean(total,gdp, na.rm = TRUE),
  averagecostrecovery = mean(waverage, na.rm = TRUE),
  waveragecostrecovery = weighted.mean(waverage, gdp, na.rm = TRUE),
  waveragemachines = mean(weighted_machines, na.rm = TRUE),
  waveragebuildings = mean(weighted_buildings, na.rm = TRUE),
  waverageintangibles = mean(weighted_intangibles, na.rm = TRUE),
  machines = mean(machines, na.rm = TRUE),
  buildings = mean(buildings, na.rm = TRUE),
  intangibles = mean(intangibles, na.rm = TRUE)
)

timeseries<-timeseries[timeseries$year>1982,]

#OECD Average and Weighted Average Capital Allowances
plot(timeseries$year,timeseries$waveragecostrecovery, 
  type ="o",
  ylim = c(0.5, 0.8),
  xlim = c(1983,2019),
  col = "green", 
  ylab = "Present Discounted Value", 
  xlab = "Year")
lines(timeseries$year,timeseries$averagecostrecovery, type ="o", col = "red")
legend(1985, y=0.6, legend=c("OECD Simple Average", "OECD Average Weighted by GDP"), col=c("red", "green"), lty=1:2, cex=0.8)
#lines(country.USA$year,country.USA$waverage, type ="o", col = "blue")
#lines(country.ISR$year,country.ISR$waverage, type ="o", col = "black")
#lines(country.JPN$year,country.JPN$waverage, type ="o", col = "blue")
#lines(country.GBR$year,country.GBR$waverage, type ="o", col = "blue")
title("Present Discounted Value \nof Cost Recovery in the OECD, 1983-2019")

timeseries_average<-timeseries[c(1,4,5)]
write.csv(timeseries_average, file = "PDV83-19_Dan.csv")

#OECD Weighted Capital Allowances by Asset Category
plot(timeseries$year,timeseries$machines, 
     type ="o",
     ylim = c(0.4, 1),
     xlim = c(1983,2019),
     col = "green", 
     ylab = "Present Discounted Value", 
     xlab = "Year"                   )
lines(timeseries$year,timeseries$buildings, type ="o", col = "red")
lines(timeseries$year,timeseries$intangibles, type ="o", col = "blue")
legend(2010, y=0.7, legend=c("Machinery", "Buildings","Intangibles"), col=c("green", "red", "blue"), lty=1:2, cex=0.8)
title("Present Discounted Value of Cost Recovery \nin the OECD by Asset Category, 1983-2019")

#EU Countries and CCCTB
CCCTB<-read_xlsx("./data/CCCTB_and_EU.xlsx")
CCCTB<-CCCTB[,c(1,9)]
CCCTB<-subset(CCCTB, CCCTB$country!="CCTB" & CCCTB$country!="CHE" & CCCTB$country!="TUR" & CCCTB$country!="NOR" & CCCTB$country!="ISL")
CCCTB<-CCCTB[
  with(CCCTB, order(-waverage)),
  ]
write.csv(CCCTB,"CCCTB_EU_Bar_Graph_Data.csv")

barplot(CCCTB$waverage,
        ylim = c(0, 1),
        ylab = "Present Discounted Value",
        names.arg = c(CCCTB$country),
        las=2)
abline(h=0.673233)
title("Present Discounted Value of \nWeighted Capital Allowances in the EU")


#Corporate Income Tax Rate
plot(timeseries$year,timeseries$averagerate,
     type ="o",
     ylim = c(0.0, .55),
     xlim = c(1983,2019),
     col = "green", 
     ylab = "Corporate Rate", 
     xlab = " ")
lines(timeseries$year,timeseries$waveragerate, type ="o", col = "purple")
#lines(country.USA$year,country.USA$total, type ="o", col = "red")
#lines(country.AUT$year,country.AUT$total, type ="o", col = "blue")
#lines(country.GBR$year,country.GBR$total, type ="o", col = "red")
legend(1985, y=0.25, legend=c("OECD Average Weighted by GDP", "OECD Simple Average"), col=c("purple", "green"), lty=1:2, cex=0.8)
title("Corporate Income Tax Rates in the OECD, 1983-2019")

timeseries_CIT<-timeseries[c(1,2,3)]
write.csv(timeseries_CIT, file = "CIT83-19_Dan.csv")

#Corporate Effective Average vs. Effective Marginal tax rate in OECD Countries
#dataset_list<-get_datasets()
#search<-search_dataset("effective", data= dataset_list)
#dataset<-("CTS_ETR")
#dstruc<-get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$INDIC

#ETR<-get_dataset("CTS_ETR",filter= list(c(OECD_Countries)))
#ETR<-subset(ETR, ETR$INDIC=="COMPOSITE_EATR" | ETR$INDIC=="COMPOSITE_EMTR") 
#ETR<-subset(ETR, ETR$SCE=="LOW")
#ETR<-ETR[,c(1,3,6)]

#colnames(ETR)<-c("ISO3","EATR_EMTR", "Value")

#ggplot(ETR, aes(x=ISO3, y=Value, fill=factor(EATR_EMTR), las=2)) +
#      geom_bar(stat="identity", position = "dodge") + 
#theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
#labs(
#  x = " ",
#  y = "Tax Rate (in %)",
#  labs(fill = " ")) +
#  scale_fill_discrete(name = "", labels = c(" Effective Average \n Tax Rate", " Effective Marginal \n Tax Rate")) +
#  ggtitle("Effective Average vs. Effective Marginal Corporate Tax Rates") +
#  theme(plot.title = element_text(hjust = 0.5)) +
#  theme(legend.position = c(0.8, 0.25),
#        legend.title=element_blank())


#plot(country.GBR$year,country.GBR$waverage,
#     type ="o",
#     ylim = c(0, 1),
#     xlim = c(1987,2016),
#     col = "green", 
#     ylab = "Percent", 
#     xlab = "Year")
#lines(country.GBR$year,country.GBR$total, type ="o", col = "red")
#title("Corporate Income Tax Rate & Average Capital Alowance, UK, 1983-2016")

#Create table by asset types (including weighted average) and add rankings
year.2019.rank<-year.2019[,c(1,2,24,25,26,30)]
year.2019.rank$machines.rank<- rank(-year.2019.rank$`machines`,ties.method = "min")
year.2019.rank$buildings.rank<- rank(-year.2019.rank$`buildings`,ties.method = "min")
year.2019.rank$intangibles.rank<- rank(-year.2019.rank$`intangibles`,ties.method = "min")
year.2019.rank$waverage.rank<- rank(-year.2019.rank$`waverage`,ties.method = "min")

country.code<-read_xlsx("./data/ISO Country Codes.xlsx")
colnames(country.code)<-c("country","ISO-2","ISO-3")
colnames(year.2019.rank)[colnames(year.2019.rank)=="country"] <- "ISO-3"
year.2019.rank<-merge(year.2019.rank,country.code,by=c("ISO-3"))
year.2019.rank<-year.2019.rank[,-c(1,2,12)]
year.2019.rank<-year.2019.rank[c(9,8,4,5,1,6,2,7,3)]
year.2019.rank<-year.2019.rank[
  with(year.2019.rank, order(waverage.rank)),
  ]
year.2019.rank$waverage<-round(year.2019.rank$waverage, digits=3)
year.2019.rank$machines<-round(year.2019.rank$machines, digits=3)
year.2019.rank$buildings<-round(year.2019.rank$buildings, digits=3)
year.2019.rank$intangibles<-round(year.2019.rank$intangibles, digits=3)


#Create data for Europe map of capital allowances
Cap_Allow_Map<-read_xlsx("./data/CCCTB_and_EU.xlsx")

colnames(Cap_Allow_Map)[colnames(Cap_Allow_Map)=="country"] <- "ISO-3"

Cap_Allow_Map<-merge(Cap_Allow_Map,country.code,by=c("ISO-3"))
Cap_Allow_Map<-Cap_Allow_Map[,c(1,9,12)]
Cap_Allow_Map<-Cap_Allow_Map[,c(3,1,2)]

Cap_Allow_Map$waverage<-round(Cap_Allow_Map$waverage, digits=3)
Cap_Allow_Map$rank<- rank(-Cap_Allow_Map$`waverage`,ties.method = "min")

Cap_Allow_Map$EU_yesno <- "yes"
Cap_Allow_Map$EU_yesno <-ifelse(Cap_Allow_Map$`ISO-3` %in% EU_OECD_Countries, Cap_Allow_Map$EU_yesno=="yes", Cap_Allow_Map$EU_yesno=="no")
Cap_Allow_Map$EU_yesno<-ifelse(Cap_Allow_Map$EU_yesno==FALSE, "no", "yes")



write.csv(timeseries, file = "FINAL_timeseries.csv")
write.csv(country.USA, file = "FINAL_USA.csv")
write.csv(country.AUT, file = "FINAL_AUT.csv")
#write.csv(country.JPN, file = "FINAL_JPN.csv")
#write.csv(country.GBR, file = "FINAL_GBR.csv")
write.csv(year.2019, file = "FINAL_2019.csv")
write.csv(year.2019.rank, file = "Ranking_2019.csv")
write.csv(Cap_Allow_Map, file = "Capital Allowances_Europe Map.csv")


### Checking for correlation between GDP and Weighted Allowances (to check whether smaller countries treat capital allowances better than larger countries)
#gdp_corr = year.2019$gdp
#allowance_corr = year.2019$waverage
#cor(gdp_corr, allowance_corr)