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


#Load Data
#2014
rawdata2014 <- read_csv("./final-data/final_indexdata2014.csv")
#2015
rawdata2015 <- read_csv("./final-data/final_indexdata2015.csv")
#2016
rawdata2016 <- read_csv("./final-data/final_indexdata2016.csv")
#2017
rawdata2017 <- read_csv("./final-data/final_indexdata2017.csv")
#2018
rawdata2018 <- read_csv("./final-data/final_indexdata2018.csv")
#2019
rawdata2019 <- read_csv("./final-data/final_indexdata2019.csv")


#Combined Data
rawdata<-rbind(rawdata2014,rawdata2015,rawdata2016,rawdata2017,rawdata2018,rawdata2019)


rawdata$patent_box<-as.numeric(rawdata$patent_box)
rawdata$r_and_d_credit<-as.numeric(rawdata$r_and_d_credit)
rawdata$net_wealth<-as.numeric(rawdata$net_wealth)
rawdata$`estate/inheritance tax`<-as.numeric(rawdata$`estate/inheritance tax`)
rawdata$transfer_tax<-as.numeric(rawdata$transfer_tax)
rawdata$asset_tax<-as.numeric(rawdata$asset_tax)
rawdata$capital_duties<-as.numeric(rawdata$capital_duties)
rawdata$financial_transaction_tax<-as.numeric(rawdata$financial_transaction_tax)
rawdata$capgainsindex<-as.numeric(rawdata$capgainsindex)
rawdata$taxtreaties<-as.numeric(rawdata$taxtreaties)
rawdata$countrylimitations<-as.numeric(rawdata$countrylimitations)


#Rename Estate tax variable
rawdata$estate_or_inheritance_tax<-rawdata$`estate/inheritance tax`
out<-c("estate/inheritance tax")
rawdata<-rawdata[,!names(rawdata) %in% out]

