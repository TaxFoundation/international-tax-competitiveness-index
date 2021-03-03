#main index code

#Load Data####
#2014
raw_data_2014 <- read_csv(paste(final_data,"final_index_data_2014.csv",sep=""))
#2015
raw_data_2015 <- read_csv(paste(final_data,"final_index_data_2015.csv",sep=""))
#2016
raw_data_2016 <- read_csv(paste(final_data,"final_index_data_2016.csv",sep=""))
#2017
raw_data_2017 <- read_csv(paste(final_data,"final_index_data_2017.csv",sep=""))
#2018
raw_data_2018 <- read_csv(paste(final_data,"final_index_data_2018.csv",sep=""))
#2019
raw_data_2019 <- read_csv(paste(final_data,"final_index_data_2019.csv",sep=""))
#2020
raw_data_2020 <- read_csv(paste(final_data,"final_index_data_2020.csv",sep=""))


#Combined Data####
raw_data<-rbind(raw_data_2014,raw_data_2015,raw_data_2016,raw_data_2017,raw_data_2018,raw_data_2019,raw_data_2020)


raw_data$patent_box<-as.numeric(raw_data$patent_box)
raw_data$r_and_d_credit<-as.numeric(raw_data$r_and_d_credit)
raw_data$net_wealth<-as.numeric(raw_data$net_wealth)
raw_data$estate_or_inheritance_tax<-as.numeric(raw_data$estate_or_inheritance_tax)
raw_data$transfer_tax<-as.numeric(raw_data$transfer_tax)
raw_data$asset_tax<-as.numeric(raw_data$asset_tax)
raw_data$capital_duties<-as.numeric(raw_data$capital_duties)
raw_data$financial_transaction_tax<-as.numeric(raw_data$financial_transaction_tax)
raw_data$index_capital_gains<-as.numeric(raw_data$index_capital_gains)
raw_data$tax_treaties<-as.numeric(raw_data$tax_treaties)
raw_data$country_limitations<-as.numeric(raw_data$country_limitations)


#Order variables for easier working
raw_data<-raw_data[c("ISO_2","ISO_3","country","year",
                 "corporate_rate","loss_carryback","loss_carryforward","machines_cost_recovery","buildings_cost_recovery","intangibles_cost_recovery","inventory","allowance_corporate_equity","patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments",
                 "top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time","capital_gains_rate","index_capital_gains","dividends_rate",
                 "vat_rate","vat_threshold","vat_base","consumption_time",
                 "property_tax", "property_tax_collections","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax","capital_duties","financial_transaction_tax",
                 "dividends_exemption","capital_gains_exemption","country_limitations","dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","tax_treaties","cfc_rules","thin_capitalization_rules")]

#alternate_ Min-Max Test
normalize <-function(x){
  normal <- apply(x,2, function(x){(x-min(x))/(max(x)-min(x))*10})
  
  return(normal)
}   

#standardize all the scores into a new dataframe called "zscores," This does this by year.
zscores<-data.frame(country=raw_data$country,
                    year=raw_data$year,
                    ddply(raw_data[4:46],
                          .(year),
                          scale)
)
alternate_scores<-data.frame(country=raw_data$country,
                      year=raw_data$year,
                      ddply(raw_data[4:46],
                            .(year),
                            normalize)
)

#drops the extra "year" variable left over
zscores<-zscores[-3]
alternate_scores<-alternate_scores[-3]

#Flipping zeros and ones####

#Multiply variables that need to be flipped by -1 (There is likely a better way to do this)
#List of variables flipped for reference:
# corporate_rate
# r_and_d_credit
# corporate_time
# profit_payments
# other_payments
# top_income_rate
# threshold_top_income_rate
# tax_wedge
# labor_payments
# labor_time
# capital_gains_rate
# dividends_rate
# vat_rate
# vat_threshold
# consumption_time
# property_tax_collections
# country_limitations
# dividends_withholding_tax
# interest_withholding_tax
# royalties_withholding_tax
# cfc_rules
# thin_capitalization_rules

