#main index code
rm(list=ls())
gc()

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


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

# Sets the working directory. This sets it to the "index" folder on my desktop
using(plyr)
using(dplyr)
using(tidyverse)
using(readxl)


#Clears all datasets and variables from memory


#Load Data
#2014
rawdata2014 <- read_csv("indexdata2014.csv")
#2015
rawdata2015 <- read_csv("indexdata2015.csv")
#2016
rawdata2016 <- read_csv("indexdata2016.csv")
#2017
rawdata2017 <- read_csv("indexdata2017.csv")
#2018
rawdata2018 <- read_csv("indexdata2018.csv")
#2019
rawdata2019 <- read_csv("indexdata2019.csv")

#Combined Data
rawdata<-rbind(rawdata2014,rawdata2015,rawdata2016,rawdata2017,rawdata2018,rawdata2019)

#Rename Estate tax variable
rawdata$estate.inheritance.tax<-rawdata$`estate/inheritance tax`
rawdata<-rawdata[-24]
#Order variables for easy working
rawdata<-rawdata[c("ISO-3","ISO-2","country","year",
          "corprate","losscarryback" ,"losscarryforward","pdvmachines","pdvbuildings","pdvintangibles","inventory",
          "patentbox","rndcredit","corptime","profitpayments","otherpayments",
          "vatrate","threshold","base",
          "consumptiontime",
          "propertytaxes","propertytaxescollections","netwealth","estate.inheritance.tax","transfertaxes",
          "Assettaxes","capitalduties","financialtrans","capgainsrate","divrate","capgainsindex",
          "incrate","progressivity","taxwedge",
          "threshold_1","laborpayments","labortime",
          "dividendexempt","capgainsexemption","divwithhold","intwithhold",
          "roywithhold","taxtreaties","cfcrules","countrylimitations", 
          "thincap")]

#temporary NA's as zeros
rawdata[is.na(rawdata)] <- 0

#ALT Min-Max Test
normalize <-function(x){
  normal <- apply(x,2, function(x){(x-min(x))/(max(x)-min(x))*10})
  
  return(normal)
}   

#standardize all the scores into a new dataframe called "zscores," This does this by year.
zscores<-data.frame(country=rawdata$country,
                    year=rawdata$year,
                    ddply(rawdata[4:46],
                          .(year),
                          scale)
)
ALTscores<-data.frame(country=rawdata$country,
                      year=rawdata$year,
                      ddply(rawdata[4:46],
                            .(year),
                            normalize)
)

#drops the extra "year" variable left over
zscores<-zscores[-3]

#Alt Scoring Technique

ALTscores<-ALTscores[-3]

#Multiply variables that need to be flipped by -1 (There is likely a better way to do this)
#List of variables flipped for reference:
#3 corprate
#10 patentbox
#11 rndcredit
#12 corptime
#13 profitpayments
#14 otherpayments
#15 vatrate
#16 threshold
#18 consumptiontime
#19 propertytaxes
#20 propertytaxcollections
#21 netwealth
#22 estate.inheritance.tax
#23 transfertaxes
#24 Assettaxes
#25 capitalduties
#26 financialtrans
#27 capgainsrate
#29 divrate
#30 incrate
#31 progressivity
#32 taxwedge
#33 laborpayments
#34 labortime
#37 divwithhold
#38 intwithhold
#39 roywithhold
#41 cfcrules
#42 countrylimitations
#43 thincap

flip<-c("corprate","patentbox","rndcredit","corptime","profitpayments","otherpayments","vatrate","threshold","consumptiontime",
        "propertytaxes","propertytaxescollections","netwealth","estate.inheritance.tax","transfertaxes","Assettaxes","capitalduties",
        "financialtrans","capgainsrate","divrate","incrate","progressivity","taxwedge","laborpayments","labortime",
        "divwithhold","intwithhold","roywithhold","cfcrules","countrylimitations","thincap")

names(rawdata)

flip<-c(3,10,11,12,13,14,15,16,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,37,38,39,41,42,43)


flipfunc <- function(x) {
  x*(-1)
}

ALTflip <- function(x){
  (x-10)*-1
}

for (i in flip) {
zscores[i]<-apply(zscores[i], 2, flipfunc)
}

#Alt Scoring Method
for (i in flip) {
  ALTscores[i]<-apply(ALTscores[i], 2, ALTflip)
}


#Create Subcategories

