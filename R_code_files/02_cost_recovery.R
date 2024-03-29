# Cost recovery variables model

#Read in dataset containing depreciation data####
data <- read_csv(paste(source_data, "cost_recovery_data.csv", sep=""))

#Limit countries to OECD and EU countries
data <- data[which(data$country=="AUS" 
                   | data$country=="AUT"
                   | data$country=="BEL"
                   | data$country=="BGR"
                   | data$country=="CAN" 
                   | data$country=="CHL"
                   | data$country=="COL"
                   | data$country=="CRI"
                   | data$country=="HRV" 
                   | data$country=="CYP"
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
                   | data$country=="MLT" 
                   | data$country=="MEX"
                   | data$country=="NLD"
                   | data$country=="NZL"
                   | data$country=="NOR"
                   | data$country=="POL"
                   | data$country=="PRT"
                   | data$country=="ROU" 
                   | data$country=="SVK"
                   | data$country=="SVN"
                   | data$country=="ESP"
                   | data$country=="SWE"
                   | data$country=="CHE"
                   | data$country=="TUR"
                   | data$country=="GBR"
                   | data$country=="USA"),]


#Drop columns that are not needed
data <- subset(data, select = -c(inventoryval, total, statutory_corptax, EATR, EMTR))


#Define functions for present discounted value calculations#

#Straight-line method (SL)
SL <- function(rate,i){
  pdv <- ((rate*(1+i))/i)*(1-(1^(1/rate)/(1+i)^(1/rate)))
  return(pdv)
}

#Straight-line method with a one-time change in the depreciation rate (SL2)
SL2 <- function(rate1,year1,rate2,year2,i){
  SL1 <- ((rate1*(1+i))/i)*(1-(1^year1)/(1+i)^year1)
  SL2 <- ((rate2*(1+i))/i)*(1-(1^year2)/(1+i)^year2) / (1+i)^year1
  pdv <-  SL1 + SL2
  return(pdv)
}

#Straight-line method with two changes in the depreciation rate (SL3) (SL3 will be treated like SL2 - see Italy)
SL3 <- function(year1,rate1,year2,rate2,year3,rate3,i){
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

#Declining-balance method (DB)
DB <- function(rate,i){
  pdv<- (rate*(1+i))/(i+rate)
  return(pdv)
}

#Declining-balance method with an initial allowance (initialDB)
initialDB <- function(rate1,rate2,i){
  pdv <- rate1 + ((rate2*(1+i))/(i+rate2)*(1-rate1))/(1+i)
  return(pdv)
}

#Declining-balance method with switch to straight-line method (DB or SL)
DBSL2 <- function(rate1,year1,rate2,year2,i){
  top <- (rate1+(rate2/((1+i)^year1))/year2 )*(1+i)
  bottom <- i + (rate1+(rate2/((1+i)^year1))/year2)
  return(top/bottom)
}

#Italy's straight-line method for the years 1998-2007 for buildings and machinery (SLITA)
SLITA <- function(rate,year,i){
  pdv <- rate + (((rate*2)*(1+i))/i)*(1-(1^(2)/(1+i)^(2)))/(1+i) + ((rate*(1+i))/i)*(1-(1^(year-3)/(1+i)^(year-3)))/(1+i)^3
  return(pdv)
}

#Special depreciation method used in the Czech Republic and Slovakia (CZK)
CZK <- function(rate,i){
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

#Declining-balance and straight-line method (NOT USED)
#DBSL1 <- function(rate1,year1,rate2,year2,i){
#  value <- 1
#  DB <- 0
#  SL <- 0
#  for (x in 0:(year1-1)){
#    DB <- DB + (rate1*(1-rate1)^x)/(1+i)^x
#  }
#  SL <- ((rate2*(1+i))/i)*(1-(1^(year2)/(1+i)^(year2)))/(1+i)^(year1)
#  return(DB+SL)
#}


#Debug summarys#
summary(data)
summary(data$taxdepbuildtype)
summary(data$taxdepmachtype)
summary(data$taxdepintangibltype)


#Replace odd depreciation systems ("SL3" and "DB DB SL")####

#Treat SL3 as SL2
data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")] <- as.data.frame(sapply(data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")], function(x) gsub("SL3", "SL2", x)))