flip<-c("corporate_rate","r_and_d_credit","corporate_time","profit_payments","other_payments","vat_rate","vat_threshold","consumption_time","property_tax_collections",
        "capital_gains_rate","dividends_rate","top_income_rate","threshold_top_income_rate","tax_wedge","labor_payments","labor_time",
        "dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax","cfc_rules","country_limitations","thin_capitalization_rules")


flipfunc <- function(x) {
  x*(-1)
}

alternate_flip <- function(x){
  (x-10)*-1
}

for (i in flip) {
zscores[i]<-apply(zscores[i], 2, flipfunc)
}

#Alt Scoring Method
for (i in flip) {
  alternate_scores[i]<-apply(alternate_scores[i], 2, alternate_flip)
}


#Create Subcategories####

#Categories and variables for Reference:
  #Corporate Rate
    # corporate_rate
  #Cost Recovery
    # loss_carryback
    # loss_carryforward
    # machines_cost_recovery
    # buildings_cost_recovery
    # intangibles_cost_recovery
    # inventory
    # allowance_corporate_equity
  #Incentives/Complexity
    # patent_box
    # r_and_d_credit
    # corporate_time
    # profit_payments
    # other_payments
  #Consumption Tax Rate
    # vat_rate
  #Consumption Tax vat_base
    # vat_threshold
    # vat_base
  #Consumption Tax Complexity
    # consumption_time
  #Real Property Taxes
    # property_tax
    # propertycollections
  #Wealth Taxes
    # net_wealth
    # estate_or_inheritance_tax
  #Capital Taxes
    # transfer_tax
    # asset_tax
    # capital_duties
    # financial_transaction_taxactiontaxes
  #Capital Gains and Dividends
    # capital_gains_rates
    # dividends_rate
  #income taxes
    # top_income_rate
    # threshold_top_income_rate
    # tax_wedge
  #income complexity
    # labor_payments
    # labor_time
  #territoriality
    # dividends_exemptionion
    # capital_gains_exemption
    # country_limitations
  #withholding taxes
    # dividends_withholding_taxing
    # interest_withholding_taxing
    # royalties_withholding_taxing
  #tax treaties
    # treaties
  #regulations
    # cfc_rules
    # thin_capitalization_rules

corporate_rate_index<-c("corporate_rate")
cost_recovery_index<-c("loss_carryback","loss_carryforward","machines_cost_recovery",
                       "buildings_cost_recovery","intangibles_cost_recovery","inventory","allowance_corporate_equity")
incentives_index<-c("patent_box","r_and_d_credit","corporate_time","profit_payments","other_payments")
consumption_tax_rate_index<-c("vat_rate")
consumption_tax_base_index<-c("vat_threshold","vat_base")
consumption_tax_complexity<-c("consumption_time")
real_property_index<-c("property_tax","property_tax_collections")
wealth_taxes_index<-c("net_wealth","estate_or_inheritance_tax")
capital_taxes_index<-c("transfer_tax","asset_tax","capital_duties","financial_transaction_tax")
capital_gains_and_dividends_index<-c("capital_gains_rate","dividends_rate")
income_tax_index<-c("top_income_rate","threshold_top_income_rate","tax_wedge")
income_tax_complexity_index<-c("labor_payments","labor_time")
territorial_index<-c("dividends_exemption","capital_gains_exemption","country_limitations")
withholding_index<-c("dividends_withholding_tax","interest_withholding_tax","royalties_withholding_tax")
tax_treaties_index<-c("tax_treaties")
international_regulations_index<-c("cfc_rules","thin_capitalization_rules")

subcategories<-data.frame(country=zscores$country,
                          year=zscores$year)