#Order variables for easier working
rawdata<-rawdata[c("ISO_2","ISO_3","country","year",
                 "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                 "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                 "vat_rate","vat_threshold","vat_base","consumption_time",
                 "property_tax", "property_tax_collections","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                 "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","cfc_rules","thin_capitalization_rules")]


#temporary NA's as zeros
#rawdata[is.na(rawdata)] <- 0

#ALT Min-Max Test
normalize <-function(x){
  normal <- apply(x,2, function(x){(x-min(x))/(max(x)-min(x))*10})
  
  return(normal)
}   

#standardize all the scores into a new dataframe called "zscores," This does this by year.
zscores<-data.frame(country=rawdata$country,
                    year=rawdata$year,
                    ddply(rawdata[4:45],
                          .(year),
                          scale)
)
ALTscores<-data.frame(country=rawdata$country,
                      year=rawdata$year,
                      ddply(rawdata[4:45],
                            .(year),
                            normalize)
)

#drops the extra "year" variable left over
zscores<-zscores[-3]
ALTscores<-ALTscores[-3]



#Multiply variables that need to be flipped by -1 (There is likely a better way to do this)
#List of variables flipped for reference:
#3 corporate_rate
#10 patent_box
#11 r_and_d_credit
#12 corporate_time
#13 profit_payments
#14 other_payments
#15 vat_rate
#16 vat_threshold
#18 consumption_time
#19 property_tax
#20 property_tax_collections
#21 net_wealth
#22 estate_or_inheritance_tax
#23 transfer_tax
#24 asset_tax
#25 capital_duties
#26 financial_transaction_tax
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

flip<-c("corporate_rate","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments","vat_rate","vat_threshold","consumption_time",
        "property_tax","property_tax_collections","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties",
        "financial_transaction_tax","capgainsrate","divrate","incrate","progressivity","taxwedge","laborpayments","labortime",
        "divwithhold","intwithhold","roywithhold","cfcrules","countrylimitations","thincap")


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
    #3 corporate_rate
  #Cost Recovery
    #4 loss_carryback
    #5 loss_carryforward
    #6 machines_cost_recovery
    #7 buildings_cost_recovery
    #8 intangibles_cost_recovery
    #9 inventory
  #Incentives/Complexity
    #10 patent_box
    #11 r_and_d_credit
    #12 corporate_time
    #13 profit_payments
    #14 other_payments
  #Consumption Tax Rate
    #15 vat_rate
  #Consumption Tax vat_base
    #16 vat_threshold
    #17 vat_base
  #Consumption Tax Complexity
    #18 consumption_time
  #Real Property Taxes
    #19 property_tax
    #20 propertycollections
  #Wealth Taxes
    #21 net_wealth
    #22 estate/inheritance
  #Capital Taxes
    #23 transfer_tax
    #24 asset_tax
    #25 capital_duties
    #26 financial_transaction_taxactiontaxes
  #Capital Gains and Dividends
    #27 capgainsrates
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
    #42 countrylimitations
  #withholding taxes
    #37 divwithholding
    #38 intwithholding
    #39 roywithholding
    #40 treaties
  #regulations
    #41 cfcrules
    #43 thincap


corporaterateindex<-c("corporate_rate")
costrecoveryindex<-c("loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory")
incentivesindex<-c("patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments")
consumptiontaxrateindex<-c("vat_rate")
consumptiontaxvat_baseindex<-c("vat_threshold","vat_base")
consumptiontaxcomplexity<-c("consumption_time")
realpropertyindex<-c("property_tax","property_tax_collections")
wealthtaxesindex<-c("net_wealth","estate_or_inheritance_tax")
capitaltaxesindex<-c("transfer_tax","asset_tax","capital_duties","financial_transaction_tax")
capgainsdividindex<-c("capgainsrate","divrate")
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
subcategories$consumptiontaxvat_base<-apply((zscores[consumptiontaxvat_baseindex]*(1/length(consumptiontaxvat_baseindex))),1,sum)
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
ALTsubcategories$consumptiontaxvat_base<-apply((ALTscores[consumptiontaxvat_baseindex]*(1/length(consumptiontaxvat_baseindex))),1,sum)
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
corporateindex<-c("corporaterate","costrecovery","incentives")
consumptionindex<-c("consumptiontaxrate","consumptiontaxvat_base","consumptiontaxcomplexity")
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

write.csv(subset(categories,categories$year==2019),file = "./final-outputs/categories_score.csv",row.names=F)



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

#Method 1 (uses P Values to normalize)# Unused function!!!

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
write.csv(subset(subcategories,subcategories$year==2019),file = "./final-outputs/subcategories_zscore.csv",row.names=F)


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
                     consumptiontaxvat_baserank = rank(-consumptiontaxvat_base,ties.method = "min"),
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
                        consumptiontaxvat_baserank = rank(-consumptiontaxvat_base,ties.method = "min"),
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

#Load ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
ISO_Country_Codes <- read_csv("./source-data/ISO Country Codes.csv")
colnames(ISO_Country_Codes)<-c("country","ISO_2","ISO_3")

finalcategories<-merge(finalcategories,ISO_Country_Codes,by=c("country"))
finalsubcategories<-merge(finalsubcategories,ISO_Country_Codes,by=c("country"))

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

cor(ALTfinalcategories$final[ALTfinalcategories$year == 2019],finalcategories$final[finalcategories$year == 2019])

#not really. 98 percent correlation between the two

#Which Category drives the results the most?

#normal scoring techniques:

cortest1<-finalcategories[finalcategories$year == 2019,]
subcortest1<-finalsubcategories[finalsubcategories$year == 2019,]
subcortest1<-cbind(subcortest1,cortest1[14])
cor(cortest1[c(4,6,8,10,12,14)])
categories_correl<-data.frame(cor(cortest1[c(4,6,8,10,12,14)]))
write.csv(categories_correl,"./final-outputs/Categories correlation.csv")

subcategories_correl<-data.frame(cor(subcortest1[c(seq(4,32,2),35)]))
write.csv(subcategories_correl,"./final-outputs/Subategories correlation.csv")



importance<-lm(cortest1$final ~ cortest1$corporate + cortest1$income + cortest1$consumption + cortest1$property + cortest1$international)
calc.relimp(importance, rela= TRUE)
#alternative scoring techniques:

cortest2<-ALTfinalcategories[ALTfinalcategories$year == 2015,]
cor(cortest2[c(4,6,8,10,12,14)])     


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
Lithuania<-finalcategories[finalcategories$country=="Lithuania",]
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


#Changes from 2018 index
M <- merge(Final2019,Final2018,by="country")
#drop ISO variables
drop_iso<-names(M) %in% c("ISO_2.x","ISO_3.x","ISO_2.y","ISO_3.y")
M<-M[!drop_iso]

Changes <- M[,grepl("*\\.x$",names(M))] - M[,grepl("*\\.y$",names(M))]

Changes<-cbind(M[,1,drop=FALSE],Changes)

finalsubcategories_2019<-subset(finalsubcategories,year==2019)


write.csv(rawdata,"./final-outputs/Raw Data 2019.csv",row.names=F)
write.csv(Final2017, file = "./final-outputs/data2017run.csv",row.names=F)
write.csv(Final2018, file = "./final-outputs/data2018run.csv",row.names=F)
write.csv(Final2019, file = "./final-outputs/data2019run.csv",row.names=F)

write.csv(finalsubcategories_2019,"./final-outputs/subcategories 2019.csv",row.names=F)
write.csv(finalcategories,"./final-outputs/final categories 2014-2019.csv",row.names=F)