#Treat "DB DB SL" as initialDB ("DB DB SL" -> "initialDB")
data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")] <- as.data.frame(sapply(data[c("taxdepbuildtype", "taxdepmachtype", "taxdepintangibltype")], function(x) gsub("DB DB SL", "initialDB", x)))


#Corrections to the dataset#

#Ireland's machine schedules are messed up for the years 1988-1991 (they are way too high). We assume that this is the fix:
data[c('taxdepmachtimedb')][data$country == "IRL" & data$year >= 1988 & data$year <= 1991,] <- 1

#The US' 3-schedule straight-line ACRS for machinery is coded incorrectly for the years 1983-1986 (since this model does not support SL3 it is assumed to be SL2)
data[c('taxdepmachtimesl')][data$country == "USA" & data$year >1982 & data$year<1987,] <- 4


#Calculate net present values for the different asset types####

#machines_cost_recovery####

#Initialize new column
data$machines_cost_recovery <- NA

#DB
data$machines_cost_recovery[data$taxdepmachtype == "DB" & !is.na(data$taxdepmachtype)] <- DB(data$taxdeprmachdb[data$taxdepmachtype == "DB" & !is.na(data$taxdepmachtype)],0.075)
data$machines_cost_recovery[data$taxdepmachtype == "DB" & !is.na(data$taxdepmachtype)] <- DB(data$taxdeprmachdb[data$taxdepmachtype == "DB" & !is.na(data$taxdepmachtype)],0.075)

#SL
data$machines_cost_recovery[data$taxdepmachtype == "SL" & !is.na(data$taxdepmachtype)] <- SL(data$taxdeprmachsl[data$taxdepmachtype == "SL" & !is.na(data$taxdepmachtype)],0.075)

#initialDB
data$machines_cost_recovery[data$taxdepmachtype == "initialDB" & !is.na(data$taxdepmachtype)] <- initialDB(data$taxdeprmachdb[data$taxdepmachtype == "initialDB" & !is.na(data$taxdepmachtype)],
                                                                                                           data$taxdeprmachsl[data$taxdepmachtype == "initialDB" & !is.na(data$taxdepmachtype)], 0.075)

#DB or SL
data$machines_cost_recovery[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)] <- DBSL2(data$taxdeprmachdb[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)],
                                                                                                      data$taxdepmachtimedb[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)],
                                                                                                      data$taxdeprmachsl[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)],
                                                                                                      data$taxdepmachtimesl[data$taxdepmachtype == "DB or SL" & !is.na(data$taxdepmachtype)], 0.075)

#SL2
data$machines_cost_recovery[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)] <- SL2(data$taxdeprmachdb[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)],
                                                                                               data$taxdepmachtimedb[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)],
                                                                                               data$taxdeprmachsl[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)],
                                                                                               data$taxdepmachtimesl[data$taxdepmachtype == "SL2" & !is.na(data$taxdepmachtype)], 0.075)

#SLITA
data$machines_cost_recovery[data$taxdepmachtype == "SLITA" & !is.na(data$taxdepmachtype)] <- SL(data$taxdeprmachsl[data$taxdepmachtype == "SLITA" & !is.na(data$taxdepmachtype)],0.075)

#CZK
for (x in 1:length(data$taxdeprmachdb)){
  if(grepl("CZK",data$taxdepmachtype[x]) == TRUE){
    data$machines_cost_recovery[x] <- CZK(data$taxdeprmachdb[x], 0.075)
  }
}


#buildings_cost_recovery####

#Initialize new column
data$buildings_cost_recovery <- NA

#DB
data$buildings_cost_recovery[data$taxdepbuildtype == "DB" & !is.na(data$taxdepbuildtype)] <- DB(data$taxdeprbuilddb[data$taxdepbuildtype == "DB" & !is.na(data$taxdepbuildtype)],0.075)
data$buildings_cost_recovery[data$taxdepbuildtype == "DB" & !is.na(data$taxdepbuildtype)] <- DB(data$taxdeprbuilddb[data$taxdepbuildtype == "DB" & !is.na(data$taxdepbuildtype)],0.075)