subcategories$corporate_rate<-apply((zscores[corporate_rate_index]*(1/length(corporate_rate_index))),1,sum)
subcategories$cost_recovery<-apply((zscores[cost_recovery_index]*(1/length(cost_recovery_index))),1,sum)
subcategories$incentives<-apply((zscores[incentives_index]*(1/length(incentives_index))),1,sum)
subcategories$consumption_tax_rate<-apply((zscores[consumption_tax_rate_index]*(1/length(consumption_tax_rate_index))),1,sum)
subcategories$consumption_tax_base<-apply((zscores[consumption_tax_base_index]*(1/length(consumption_tax_base_index))),1,sum)
subcategories$consumption_tax_complexity<-apply((zscores[consumption_tax_complexity]*(1/length(consumption_tax_complexity))),1,sum)
subcategories$real_property_tax<-apply((zscores[real_property_index]*(1/length(real_property_index))),1,sum)
subcategories$wealth_taxes<-apply((zscores[wealth_taxes_index]*(1/length(wealth_taxes_index))),1,sum)
subcategories$capital_taxes<-apply((zscores[capital_taxes_index]*(1/length(capital_taxes_index))),1,sum)
subcategories$capital_gains_and_dividends<-apply((zscores[capital_gains_and_dividends_index]*(1/length(capital_gains_and_dividends_index))),1,sum)
subcategories$income_tax<-apply((zscores[income_tax_index]*(1/length(income_tax_index))),1,sum)
subcategories$income_tax_complexity<-apply((zscores[income_tax_complexity_index]*(1/length(income_tax_complexity_index))),1,sum)
subcategories$territorial<-apply((zscores[territorial_index]*(1/length(territorial_index))),1,sum)
subcategories$withholding_taxes<-apply((zscores[withholding_index]*(1/length(withholding_index))),1,sum)
subcategories$tax_treaties<-apply((zscores[tax_treaties_index]*(1/length(tax_treaties_index))),1,sum)
subcategories$international_regulations<-apply((zscores[international_regulations_index]*(1/length(international_regulations_index))),1,sum)

#alternate_ Scoring Technique

alternate_subcategories<-data.frame(country=alternate_scores$country,
                             year=alternate_scores$year)

alternate_subcategories$corporate_rate<-apply((alternate_scores[corporate_rate_index]*(1/length(corporate_rate_index))),1,sum)
alternate_subcategories$cost_recovery<-apply((alternate_scores[cost_recovery_index]*(1/length(cost_recovery_index))),1,sum)
alternate_subcategories$incentives<-apply((alternate_scores[incentives_index]*(1/length(incentives_index))),1,sum)
alternate_subcategories$consumption_tax_rate<-apply((alternate_scores[consumption_tax_rate_index]*(1/length(consumption_tax_rate_index))),1,sum)
alternate_subcategories$consumption_tax_base<-apply((alternate_scores[consumption_tax_base_index]*(1/length(consumption_tax_base_index))),1,sum)
alternate_subcategories$consumption_tax_complexity<-apply((alternate_scores[consumption_tax_complexity]*(1/length(consumption_tax_complexity))),1,sum)
alternate_subcategories$real_property_tax<-apply((alternate_scores[real_property_index]*(1/length(real_property_index))),1,sum)
alternate_subcategories$wealth_taxes<-apply((alternate_scores[wealth_taxes_index]*(1/length(wealth_taxes_index))),1,sum)
alternate_subcategories$capital_taxes<-apply((alternate_scores[capital_taxes_index]*(1/length(capital_taxes_index))),1,sum)
alternate_subcategories$capital_gains_and_dividends<-apply((alternate_scores[capital_gains_and_dividends_index]*(1/length(capital_gains_and_dividends_index))),1,sum)
alternate_subcategories$income_tax<-apply((alternate_scores[income_tax_index]*(1/length(income_tax_index))),1,sum)
alternate_subcategories$income_tax_complexity<-apply((alternate_scores[income_tax_complexity_index]*(1/length(income_tax_complexity_index))),1,sum)
alternate_subcategories$territorial<-apply((alternate_scores[territorial_index]*(1/length(territorial_index))),1,sum)
alternate_subcategories$withholding_taxes<-apply((alternate_scores[withholding_index]*(1/length(withholding_index))),1,sum)
alternate_subcategories$tax_treaties<-apply((alternate_scores[tax_treaties_index]*(1/length(tax_treaties_index))),1,sum)
alternate_subcategories$international_regulations<-apply((alternate_scores[international_regulations_index]*(1/length(international_regulations_index))),1,sum)