#Categories and variables for Reference:
  #Corporate Rate
    #3 corprate
  #Cost Recovery
    #4 losscarryback
    #5 losscarryforward
    #6 pdvmachines
    #7 pdvbuildings
    #8 pdvintangibles
    #9 inventory
  #Incentives/Complexity
    #10 patentbox
    #11 rndcredit
    #12 corptime
    #13 profitpayments
    #14 otherpayments
  #Consumption Tax Rate
    #15 vatrate
  #Consumption Tax Base
    #16 threshold
    #17 base
  #Consumption Tax Complexity
    #18 consumptiontime
  #Real Property Taxes
    #19 propertytaxes
    #20 propertycollections
  #Wealth Taxes
    #21 netwealth
    #22 estate/inheritance
  #Capital Taxes
    #23 Transfertaxes
    #24 assettaxes
    #25 capitalduties
    #26 financialtransactiontaxes
  #Capital Gains and Dividends
    #27 capgainsrates
    #28 capgainsindex
    #29 divrate
  #income taxes
    #30 incrate
    #31 progressivity
    #32 taxwedge
  #income complexity
    #33 laborpayments
    #34 labortime
  #territoriality
    #35 dividendexemption
    #36 capgainsexemption
  #withholding taxes
    #37 divwithholding
    #38 intwithholding
    #39 roywithholding
    #40 treaties
  #regulations
    #41 cfcrules
    #42 terrrelig
    #43 thincap
#corporaterateindex<-c(3)
#costrecoveryindex<-c(4:9)
#incentivesindex<-c(10:14)
#consumptiontaxrateindex<-c(15)
#consumptiontaxbaseindex<-c(16:17)
#consumptiontaxcomplexity<-c(18)
#realpropertyindex<-c(19:20)
#wealthtaxesindex<-c(21:22)
#capitaltaxesindex<-c(23:26)
#capgainsdividindex<-c(27:29)
#incometaxindex<-c(30:32)
#incomecomplexindex<-c(33:34)
#terrindex<-c(35:36)
#withholdingindex<-c(37:40)
#regsindex<-c(41:43)

corporaterateindex<-c("corprate")
costrecoveryindex<-c("losscarryback","losscarryforward","pdvmachines","pdvbuildings","pdvintangibles","inventory")
incentivesindex<-c("patentbox","rndcredit","corptime","profitpayments","otherpayments")
consumptiontaxrateindex<-c("vatrate")
consumptiontaxbaseindex<-c("threshold","base")
consumptiontaxcomplexity<-c("consumptiontime")
realpropertyindex<-c("propertytaxes","propertytaxescollections")
wealthtaxesindex<-c("netwealth","estate.inheritance.tax")
capitaltaxesindex<-c("transfertaxes","Assettaxes","capitalduties","financialtrans")
capgainsdividindex<-c("capgainsrate","capgainsindex","divrate")
incometaxindex<-c("incrate","progressivity","taxwedge")
incomecomplexindex<-c("laborpayments","labortime")
terrindex<-c("dividendexempt","capgainsexemption","countrylimitations")
withholdingindex<-c("divwithhold","intwithhold","roywithhold","taxtreaties")
regsindex<-c("cfcrules","thincap")

subcategories<-data.frame(country=zscores$country,
                          year=zscores$year)

subcategories$corporaterate<-apply((zscores[corporaterateindex]*(1/length(corporaterateindex))),1,sum)
subcategories$costrecovery<-apply((zscores[costrecoveryindex]*(1/length(costrecoveryindex))),1,sum)
subcategories$incentives<-apply((zscores[incentivesindex]*(1/length(incentivesindex))),1,sum)
subcategories$consumptiontaxrate<-apply((zscores[consumptiontaxrateindex]*(1/length(consumptiontaxrateindex))),1,sum)
subcategories$consumptiontaxbase<-apply((zscores[consumptiontaxbaseindex]*(1/length(consumptiontaxbaseindex))),1,sum)
subcategories$consumptiontaxcomplexity<-apply((zscores[consumptiontaxcomplexity]*(1/length(consumptiontaxcomplexity))),1,sum)
subcategories$realpropertytax<-apply((zscores[realpropertyindex]*(1/length(realpropertyindex))),1,sum)
subcategories$wealthtaxes<-apply((zscores[wealthtaxesindex]*(1/length(wealthtaxesindex))),1,sum)
subcategories$capitaltaxes<-apply((zscores[capitaltaxesindex]*(1/length(capitaltaxesindex))),1,sum)
subcategories$capgainsanddividends<-apply((zscores[capgainsdividindex]*(1/length(capgainsdividindex))),1,sum)
subcategories$incometax<-apply((zscores[incometaxindex]*(1/length(incometaxindex))),1,sum)
subcategories$incometaxcomplexity<-apply((zscores[incomecomplexindex]*(1/length(incomecomplexindex))),1,sum)
subcategories$territorial<-apply((zscores[terrindex]*(1/length(terrindex))),1,sum)
subcategories$withholdingtaxes<-apply((zscores[withholdingindex]*(1/length(withholdingindex))),1,sum)
subcategories$intregulations<-apply((zscores[regsindex]*(1/length(regsindex))),1,sum)