#SL
data$buildings_cost_recovery[data$taxdepbuildtype == "SL" & !is.na(data$taxdepbuildtype)] <- SL(data$taxdeprbuildsl[data$taxdepbuildtype == "SL" & !is.na(data$taxdepbuildtype)],0.075)

#initialDB
data$buildings_cost_recovery[data$taxdepbuildtype == "initialDB" & !is.na(data$taxdepbuildtype)] <- initialDB(data$taxdeprbuilddb[data$taxdepbuildtype == "initialDB" & !is.na(data$taxdepbuildtype)],
                                                                                                              data$taxdeprbuildsl[data$taxdepbuildtype == "initialDB" & !is.na(data$taxdepbuildtype)], 0.075)

#DB or SL
data$buildings_cost_recovery[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)] <- DBSL2(data$taxdeprbuilddb[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)],
                                                                                                         data$taxdeprbuildtimedb[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)],
                                                                                                         data$taxdeprbuildsl[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)],
                                                                                                         data$taxdeprbuildtimesl[data$taxdepbuildtype == "DB or SL" & !is.na(data$taxdepbuildtype)], 0.075)

#SL2
data$buildings_cost_recovery[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)] <- SL2(data$taxdeprbuilddb[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)],
                                                                                                  data$taxdeprbuildtimedb[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)],
                                                                                                  data$taxdeprbuildsl[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)],
                                                                                                  data$taxdeprbuildtimesl[data$taxdepbuildtype == "SL2" & !is.na(data$taxdepbuildtype)], 0.075)

#SLITA
data$buildings_cost_recovery[data$taxdepbuildtype == "SLITA" & !is.na(data$taxdepbuildtype)]<-SL(data$taxdeprbuildsl[data$taxdepbuildtype == "SLITA" & !is.na(data$taxdepbuildtype)],0.075)

#CZK
for (x in 1:length(data$taxdeprbuilddb)){
  if(grepl("CZK",data$taxdepbuildtype[x]) == TRUE){
    data$buildings_cost_recovery[x] <- CZK(data$taxdeprbuilddb[x], 0.075)
  }
}


#intangibles_cost_recovery####

#Initialize new column
data$intangibles_cost_recovery <- NA

#DB
data$intangibles_cost_recovery[data$taxdepintangibltype == "DB" & !is.na(data$taxdepintangibltype)] <- DB(data$taxdeprintangibldb[data$taxdepintangibltype == "DB" & !is.na(data$taxdepintangibltype)], 0.075)
data$intangibles_cost_recovery[data$taxdepintangibltype == "DB" & !is.na(data$taxdepintangibltype)] <- DB(data$taxdeprintangibldb[data$taxdepintangibltype == "DB" & !is.na(data$taxdepintangibltype)], 0.075)

#SL
data$intangibles_cost_recovery[data$taxdepintangibltype == "SL" & !is.na(data$taxdepintangibltype)] <- SL(data$taxdeprintangiblsl[data$taxdepintangibltype == "SL" & !is.na(data$taxdepintangibltype)], 0.075)

#initialDB
data$intangibles_cost_recovery[data$taxdepintangibltype == "initialDB" & !is.na(data$taxdepintangibltype)] <- initialDB(data$taxdeprintangibldb[data$taxdepintangibltype == "initialDB" & !is.na(data$taxdepintangibltype)],
                                                                                                                        data$taxdeprintangiblsl[data$taxdepintangibltype == "initialDB" & !is.na(data$taxdepintangibltype)], 0.075)

#DB or SL
data$intangibles_cost_recovery[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)] <- DBSL2(data$taxdeprintangibldb[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)],
                                                                                                                   data$taxdepintangibltimedb[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)],
                                                                                                                   data$taxdeprintangiblsl[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)],
                                                                                                                   data$taxdepintangibltimesl[data$taxdepintangibltype == "DB or SL" & !is.na(data$taxdepintangibltype)], 0.075)