#Final Categories and Final Score with Ranks####
#Each category contains three subcategories

#Same thing as above
corporate_index<-c("corporate_rate","cost_recovery","incentives")
consumption_index<-c("consumption_tax_rate","consumption_tax_base","consumption_tax_complexity")
property_index<-c("real_property_tax","wealth_taxes","capital_taxes")
income_index<-c("capital_gains_and_dividends","income_tax","income_tax_complexity")
international_index<-c("territorial","withholding_taxes","tax_treaties","international_regulations")


categories<-data.frame(country=raw_data$country,
                       year=raw_data$year)

categories$corporate<-apply((subcategories[corporate_index]*(1/length(corporate_index))),1,sum)
categories$consumption<-apply((subcategories[consumption_index]*(1/length(consumption_index))),1,sum)
categories$property<-apply((subcategories[property_index]*(1/length(property_index))),1,sum)
categories$income<-apply((subcategories[income_index]*(1/length(income_index))),1,sum)
categories$international<-apply((subcategories[international_index]*(1/length(international_index))),1,sum)
categories$final<-apply((categories[3:7]*(1/length(categories[3:7]))),1,sum)

write.csv(subset(categories,categories$year==2020),file = paste(final_outputs,"categories_score.csv",sep=""),row.names=F)



#alternate_ Scoring method

alternate_categories<-data.frame(country=raw_data$country,
                          year=raw_data$year)

alternate_categories$corporate<-apply((alternate_subcategories[corporate_index]*(1/length(corporate_index))),1,sum)
alternate_categories$consumption<-apply((alternate_subcategories[consumption_index]*(1/length(consumption_index))),1,sum)
alternate_categories$property<-apply((alternate_subcategories[property_index]*(1/length(property_index))),1,sum)
alternate_categories$income<-apply((alternate_subcategories[income_index]*(1/length(income_index))),1,sum)
alternate_categories$international<-apply((alternate_subcategories[international_index]*(1/length(international_index))),1,sum)
alternate_categories$final<-apply((alternate_categories[3:7]*(1/length(categories[3:7]))),1,sum)

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

alternate_scale<-function(x){
  s<-apply(x[-1],2,function(x) {(x/(max(x))*100)})
  return(s)
}

#Rank Function

rank1<-function(x){
  ranks<-rank(-x,ties.method= "min")
  return(ranks)
}
write.csv(subset(subcategories,subcategories$year==2020),file = paste(final_outputs,"subcategories_z_score.csv",sep=""),row.names=F)


#Subcategory Scores####
subcategories<-data.frame(country=raw_data$country,
                           ddply(subcategories[-1],
                                 .(year),
                                 score2)
)



#Alt Subcategory Scores

#    alternate_subcategories<-data.frame(country=raw_data$country,
#                              ddply(alternate_subcategories[-1],
#                                    .(year),
#                                    alternate_scale)
#    )


#Add Ranks####