#ALT Scoring Technique

ALTsubcategories<-data.frame(country=ALTscores$country,
                             year=ALTscores$year)

ALTsubcategories$corporaterate<-apply((ALTscores[corporaterateindex]*(1/length(corporaterateindex))),1,sum)
ALTsubcategories$costrecovery<-apply((ALTscores[costrecoveryindex]*(1/length(costrecoveryindex))),1,sum)
ALTsubcategories$incentives<-apply((ALTscores[incentivesindex]*(1/length(incentivesindex))),1,sum)
ALTsubcategories$consumptiontaxrate<-apply((ALTscores[consumptiontaxrateindex]*(1/length(consumptiontaxrateindex))),1,sum)
ALTsubcategories$consumptiontaxbase<-apply((ALTscores[consumptiontaxbaseindex]*(1/length(consumptiontaxbaseindex))),1,sum)
ALTsubcategories$consumptiontaxcomplexity<-apply((ALTscores[consumptiontaxcomplexity]*(1/length(consumptiontaxcomplexity))),1,sum)
ALTsubcategories$realpropertytax<-apply((ALTscores[realpropertyindex]*(1/length(realpropertyindex))),1,sum)
ALTsubcategories$wealthtaxes<-apply((ALTscores[wealthtaxesindex]*(1/length(wealthtaxesindex))),1,sum)
ALTsubcategories$capitaltaxes<-apply((ALTscores[capitaltaxesindex]*(1/length(capitaltaxesindex))),1,sum)
ALTsubcategories$capgainsanddividends<-apply((ALTscores[capgainsdividindex]*(1/length(capgainsdividindex))),1,sum)
ALTsubcategories$incometax<-apply((ALTscores[incometaxindex]*(1/length(incometaxindex))),1,sum)
ALTsubcategories$incometaxcomplexity<-apply((ALTscores[incomecomplexindex]*(1/length(incomecomplexindex))),1,sum)
ALTsubcategories$territorial<-apply((ALTscores[terrindex]*(1/length(terrindex))),1,sum)
ALTsubcategories$withholdingtaxes<-apply((ALTscores[withholdingindex]*(1/length(withholdingindex))),1,sum)
ALTsubcategories$intregulations<-apply((ALTscores[regsindex]*(1/length(regsindex))),1,sum)

#Final Categories and Final Score with Ranks
#Each category contains three subcategories

#Same thing as above
#corporateindex<-c(3:5)
#consumptionindex<-c(6:8)
#propertyindex<-c(9:11)
#incomeindex<-c(12:14)
#internationalindex<-c(15:17)

corporateindex<-c("corporaterate","costrecovery","incentives")
consumptionindex<-c("consumptiontaxrate","consumptiontaxbase","consumptiontaxcomplexity")
propertyindex<-c("realpropertytax","wealthtaxes","capitaltaxes")
incomeindex<-c("capgainsanddividends","incometax","incometaxcomplexity")
internationalindex<-c("territorial","withholdingtaxes","intregulations")


categories<-data.frame(country=rawdata$country,
                       year=rawdata$year)

categories$corporate<-apply((subcategories[corporateindex]*(1/length(corporateindex))),1,sum)
categories$consumption<-apply((subcategories[consumptionindex]*(1/length(consumptionindex))),1,sum)
categories$property<-apply((subcategories[propertyindex]*(1/length(propertyindex))),1,sum)
categories$income<-apply((subcategories[incomeindex]*(1/length(incomeindex))),1,sum)
categories$international<-apply((subcategories[internationalindex]*(1/length(internationalindex))),1,sum)
categories$final<-apply((categories[3:7]*(1/length(categories[3:7]))),1,sum)

