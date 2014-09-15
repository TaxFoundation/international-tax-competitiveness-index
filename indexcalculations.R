# Sets the working directory. This sets it to the "index" folder on my desktop

setwd("C:/Users/kep/Desktop/index")

#Clears all datasets and variables from memory

rm(list=ls())

#Load Data
rawdata<-read.csv("indexdata.csv", header = TRUE, fill = TRUE, sep = ",")


#standardize all the scores into a new dataframe called "zscores"
zscores<-data.frame(country=rawdata$country,scale(rawdata[-1]))

#Multiply variables that need to be flipped by -1 (There is likely a better way to do this)
#List of variables flipped for reference:
#2 corprate
#9 patentbox
#10 rndcredit
#11 corptime
#12 profitpayments
#13 otherpayments
#14 vatrate
#15 threshold
#17 deductionlimitations
#18 consumptiontime
#19 propertytaxes
#20 propertytaxcollections
#21 netwealth
#22 estinhergifttaxes
#23 transfertaxes
#24 assettaxes
#25 capitalduties
#26 financialtransactiontaxes
#27 capgainsrate
#29 divrate
#30 incrate
#31 progressivity
#32 taxwedge
#33 laborpayments
#34 labortime
#37 divwithholding
#38 intwithhholding
#39 roywithholding
#41 cfcrules
#42 terreligiblecountries
#43 thincap

flip<-c(2,9,10,11,12,13,14,15,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,37,38,39,41,42,43)
flipfunc <- function(x) {
  x*(-1)
}

for (i in flip) {
zscores[i]<-apply(zscores[i], 2, flipfunc)
}


#Create Subcategories

#Categories and variables for Reference:
  #Corporate Rate
    #2 corprate
  #Cost Recovery
    #3 losscarryback
    #4 losscarryforward
    #5 pdvmachines
    #6 pdvbuildings
    #7 pdvintangibles
    #8 inventory
  #Incentives/Complexity
    #9 patentbox
    #10 rndcredit
    #11 corptime
    #12 profitpayments
    #13 otherpayments
  #Consumption Tax Rate
    #14 vatrate
  #Consumption Tax Base
    #15 threshold
    #16 base
    #17 deductionlimitations
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
    #42 terrelig
    #43 thincap
corporaterateindex<-c(2)
costrecoveryindex<-c(3:8)
incentivesindex<-c(9:13)
consumptiontaxrateindex<-c(14)
consumptiontaxbaseindex<-c(15:17)
consumptiontaxcomplexity<-c(18)
realpropertyindex<-c(19:20)
wealthtaxesindex<-c(21:22)
capitaltaxesindex<-c(23:26)
capgainsdividindex<-c(27:29)
incometaxindex<-c(30:32)
incomecomplexindex<-c(33:34)
terrindex<-c(35:36)
withholdingindex<-c(37:40)
regsindex<-c(41:43)

subcategories<-data.frame(country=rawdata$country)

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

#Final Categories and Final Score with Ranks
#Each category contains three subcategories

#Same thing as above
corporateindex<-c(2:4)
consumptionindex<-c(5:7)
propertyindex<-c(8:10)
incomeindex<-c(11:13)
internationalindex<-c(14:16)

categories<-data.frame(country=rawdata$country)

categories$corporate<-apply((subcategories[corporateindex]*(1/length(corporateindex))),1,sum)
categories$consumption<-apply((subcategories[consumptionindex]*(1/length(consumptionindex))),1,sum)
categories$property<-apply((subcategories[propertyindex]*(1/length(propertyindex))),1,sum)
categories$income<-apply((subcategories[incomeindex]*(1/length(incomeindex))),1,sum)
categories$international<-apply((subcategories[internationalindex]*(1/length(internationalindex))),1,sum)

#Create the final two files. One for subcategory ranks, the other for final ranks. This a little messy, but it outputs the data in order with propert labels. (Needs work)

final<-data.frame(country=rawdata$country)

#Final Scores

final$finalscore<-apply((categories[-1]*(1/length(categories[-1]))),1,sum)
final$finalscore<-pnorm(final$finalscore)
final$finalscore<-final$finalscore/max(final$finalscore)*100
final$finalrank<-rank(-final$finalscore,ties.method= "min")

final$corporate<-pnorm(categories$corporate)
final$corporate<-final$corporate/max(final$corporate)*100
final$corporaterank<-rank(-final$corporate,ties.method= "min")

final$consumption<-pnorm(categories$consumption)
final$consumption<-final$consumption/max(final$consumption)*100
final$consumptionrank<-rank(-final$consumption,ties.method= "min")

final$property<-pnorm(categories$property)
final$property<-final$property/max(final$property)*100
final$propertyrank<-rank(-final$property,ties.method= "min")

final$income<-pnorm(categories$income)
final$income<-final$income/max(final$income)*100
final$incomerank<-rank(-final$income,ties.method= "min")

final$international<-pnorm(categories$international)
final$international<-final$international/max(final$international)*100
final$internationalrank<-rank(-final$international,ties.method= "min")

#Subcategory scores and ranks (Messy).

norm<-function(x){
  pnorm(x)
}
subcategories[-1]<-apply(subcategories[-1],2,norm)

transform<-function(x){
  x/max(x)*100
}
subcategories[-1]<-apply(subcategories[-1],2,transform)
finalcategories<-subcategories
#Subcategories dataframe has the final scores for each subcategory

rm(zscores, categories, subcategories)