subcategories<-ddply(subcategories, 
                     .(year),
                     transform,
                     corporate_rate_rank = rank(-corporate_rate,ties.method = "min"),
                     cost_recovery_rank = rank(-cost_recovery,ties.method = "min"),
                     incentives_rank = rank(-incentives,ties.method = "min"),
                     consumption_tax_rate_rank = rank(-consumption_tax_rate,ties.method = "min"),
                     consumption_tax_base_rank = rank(-consumption_tax_base,ties.method = "min"),
                     consumption_tax_complexity_rank = rank(-consumption_tax_complexity,ties.method = "min"),
                     real_property_tax_rank = rank(-real_property_tax,ties.method = "min"),
                     wealth_taxes_rank = rank(-wealth_taxes,ties.method = "min"),
                     capital_taxes_rank = rank(-capital_taxes,ties.method = "min"),
                     capital_gains_and_dividends_rank = rank(-capital_gains_and_dividends,ties.method = "min"),
                     income_tax_rank = rank(-income_tax,ties.method = "min"),
                     income_tax_complexity_rank = rank(-income_tax_complexity,ties.method = "min"),
                     territorial_rank = rank(-territorial,ties.method = "min"),
                     withholding_taxes_rank = rank(-withholding_taxes,ties.method = "min"),
                     tax_treaties_rank = rank(-tax_treaties,ties.method = "min"),
                     international_regulations_rank = rank(-international_regulations,ties.method = "min")
)

#alternate_ Scoring method

alternate_subcategories<-ddply(alternate_subcategories, 
                        .(year),
                        transform,
                        corporate_rate_rank = rank(-corporate_rate,ties.method = "min"),
                        cost_recovery_rank = rank(-cost_recovery,ties.method = "min"),
                        incentives_rank = rank(-incentives,ties.method = "min"),
                        consumption_tax_rate_rank = rank(-consumption_tax_rate,ties.method = "min"),
                        consumption_tax_base_rank = rank(-consumption_tax_base,ties.method = "min"),
                        consumption_tax_complexity_rank = rank(-consumption_tax_complexity,ties.method = "min"),
                        real_property_tax_rank = rank(-real_property_tax,ties.method = "min"),
                        wealth_taxes_rank = rank(-wealth_taxes,ties.method = "min"),
                        capital_taxes_rank = rank(-capital_taxes,ties.method = "min"),
                        capital_gains_and_dividends_rank = rank(-capital_gains_and_dividends,ties.method = "min"),
                        income_tax_rank = rank(-income_tax,ties.method = "min"),
                        income_tax_complexity_rank = rank(-income_tax_complexity,ties.method = "min"),
                        territorial_rank = rank(-territorial,ties.method = "min"),
                        withholding_taxes_rank = rank(-withholding_taxes,ties.method = "min"),
                        tax_treaties_rank = rank(-tax_treaties,ties.method = "min"),
                        international_regulations_rank = rank(-international_regulations,ties.method = "min")
)


#Category Scores####

categories<-data.frame(country=raw_data$country,
                       ddply(categories[-1],
                       .(year),
                        score2)
)

#alternate_ Category Scores

#    alternate_categories<-data.frame(country=raw_data$country,
#                           ddply(alternate_categories[-1],
#                                 .(year),
#                                 alternate_scale)
#    )

#Add Ranks

categories<-ddply(categories, 
                  .(year),
                  transform,
                  corporate_rank = rank(-corporate,ties.method = "min"),
                  consumption_rank = rank(-consumption,ties.method = "min"),
                  property_rank = rank(-property,ties.method = "min"),
                  income_rank = rank(-income,ties.method = "min"),
                  international_rank = rank(-international,ties.method = "min"),
                  final_rank = rank(-final,ties.method = "min")                      
)


#alternate_ scoring method

alternate_categories<-ddply(alternate_categories, 
                     .(year),
                     transform,
                     corporate_rank = rank(-corporate,ties.method = "min"),
                     consumption_rank = rank(-consumption,ties.method = "min"),
                     property_rank = rank(-property,ties.method = "min"),
                     income_rank = rank(-income,ties.method = "min"),
                     international_rank = rank(-international,ties.method = "min"),
                     final_rank = rank(-final,ties.method = "min")                      
)

#Final files####
#Create the final two files. One for subcategory ranks, the other for final ranks. 

final_categories<-data.frame(country=zscores$country,
                            year=zscores$year)

for (x in 1:((length(categories)-2)/2)){
  final_categories[length(final_categories)+1]<-categories[x+8]
  final_categories[length(final_categories)+1]<-categories[x+2]
}