#ALT Scoring method

ALTcategories<-data.frame(country=rawdata$country,
                          year=rawdata$year)

ALTcategories$corporate<-apply((ALTsubcategories[corporateindex]*(1/length(corporateindex))),1,sum)
ALTcategories$consumption<-apply((ALTsubcategories[consumptionindex]*(1/length(consumptionindex))),1,sum)
ALTcategories$property<-apply((ALTsubcategories[propertyindex]*(1/length(propertyindex))),1,sum)
ALTcategories$income<-apply((ALTsubcategories[incomeindex]*(1/length(incomeindex))),1,sum)
ALTcategories$international<-apply((ALTsubcategories[internationalindex]*(1/length(internationalindex))),1,sum)
ALTcategories$final<-apply((ALTcategories[3:7]*(1/length(categories[3:7]))),1,sum)

#normalize all category and subcategory scores

#Define a function that applies the final score

#Method 1 (uses P Values to normalize)

score1<-function(x){
  normal<-apply(x[-1],2,function(x) {pnorm(x)})
  s<-apply(normal,2,function(normal) {(normal/(max(normal))*100)})
  return(s)
}

#Method 2 (uses min + 1 to normalize)

score2<-function(x){
  normal<-apply(x[-1],2,function(x) {x+(-min(x)+1)})
  s<-apply(normal,2,function(normal) {(normal/(max(normal))*100)})
  return(s)
}

#Alt Scaling Method

ALTscale<-function(x){
  s<-apply(x[-1],2,function(x) {(x/(max(x))*100)})
  return(s)
}

#Rank Function

rank1<-function(x){
  
  ranks<-rank(-x,ties.method= "min")
  return(ranks)
}

#Subcategory Scores

subcategories<-data.frame(country=rawdata$country,
                          ddply(subcategories[-1],
                                .(year),
                                score2)
)

  #Alt Subcategory Scores

#    ALTsubcategories<-data.frame(country=rawdata$country,
#                              ddply(ALTsubcategories[-1],
#                                    .(year),
#                                    ALTscale)
#    )


#Add Ranks

subcategories<-ddply(subcategories, 
                     .(year),
                     transform,
                     corporateraterank = rank(-corporaterate,ties.method = "min"),
                     costrecoveryrank = rank(-costrecovery,ties.method = "min"),
                     incentivesrank = rank(-incentives,ties.method = "min"),
                     consumptiontaxraterank = rank(-consumptiontaxrate,ties.method = "min"),
                     consumptiontaxbaserank = rank(-consumptiontaxbase,ties.method = "min"),
                     consumptiontaxcomplexityrank = rank(-consumptiontaxcomplexity,ties.method = "min"),
                     realpropertytaxrank = rank(-realpropertytax,ties.method = "min"),
                     wealthtaxesrank = rank(-wealthtaxes,ties.method = "min"),
                     capitaltaxesrank = rank(-capitaltaxes,ties.method = "min"),
                     capgainsanddividendsrank = rank(-capgainsanddividends,ties.method = "min"),
                     incometaxrank = rank(-incometax,ties.method = "min"),
                     incometaxcomplexityrank = rank(-incometaxcomplexity,ties.method = "min"),
                     territorialrank = rank(-territorial,ties.method = "min"),
                     withholdingtaxesrank = rank(-withholdingtaxes,ties.method = "min"),
                     intregulationsrank = rank(-intregulations,ties.method = "min")
)

#ALT Scoring method

ALTsubcategories<-ddply(ALTsubcategories, 
                        .(year),
                        transform,
                        corporateraterank = rank(-corporaterate,ties.method = "min"),
                        costrecoveryrank = rank(-costrecovery,ties.method = "min"),
                        incentivesrank = rank(-incentives,ties.method = "min"),
                        consumptiontaxraterank = rank(-consumptiontaxrate,ties.method = "min"),
                        consumptiontaxbaserank = rank(-consumptiontaxbase,ties.method = "min"),
                        consumptiontaxcomplexityrank = rank(-consumptiontaxcomplexity,ties.method = "min"),
                        realpropertytaxrank = rank(-realpropertytax,ties.method = "min"),
                        wealthtaxesrank = rank(-wealthtaxes,ties.method = "min"),
                        capitaltaxesrank = rank(-capitaltaxes,ties.method = "min"),
                        capgainsanddividendsrank = rank(-capgainsanddividends,ties.method = "min"),
                        incometaxrank = rank(-incometax,ties.method = "min"),
                        incometaxcomplexityrank = rank(-incometaxcomplexity,ties.method = "min"),
                        territorialrank = rank(-territorial,ties.method = "min"),
                        withholdingtaxesrank = rank(-withholdingtaxes,ties.method = "min"),
                        intregulationsrank = rank(-intregulations,ties.method = "min")
)