#SL2
data$intangibles_cost_recovery[data$taxdepintangibltype == "SL2" & !is.na(data$taxdepintangibltype)] <- SL2(data$taxdeprintangibldb[data$taxdepintangibltype == "SL2" & !is.na(data$taxdepintangibltype)],
                                                                                                            data$taxdepintangibltimedb[data$taxdepintangibltype == "SL2" & !is.na(data$taxdepintangibltype)],
                                                                                                            data$taxdeprintangiblsl[data$taxdepintangibltype == "SL2" & !is.na(data$taxdepintangibltype)],
                                                                                                            data$taxdepintangibltimesl[data$taxdepintangibltype == "SL2" & !is.na(data$taxdepintangibltype)], 0.075)

#In 2000, Estonia moved to a cash-flow type business tax - all allowances need to be coded as 1
data[c('intangibles_cost_recovery','machines_cost_recovery','buildings_cost_recovery')][data$country == "EST" & data$year >=2000,] <- 1

#In 2018, Latvia also moved to a cash-flow type business tax
data[c('intangibles_cost_recovery','machines_cost_recovery','buildings_cost_recovery')][data$country == "LVA" & data$year >=2018,] <- 1

#In fall 2018, Canada introduced full expensing for machinery
data[c('machines_cost_recovery')][data$country == "CAN" & data$year >= 2018,] <- 1

#Chile introduced full expensing in 2020; phase-out in 2023, reverting to pre-2020 values
data[c('intangibles_cost_recovery','machines_cost_recovery','buildings_cost_recovery')][data$country == "CHL" & data$year ==2020,] <- 1
data[c('intangibles_cost_recovery','machines_cost_recovery','buildings_cost_recovery')][data$country == "CHL" & data$year ==2021,] <- 1
data[c('intangibles_cost_recovery', 'machines_cost_recovery', 'buildings_cost_recovery')][data$country == "CHL" & data$year == 2022, ] <- data[c('intangibles_cost_recovery', 'machines_cost_recovery', 'buildings_cost_recovery')][data$country == "CHL" & data$year == 2019, ]

#Adjust USA data to include bonus depreciation for machinery
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2002,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2002,] * 0.70) + 0.30
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2003,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2003,] * 0.70) + 0.30
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2004,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2004,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2008,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2008,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2009,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2009,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2010,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2010,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2011,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2011,] * 0.00) + 1.00
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2012,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2012,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2013,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2013,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2014,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2014,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2015,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2015,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2016,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2016,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2017,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2017,] * 0.50) + 0.50
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2018,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2018,] * 0.00) + 1.00
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2019,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2019,] * 0.00) + 1.00
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2020,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2020,] * 0.00) + 1.00
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2021,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2021,] * 0.00) + 1.00
data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2022,] <- (data[c('machines_cost_recovery')][data$country == "USA" & data$year == 2022,] * 0.00) + 0.80

#Adjust UK data to include super-deduction (2023 Spring budget: Full-expensing)
data[c('machines_cost_recovery')][data$country == "GBR" & data$year == 2021,] <- (data[c('machines_cost_recovery')][data$country == "GBR" & data$year == 2021,] * 0.00) + 1.30
data[c('machines_cost_recovery')][data$country == "GBR" & data$year == 2022,] <- (data[c('machines_cost_recovery')][data$country == "GBR" & data$year == 2022,] * 0.00) + 1

#Only keep data relevant to the ITCI
data <- subset(data, select = c(country, year, buildings_cost_recovery, machines_cost_recovery, intangibles_cost_recovery))

#Add one year to account for 1-year lag
data$year <- data$year+1

#Format output table
colnames(data) <- c("ISO_3","year","buildings_cost_recovery", "machines_cost_recovery", "intangibles_cost_recovery")
data <- merge(data, iso_country_codes, by="ISO_3")
data <- data[c("ISO_2","ISO_3","country","year","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery")]

data<-subset(data,data$year>2013)
data<-subset(data,data$ISO_3%in%oecd_countries)

#Write CSV output file
write.csv(data, file = paste(intermediate_outputs,"cost_recovery_data.csv",sep=""),row.names=F)
