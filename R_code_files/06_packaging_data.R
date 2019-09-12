#Packaging Data

oecd_variables<-read_csv(paste(intermediate_outputs,"oecd_variables_data.csv",sep=""))
cost_recovery<-read_csv(paste(intermediate_outputs,"cost_recovery_data.csv",sep=""))
vat_data<-read_csv(paste(intermediate_outputs,"vat_data.csv",sep=""))
property_tax<-read_csv(paste(intermediate_outputs,"property_tax_data.csv",sep=""))
cfc_rules<-read_csv(paste(intermediate_outputs,"cfc_rules_data.csv",sep=""))


index_data2014<-read_csv(paste(source_data,"index_data_2014.csv",sep=""))
index_data2014$year<-2014

index_data2015<-read_csv(paste(source_data,"index_data_2015.csv",sep=""))
index_data2015$year<-2015

index_data2016<-read_csv(paste(source_data,"index_data_2016.csv",sep=""))
index_data2016$year<-2016

index_data2017<-read_csv(paste(source_data,"index_data_2017.csv",sep=""))
index_data2017$year<-2017

index_data2018<-read_csv(paste(source_data,"index_data_2018.csv",sep=""))
index_data2018$year<-2018

index_data2019<-read_csv(paste(source_data,"index_data_2019.csv",sep=""))
index_data2019$year<-2019

index_data_old<-rbind(index_data2014,index_data2015,index_data2016,index_data2017,index_data2018,index_data2019)


#Remove variables from index_data_old that are in OECD data
oecd_variables_list<-c("corporate_rate","top_income_rate", "threshold_top_income_rate", "tax_wedge","dividends_rate" )
index_data_old<-index_data_old[,!names(index_data_old) %in% oecd_variables_list]

#Join OECD data with index_data_old####

index_data_oecd_variables<-merge(index_data_old,oecd_variables,by=c("country","ISO_2","ISO_3","year"))


#Join cost recovery data with index_data2019####

cost_recovery_list<-c("machines_cost_recovery","buildings_cost_recovery", "intangibles_cost_recovery")

index_data_oecd_variables<-index_data_oecd_variables[,!names(index_data_oecd_variables) %in% cost_recovery_list]
index_data_cost_recovery_variables<-merge(index_data_oecd_variables,cost_recovery,by=c("ISO_2","ISO_3","country","year"))

#Join vat data with index_data_cost_recovery_variables####

#Remove variables from index_data_old that are in vat data

vat_list<-c("vat_rate","vat_threshold", "vat_base")
index_data_cost_recovery_variables<-index_data_cost_recovery_variables[,!names(index_data_cost_recovery_variables) %in% vat_list]

index_data_vat_variables<-merge(index_data_cost_recovery_variables,vat_data,by=c("ISO_2","ISO_3","country","year"))

#Join Property tax data with index_data_cost_recovery_variables####
property_tax_variables<-c("property_tax_collections")

#Adjust years in Property tax data to account for two year lag
property_tax$year<-property_tax$year+2
property_tax<-property_tax[c("ISO_3","country","year","property_tax_collections")]
index_data_vat_variables<-index_data_vat_variables[,!names(index_data_vat_variables) %in% property_tax_variables]
index_data_property_tax_variables<-merge(index_data_vat_variables,property_tax,by=c("ISO_3","country","year"))

#Join CFC rules data with index_data2019####
cfc_rules<-cfc_rules[-c(5:7)]

cfc_rules_list<-c("cfc_rules")
index_data_property_tax_variables<-index_data_property_tax_variables[,!names(index_data_property_tax_variables) %in% cfc_rules_list]

index_data_cfc_variables<-merge(index_data_property_tax_variables,cfc_rules,by=c("ISO_2","ISO_3","country","year"))



index_data_final<-index_data_cfc_variables
names(index_data_final)
#Reorder columns ####
index_data_final<-index_data_final[c("ISO_2","ISO_3","country","year",
                                   "corporate_rate","loss_carryback","loss_carryforward",
                                   "machines_cost_recovery","buildings_cost_recovery",
                                   "intangibles_cost_recovery","inventory","patent_box",
                                   "r_and_d_credit","corporate_time","profit_payments","other_payments",
                                   "top_income_rate","threshold_top_income_rate","tax_wedge",
                                   "labor_payments","labor_time","capital_gains_rate",
                                   "index_capital_gains","dividends_rate",
                                   "vat_rate","vat_threshold","vat_base","consumption_time",
                                   "property_tax", "property_tax_collections","net_wealth",
                                   "estate_or_inheritance_tax","transfer_tax","asset_tax",
                                   "capital_duties","financial_transaction_tax",
                                   "dividends_exemption","capital_gains_exemption","country_limitations",
                                   "dividends_withholding_tax","interest_withholding_tax",
                                   "royalties_withholding_tax","tax_treaties","cfc_rules",
                                   "thin_capitalization_rules")]



write.csv(subset(index_data_final,index_data_final$year==2014),file = paste(final_data,"final_index_data_2014.csv",sep=""),row.names=F)
write.csv(subset(index_data_final,index_data_final$year==2015),file = paste(final_data,"final_index_data_2015.csv",sep=""),row.names=F)
write.csv(subset(index_data_final,index_data_final$year==2016),file = paste(final_data,"final_index_data_2016.csv",sep=""),row.names=F)
write.csv(subset(index_data_final,index_data_final$year==2017),file = paste(final_data,"final_index_data_2017.csv",sep=""),row.names=F)
write.csv(subset(index_data_final,index_data_final$year==2018),file = paste(final_data,"final_index_data_2018.csv",sep=""),row.names=F)
write.csv(subset(index_data_final,index_data_final$year==2019),file = paste(final_data,"final_index_data_2019.csv",sep=""),row.names=F)