#Category Scores

categories<-data.frame(country=rawdata$country,
                       ddply(categories[-1],
                       .(year),
                        score2)
)

#ALT Category Scores

#    ALTcategories<-data.frame(country=rawdata$country,
#                           ddply(ALTcategories[-1],
#                                 .(year),
#                                 ALTscale)
#    )

#Add Ranks

categories<-ddply(categories, 
                  .(year),
                  transform,
                  corporaterank = rank(-corporate,ties.method = "min"),
                  consumptionrank = rank(-consumption,ties.method = "min"),
                  propertyrank = rank(-property,ties.method = "min"),
                  incomerank = rank(-income,ties.method = "min"),
                  internationalrank = rank(-international,ties.method = "min"),
                  finalrank = rank(-final,ties.method = "min")                      
)


#ALT scoring method

ALTcategories<-ddply(ALTcategories, 
                     .(year),
                     transform,
                     corporaterank = rank(-corporate,ties.method = "min"),
                     consumptionrank = rank(-consumption,ties.method = "min"),
                     propertyrank = rank(-property,ties.method = "min"),
                     incomerank = rank(-income,ties.method = "min"),
                     internationalrank = rank(-international,ties.method = "min"),
                     finalrank = rank(-final,ties.method = "min")                      
)

#Create the final two files. One for subcategory ranks, the other for final ranks. 

finalcategories<-data.frame(country=zscores$country,
                            year=zscores$year)

for (x in 1:((length(categories)-2)/2)){
  finalcategories[length(finalcategories)+1]<-categories[x+8]
  finalcategories[length(finalcategories)+1]<-categories[x+2]
}

finalsubcategories<-data.frame(country=zscores$country,
                               year=zscores$year)

for (x in 1:((length(subcategories)-2)/2)){
  finalsubcategories[length(finalsubcategories)+1]<-subcategories[x+((length(subcategories)-0)/2)+1]
  finalsubcategories[length(finalsubcategories)+1]<-subcategories[x+2]
}

#ALT Scoring Method:

ALTfinalcategories<-data.frame(country=ALTscores$country,
                               year=ALTscores$year)

for (x in 1:((length(ALTcategories)-2)/2)){
  ALTfinalcategories[length(ALTfinalcategories)+1]<-ALTcategories[x+8]
  ALTfinalcategories[length(ALTfinalcategories)+1]<-ALTcategories[x+2]
}

ALTfinalsubcategories<-data.frame(country=ALTscores$country,
                                  year=ALTscores$year)

for (x in 1:((length(ALTsubcategories)-2)/2)){
  ALTfinalsubcategories[length(ALTfinalsubcategories)+1]<-ALTsubcategories[x+((length(ALTsubcategories)-0)/2)+1]
  ALTfinalsubcategories[length(ALTfinalsubcategories)+1]<-ALTsubcategories[x+2]
}

#rm(zscores, categories, subcategories, ALTscores, ALTcategories, ALTsubcategories)

Final2014<-finalcategories[finalcategories$year==2014,]
Final2015<-finalcategories[finalcategories$year==2015,]
Final2016<-finalcategories[finalcategories$year==2016,]
Final2017<-finalcategories[finalcategories$year==2017,]
Final2018<-finalcategories[finalcategories$year==2018,]
Final2019<-finalcategories[finalcategories$year==2019,]

#Data Check

check<-rawdata[rawdata$country == "Greece",]

#Checking Sensitivity

#Does the normalization technique drive the results?

cor(ALTfinalcategories$final[ALTfinalcategories$year == 2016],finalcategories$final[finalcategories$year == 2016])

#not really. 98 percent correlation between the two

#Which Category drives the results the most?

#normal scoring techniques:

cortest1<-finalcategories[finalcategories$year == 2015,]
subcortest1<-finalsubcategories[finalsubcategories$year == 2015,]
subcortest1<-cbind(subcortest1,cortest1[14])
cor(cortest1[c(4,6,8,10,12,14)])
cor(subcortest1[c(seq(4,32,2),33)])