final_subcategories<-data.frame(country=zscores$country,
                               year=zscores$year)

for (x in 1:((length(subcategories)-2)/2)){
  final_subcategories[length(final_subcategories)+1]<-subcategories[x+((length(subcategories)-0)/2)+1]
  final_subcategories[length(final_subcategories)+1]<-subcategories[x+2]
}

#alternate_ Scoring Method:

alternate_final_categories<-data.frame(country=alternate_scores$country,
                               year=alternate_scores$year)

for (x in 1:((length(alternate_categories)-2)/2)){
  alternate_final_categories[length(alternate_final_categories)+1]<-alternate_categories[x+8]
  alternate_final_categories[length(alternate_final_categories)+1]<-alternate_categories[x+2]
}

alternate_final_subcategories<-data.frame(country=alternate_scores$country,
                                  year=alternate_scores$year)

for (x in 1:((length(alternate_subcategories)-2)/2)){
  alternate_final_subcategories[length(alternate_final_subcategories)+1]<-alternate_subcategories[x+((length(alternate_subcategories)-0)/2)+1]
  alternate_final_subcategories[length(alternate_final_subcategories)+1]<-alternate_subcategories[x+2]
}

#rm(zscores, categories, subcategories, alternate_scores, alternate_categories, alternate_subcategories)

final_categories<-merge(final_categories,iso_country_codes,by=c("country"))
final_subcategories<-merge(final_subcategories,iso_country_codes,by=c("country"))

final_2014<-final_categories[final_categories$year==2014,]
final_2015<-final_categories[final_categories$year==2015,]
final_2016<-final_categories[final_categories$year==2016,]
final_2017<-final_categories[final_categories$year==2017,]
final_2018<-final_categories[final_categories$year==2018,]
final_2019<-final_categories[final_categories$year==2019,]
final_2020<-final_categories[final_categories$year==2020,]

#Data Check####

check<-raw_data[raw_data$country == "Greece",]

#Checking Sensitivity####

#Does the normalization technique drive the results?
final_categories<-final_categories[order(final_categories$country,final_categories$year),]
alternate_final_categories<-alternate_final_categories[order(alternate_final_categories$country,alternate_final_categories$year),]

cor(alternate_final_categories$final[alternate_final_categories$year == 2020],final_categories$final[final_categories$year == 2020])


#not really. 98 percent correlation between the two

#Which Category drives the results the most?####

#normal scoring techniques:

cortest1<-final_categories[final_categories$year == 2020,]
subcortest1<-final_subcategories[final_subcategories$year == 2020,]
subcortest1<-cbind(subcortest1,cortest1[14])
cor(cortest1[c(4,6,8,10,12,14)])
categories_correl<-data.frame(cor(cortest1[c(4,6,8,10,12,14)]))
write.csv(categories_correl,paste(final_outputs,"categories_correlation.csv",sep=""))

subcategories_correl<-data.frame(cor(subcortest1[c(seq(4,34,2),37)]))
write.csv(subcategories_correl,paste(final_outputs,"subcategories_correlation.csv",sep=""))



#importance<-lm(cortest1$final ~ cortest1$corporate + cortest1$income + cortest1$consumption + cortest1$property + cortest1$international)
#calc.relimp(importance, rela= TRUE)
#alternative scoring techniques:

cortest2<-alternate_final_categories[alternate_final_categories$year == 2015,]
cor(cortest2[c(4,6,8,10,12,14)])     


#Order variables for easier working

names(final_categories)
final_categories<-final_categories[c("ISO_2","ISO_3","country","year",
                                     "final_rank","final",
                                     "corporate_rank","corporate",
                                     "income_rank","income",
                                     "consumption_rank","consumption",
                                     "property_rank","property",
                                     "international_rank","international")]




colnames(final_categories)<-c("ISO_2","ISO_3","Country","Year",
                              "Final Rank","Final Score",
                              "Corporate Rank","Corporate Score",
                              "Income Rank","Income Score",
                              "Consumption Rank","Consumption Score",
                              "Property Rank","Property Score",
                              "International Rank","International Score")

Australia<-final_categories[final_categories$Country=="Australia",]
Austria<-final_categories[final_categories$Country=="Austria",]
Belgium<-final_categories[final_categories$Country=="Belgium",]
Canada<-final_categories[final_categories$Country=="Canada",]
Chile<-final_categories[final_categories$Country=="Chile",]
Czech_Republic<-final_categories[final_categories$Country=="Czech Republic",]
Denmark<-final_categories[final_categories$Country=="Denmark",]
Estonia<-final_categories[final_categories$Country=="Estonia",]
Finland<-final_categories[final_categories$Country=="Finland",]
France<-final_categories[final_categories$Country=="France",]
Germany<-final_categories[final_categories$Country=="Germany",]
Greece<-final_categories[final_categories$Country=="Greece",]
Hungary<-final_categories[final_categories$Country=="Hungary",]
Iceland<-final_categories[final_categories$Country=="Iceland",]
Ireland<-final_categories[final_categories$Country=="Ireland",]
Israel<-final_categories[final_categories$Country=="Israel",]
Italy<-final_categories[final_categories$Country=="Italy",]
Japan<-final_categories[final_categories$Country=="Japan",]
Korea<-final_categories[final_categories$Country=="Korea",]
Latvia<-final_categories[final_categories$Country=="Latvia",]
Lithuania<-final_categories[final_categories$Country=="Lithuania",]
Luxembourg<-final_categories[final_categories$Country=="Luxembourg",]
Mexico<-final_categories[final_categories$Country=="Mexico",]
Netherlands<-final_categories[final_categories$Country=="Netherlands",]
New_Zealand<-final_categories[final_categories$Country=="New Zealand",]
Norway<-final_categories[final_categories$Country=="Norway",]
Poland<-final_categories[final_categories$Country=="Poland",]
Portugal<-final_categories[final_categories$Country=="Portugal",]
Slovak_Republic<-final_categories[final_categories$Country=="Slovak Republic",]
Slovenia<-final_categories[final_categories$Country=="Slovenia",]
Spain<-final_categories[final_categories$Country=="Spain",]
Sweden<-final_categories[final_categories$Country=="Sweden",]
Switzerland<-final_categories[final_categories$Country=="Switzerland",]
Turkey<-final_categories[final_categories$Country=="Turkey",]
United_Kingdom<-final_categories[final_categories$Country=="United Kingdom",]
United_States<-final_categories[final_categories$Country=="United States",]


#Changes from 2018 index
M <- merge(final_2019,final_2018,by="country")
#drop ISO variables
drop_iso<-names(M) %in% c("ISO_2.x","ISO_3.x","ISO_2.y","ISO_3.y")
M<-M[!drop_iso]

Changes <- M[,grepl("*\\.x$",names(M))] - M[,grepl("*\\.y$",names(M))]

Changes<-cbind(M[,1,drop=FALSE],Changes)

final_subcategories_2020<-subset(final_subcategories,year==2020)


write.csv(raw_data,paste(final_outputs,"raw_data_2020.csv",sep=""),row.names=F)
write.csv(final_2017, file = paste(final_outputs,"data_2017_run.csv",sep=""),row.names=F)
write.csv(final_2018, file = paste(final_outputs,"data_2018_run.csv",sep=""),row.names=F)
write.csv(final_2019, file = paste(final_outputs,"data_2019_run.csv",sep=""),row.names=F)
write.csv(final_2020, file = paste(final_outputs,"data_2020_run.csv",sep=""),row.names=F)

write.csv(final_subcategories_2020,paste(final_outputs,"subcategories_2020.csv",sep=""),row.names=F)
write.csv(final_categories,paste(final_outputs,"final_categories_2014_2020.csv",sep=""),row.names=F)

#initial results csv files####

write.csv(United_Kingdom, file = paste(UK_scenarios,"United_Kingdom.csv",sep=""),row.names=F)