importance<-lm(cortest1$final ~ cortest1$corporate + cortest1$income + cortest1$consumption + cortest1$property + cortest1$international)
calc.relimp(importance, rela= TRUE)
#alternative scoring techniques:

cortest2<-ALTfinalcategories[ALTfinalcategories$year == 2015,]
cor(cortest2[c(4,6,8,10,12,14)])     
write.csv(Final2018, file = "data2018run.csv")

Australia<-finalcategories[finalcategories$country=="Australia",]
Austria<-finalcategories[finalcategories$country=="Austria",]
Belgium<-finalcategories[finalcategories$country=="Belgium",]
Canada<-finalcategories[finalcategories$country=="Canada",]
Chile<-finalcategories[finalcategories$country=="Chile",]
Czech_Republic<-finalcategories[finalcategories$country=="Czech Republic",]
Denmark<-finalcategories[finalcategories$country=="Denmark",]
Estonia<-finalcategories[finalcategories$country=="Estonia",]
Finland<-finalcategories[finalcategories$country=="Finland",]
France<-finalcategories[finalcategories$country=="France",]
Germany<-finalcategories[finalcategories$country=="Germany",]
Greece<-finalcategories[finalcategories$country=="Greece",]
Hungary<-finalcategories[finalcategories$country=="Hungary",]
Iceland<-finalcategories[finalcategories$country=="Iceland",]
Ireland<-finalcategories[finalcategories$country=="Ireland",]
Israel<-finalcategories[finalcategories$country=="Israel",]
Italy<-finalcategories[finalcategories$country=="Italy",]
Japan<-finalcategories[finalcategories$country=="Japan",]
Korea<-finalcategories[finalcategories$country=="Korea",]
Latvia<-finalcategories[finalcategories$country=="Latvia",]
Luxembourg<-finalcategories[finalcategories$country=="Luxembourg",]
Mexico<-finalcategories[finalcategories$country=="Mexico",]
Netherlands<-finalcategories[finalcategories$country=="Netherlands",]
New_Zealand<-finalcategories[finalcategories$country=="New Zealand",]
Norway<-finalcategories[finalcategories$country=="Norway",]
Poland<-finalcategories[finalcategories$country=="Poland",]
Portugal<-finalcategories[finalcategories$country=="Portugal",]
Slovak_Republic<-finalcategories[finalcategories$country=="Slovak Republic",]
Slovenia<-finalcategories[finalcategories$country=="Slovenia",]
Spain<-finalcategories[finalcategories$country=="Spain",]
Sweden<-finalcategories[finalcategories$country=="Sweden",]
Switzerland<-finalcategories[finalcategories$country=="Switzerland",]
Turkey<-finalcategories[finalcategories$country=="Turkey",]
United_Kingdom<-finalcategories[finalcategories$country=="United Kingdom",]
United_States<-finalcategories[finalcategories$country=="United States",]


#Changes from 2017 index
M <- merge(Final2018,Final2017,by="country")

Changes <- M[,grepl("*\\.x$",names(M))] - M[,grepl("*\\.y$",names(M))]

Changes<-cbind(M[,1,drop=FALSE],Changes)

#Compare 2016, 2017, and 2018 results
Table2_Changes<-merge(Final2017,Final2018,by="country")
Table2_Changes<-Table2_Changes[c(1,13,14,26,27)]
colnames(Table2_Changes)<-c("country", "2017 Rank","2017 Score","2018 Rank","2018 Score")
Table2_Changes<-merge(Final2016,Table2_Changes,by="country")
Table2_Changes<-Table2_Changes[c(1,13:18)]
colnames(Table2_Changes)<-c("Country","2016 Rank","2016 Score", "2017 Rank","2017 Score","2018 Rank","2018 Score")
Table2_Changes$'Change in Rank'<-(Table2_Changes$`2018 Rank`-Table2_Changes$`2017 Rank`)*(-1)
Table2_Changes$'Change in Score'<-Table2_Changes$`2018 Score`-Table2_Changes$`2017 Score`
write.csv(Table2_Changes,"Table 2 Changes from Previous Years.csv")

subcategories_2018<-subset(subcategories,year==2018)
subcategories_2017<-subset(subcategories,year==2017)

write.csv(subcategories_2018,"subcategories 2018.csv")
