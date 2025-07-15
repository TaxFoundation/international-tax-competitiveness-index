#output tables code
#Read in relevant spreadsheets

raw_data_2024 <- read_csv(paste(final_outputs,"raw_data_2025.csv",sep=""))

final_2018 <- read_csv(paste(final_outputs,"data_2018_run.csv",sep=""))
final_2019 <- read_csv(paste(final_outputs,"data_2019_run.csv",sep=""))
final_2020 <- read_csv(paste(final_outputs,"data_2020_run.csv",sep=""))
final_2021 <- read_csv(paste(final_outputs,"data_2021_run.csv",sep=""))
final_2022 <- read_csv(paste(final_outputs,"data_2022_run.csv",sep=""))
final_2023 <- read_csv(paste(final_outputs,"data_2023_run.csv",sep=""))
final_2024 <- read_csv(paste(final_outputs,"data_2024_run.csv",sep=""))
final_2025 <- read_csv(paste(final_outputs,"data_2025_run.csv",sep=""))

subcategories_2025 <- read_csv(paste(final_outputs,"subcategories_2025.csv",sep=""))

###Table 1 Results####
table_1_results <- final_2025

#Select variables
keep <- c("country","final_rank","final","corporate_rank","income_rank","consumption_rank","property_rank","cross_border_rank")
table_1_results <- table_1_results[keep]

#Sort by rank
table_1_results <- table_1_results[order(table_1_results$final_rank),]

#Format columns
table_1_results$final <- formatC(round(table_1_results$final,digits=1),format = "f",digits=1)


colnames(table_1_results) <- c("Country",
                             "Overall Rank",
                             "Overall Score",
                             "Corporate Tax Rank", 
                             "Individual Taxes Rank", 
                             "Consumption Taxes Rank", 
                             "Property Taxes Rank", 
                             "Cross-Border Tax Rules Rank")


write.csv(table_1_results,paste(final_outputs,"table_1_results.csv",sep=""),row.names=F)

###Table 2 Changes####
table_2_changes <- merge(final_2024,final_2025,by="country")

keep <- c("country","final_rank.x","final.x","final_rank.y","final.y")
table_2_changes <- table_2_changes[keep]

colnames(table_2_changes) <- c("country", "2024 Rank","2024 Score","2025 Rank","2025 Score")

#table_2_changes <- merge(final_2021,table_2_changes,by="country")
#keep <- c("country","final_rank","final","2022 Rank","2022 Score","2024 Rank","2024 Score")
#table_2_changes<-table_2_changes[keep]

colnames(table_2_changes)<-c("Country","2024 Rank","2024 Score","2025 Rank","2025 Score")

table_2_changes$'Change in Rank from 2024 to 2025'<-(table_2_changes$`2025 Rank`-table_2_changes$`2024 Rank`)*(-1)
table_2_changes$'Change in Score from 2024 to 2025'<-table_2_changes$`2025 Score`-table_2_changes$`2024 Score`

#Format Columns

table_2_changes$'2024 Score'<-formatC(round(table_2_changes$'2024 Score',digits=1),format = "f",digits=1)
table_2_changes$'2025 Score'<-formatC(round(table_2_changes$'2025 Score',digits=1),format = "f",digits=1)
table_2_changes$'Change in Score from 2024 to 2025'<-as.numeric(table_2_changes$'Change in Score from 2024 to 2025')
table_2_changes$'Change in Score from 2024 to 2025'<-formatC(round(table_2_changes$'Change in Score from 2024 to 2025',digits=1),format = "f",digits=1)

#Error in round(table_2_changes$"Change in Score from 2024 to 2025", digits = 1) :  non-numeric argument to mathematical function

write.csv(table_2_changes,paste(final_outputs,"table_2_changes.csv",sep=""),row.names=F)


###Table 3 Corporate####
table_3_corporate<-subcategories_2025
table_3_corporate<-merge(table_3_corporate,final_2025,by=c("country"))

keep<-c("country","corporate_rank","corporate","corporate_rate_rank","corporate_rate","cost_recovery_rank","cost_recovery","incentives_rank","incentives")
table_3_corporate<-table_3_corporate[keep]

colnames(table_3_corporate)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Cost Recovery Rank","Cost Recovery Score","Incentives/Complexity Rank","Incentives/Complexity Score")

#Format Columns

table_3_corporate$`Overall Score`<-formatC(round(table_3_corporate$`Overall Score`,digits=1),format = "f",digits=1)
table_3_corporate$`Rate Score`<-formatC(round(table_3_corporate$`Rate Score`,digits=1),format = "f",digits=1)
table_3_corporate$`Cost Recovery Score`<-formatC(round(table_3_corporate$`Cost Recovery Score`,digits=1),format = "f",digits=1)
table_3_corporate$`Incentives/Complexity Score`<-formatC(round(table_3_corporate$`Incentives/Complexity Score`,digits=1),format = "f",digits=1)

write.csv(table_3_corporate,paste(final_outputs,"table_3_corporate.csv",sep=""),row.names=F)


###Table 4 Individual####
table_4_individual<-subcategories_2025
table_4_individual<-merge(table_4_individual,final_2025,by=c("country"))

#names(table_4_individual)

keep<-c("country","income_rank","income","income_tax_rank","income_tax","income_tax_complexity_rank","income_tax_complexity","capital_gains_and_dividends_rank","capital_gains_and_dividends")
table_4_individual<-table_4_individual[keep]

colnames(table_4_individual)<-c("Country","Overall Rank","Overall Score","Income Tax Rank","Income Tax Score","Complexity Rank","Complexity Score", "Capital Gains/Dividends Rank","Capital Gains/Dividends Score")

table_4_individual$`Overall Score`<-formatC(round(table_4_individual$`Overall Score`,digits=1),format = "f",digits=1)
table_4_individual$`Income Tax Score`<-formatC(round(table_4_individual$`Income Tax Score`,digits=1),format = "f",digits=1)
table_4_individual$`Complexity Score`<-formatC(round(table_4_individual$`Complexity Score`,digits=1),format = "f",digits=1)
table_4_individual$`Capital Gains/Dividends Score`<-formatC(round(table_4_individual$`Capital Gains/Dividends Score`,digits=1),format = "f",digits=1)

write.csv(table_4_individual,paste(final_outputs,"table_4_individual.csv",sep=""),row.names=F)

###Table 5 Consumption####
table_5_consumption<-subcategories_2025
table_5_consumption<-merge(table_5_consumption,final_2025,by=c("country"))

#names(table_5_consumption)

keep<-c("country","consumption_rank","consumption","consumption_tax_rate_rank","consumption_tax_rate","consumption_tax_base_rank","consumption_tax_base")
table_5_consumption<-table_5_consumption[keep]

colnames(table_5_consumption)<-c("Country","Overall Rank","Overall Score", "Rate Rank","Rate Score","Base Rank","Base Score")

table_5_consumption$`Overall Score`<-formatC(round(table_5_consumption$`Overall Score`,digits=1),format = "f",digits=1)
table_5_consumption$`Rate Score`<-formatC(round(table_5_consumption$`Rate Score`,digits=1),format = "f",digits=1)
table_5_consumption$`Base Score`<-formatC(round(table_5_consumption$`Base Score`,digits=1),format = "f",digits=1)

write.csv(table_5_consumption,paste(final_outputs,"table_5_consumption.csv",sep=""),row.names=F)

###Table 6 Property####
table_6_property<-subcategories_2025
table_6_property<-merge(table_6_property,final_2025,by=c("country"))

#names(table_6_property)

keep<-c("country","property_rank","property","real_property_tax_rank","real_property_tax","wealth_taxes_rank","wealth_taxes","capital_taxes_rank","capital_taxes")
table_6_property<-table_6_property[keep]

colnames(table_6_property)<-c("Country","Overall Rank","Overall Score", "Real Property Taxes Rank","Real Property Taxes Score","Wealth/Estate Taxes Rank","Wealth/Estate Taxes Score","Capital/Transaction Taxes Rank","Capital/Transaction Taxes Score")

table_6_property$`Overall Score`<-formatC(round(table_6_property$`Overall Score`,digits=1),format = "f",digits=1)
table_6_property$`Real Property Taxes Score`<-formatC(round(table_6_property$`Real Property Taxes Score`,digits=1),format = "f",digits=1)
table_6_property$`Wealth/Estate Taxes Score`<-formatC(round(table_6_property$`Wealth/Estate Taxes Score`,digits=1),format = "f",digits=1)
table_6_property$`Capital/Transaction Taxes Score`<-formatC(round(table_6_property$`Capital/Transaction Taxes Score`,digits=1),format = "f",digits=1)

write.csv(table_6_property,paste(final_outputs,"table_6_property.csv",sep=""),row.names=F)


###Table 7 Cross-Border####
table_7_cross_border<-subcategories_2025
table_7_cross_border<-merge(table_7_cross_border,final_2025,by=c("country"))

#names(table_7_cross_border)

keep<-c("country","cross_border_rank","cross_border","territorial_rank","territorial","withholding_taxes_rank","withholding_taxes","tax_treaties_rank", "tax_treaties", "international_regulations_rank","international_regulations")
table_7_cross_border<-table_7_cross_border[keep]

colnames(table_7_cross_border)<-c("Country","Overall Rank","Overall Score", "Div/Cap Gains Exemption Rank","Div/Cap Gains Exemption Score","Withholding Taxes Rank","Withholding Taxes Score","Tax Treaties Rank","Tax Treaties Score","Anti-Tax Avoidance Rank","Anti-Tax Avoidance Score")

table_7_cross_border$`Overall Score`<-formatC(round(table_7_cross_border$`Overall Score`,digits=1),format = "f",digits=1)
table_7_cross_border$`Div/Cap Gains Exemption Score`<-formatC(round(table_7_cross_border$`Div/Cap Gains Exemption Score`,digits=1),format = "f",digits=1)
table_7_cross_border$`Withholding Taxes Score`<-formatC(round(table_7_cross_border$`Withholding Taxes Score`,digits=1),format = "f",digits=1)
table_7_cross_border$`Tax Treaties Score`<-formatC(round(table_7_cross_border$`Tax Treaties Score`,digits=1),format = "f",digits=1)
table_7_cross_border$`Anti-Tax Avoidance Score`<-formatC(round(table_7_cross_border$`Anti-Tax Avoidance Score`,digits=1),format = "f",digits=1)

write.csv(table_7_cross_border,paste(final_outputs,"table_7_cross_border.csv",sep=""),row.names=F)


###Table A Corporate####

#Raw Data
table_a_corporate_raw<-subset(raw_data_2024,raw_data_2024$year==2024)

keep<-c("country",
        "corporate_rate",
        "loss_carryback",
        "loss_carryforward",
        "machines_cost_recovery",
        "buildings_cost_recovery",
        "intangibles_cost_recovery",
        "inventory",
        "allowance_corporate_equity",
        "patent_box",
        "r_and_d_credit",
        "digital_services_tax",
        "corporate_alt_minimum",
        "corporate_surtax",
        "corporate_other_rev")

table_a_corporate_raw<-table_a_corporate_raw[keep]

table_a_corporate_raw <- table_a_corporate_raw[order(table_a_corporate_raw$country),]


#Text Data
table_a_corporate_text<-read_csv(paste(source_data,"table_a_corporate.csv",sep=""))
colnames(table_a_corporate_text)<-names(table_a_corporate_raw)
table_a_corporate_text<-table_a_corporate_text[2:39,]


#Replace raw data with text data for select columns
replace<-c("loss_carryback","loss_carryforward","inventory","allowance_corporate_equity")
table_a_corporate_text<-table_a_corporate_text[replace]
table_a_corporate<-table_a_corporate_raw[,!names(table_a_corporate_raw) %in% replace]
table_a_corporate<-cbind(table_a_corporate,table_a_corporate_text)

table_a_corporate<-table_a_corporate[c("country","corporate_rate",
                                     "loss_carryback",
                                     "loss_carryforward",
                                     "machines_cost_recovery",
                                     "buildings_cost_recovery",
                                     "intangibles_cost_recovery",
                                     "inventory",
                                     "allowance_corporate_equity",
                                     "patent_box",
                                     "r_and_d_credit",
                                     "digital_services_tax",
                                     "corporate_alt_minimum",
                                     "corporate_surtax",
                                     "corporate_other_rev")]



#Format variables
#corporate_rate
table_a_corporate$corporate_rate<-table_a_corporate$corporate_rate*100
table_a_corporate$corporate_rate<-paste((formatC(round(table_a_corporate$corporate_rate,digits=1),format = "f",digits=1)),"%",sep="")

#machines_cost_recovery
table_a_corporate$machines_cost_recovery<-table_a_corporate$machines_cost_recovery*100
table_a_corporate$machines_cost_recovery<-paste((formatC(round(table_a_corporate$machines_cost_recovery,digits=1),format = "f",digits=1)),"%",sep="")

#buildings_cost_recovery
table_a_corporate$buildings_cost_recovery<-table_a_corporate$buildings_cost_recovery*100
table_a_corporate$buildings_cost_recovery<-paste((formatC(round(table_a_corporate$buildings_cost_recovery,digits=1),format = "f",digits=1)),"%",sep="")

#intangibles_cost_recovery
table_a_corporate$intangibles_cost_recovery<-table_a_corporate$intangibles_cost_recovery*100
table_a_corporate$intangibles_cost_recovery<-paste((formatC(round(table_a_corporate$intangibles_cost_recovery,digits=1),format = "f",digits=1)),"%",sep="")

#Implied tax subsidy rate on R&D expenditure
table_a_corporate$r_and_d_credit<-paste((formatC(round(table_a_corporate$r_and_d_credit,digits=2),format = "f",digits=2)),sep="")

#patent_box
table_a_corporate$patent_box<-if_else(table_a_corporate$patent_box==1,"Yes","No")

#digital_services_tax
table_a_corporate$digital_services_tax<-if_else(table_a_corporate$digital_services_tax==1,"Yes","No")

#corporate_alt_minimum
table_a_corporate$corporate_alt_minimum<-formatC(round(table_a_corporate$corporate_alt_minimum,digits=0),format = "f",digits=0)

#corporate_surtax
table_a_corporate$corporate_surtax<-if_else(table_a_corporate$corporate_surtax==1,"Yes","No")

#corporate_other_rev
table_a_corporate$corporate_other_rev<-paste(formatC(round(table_a_corporate$corporate_other_rev,digits=1),format = "f",digits=1),"%",sep="")


headers<-c("",
           "Corporate Rate",
           "Cost Recovery",
           "",
           "",
           "",
           "",
           "",
           "",
           "Tax Incentives and Complexity","","","","","")
columns<-c("Country",
           "Top Marginal Corporate Tax Rate",
           "Loss Carryback (Number of Years)",
           "Loss Carryforward (Number of Years)",
           "Machinery",
           "Industrial Buildings",
           "Intangibles",
           "Inventory (Best Available)",
           "Allowance for Corporate Equity (Rate and Base)",
           "Patent Box",
           "Implied Tax Subsidy Rates on R&D Expenditures",
           "Digital Services Tax",
           "Corporate Complexity (Number of separate rates or alternative minimum taxes)",
           "Corporate Complexity (Surtax on corporate income)",
           "Corporate Complexity (Share of revenue collected on income from non-standard income taxes)")

table_a_corporate<-rbind(headers,columns,table_a_corporate)

write.csv(table_a_corporate,paste(final_outputs,"table_a_corporate.csv",sep=""),row.names = F)



#Table B Individual####

#Raw Data
table_b_individual_raw<-subset(raw_data_2024,raw_data_2024$year==2024)
#names(table_b_individual_raw)

keep<-c("country","top_income_rate",
        "threshold_top_income_rate",
        "tax_wedge",
        "personal_surtax",
        "personal_other_rev",
        "capital_gains_rate",
        "dividends_rate")
table_b_individual<-table_b_individual_raw[keep]

table_b_individual <- table_b_individual[order(table_b_individual$country),]


#Format variables
#top_income_rate
table_b_individual$top_income_rate<-table_b_individual$top_income_rate*100
table_b_individual$top_income_rate<-paste((formatC(round(table_b_individual$top_income_rate,digits=1),format = "f",digits=1)),"%",sep="")

#threshold_top_income_rate
table_b_individual$threshold_top_income_rate<-(formatC(round(table_b_individual$threshold_top_income_rate,digits=1),format = "f",digits=1))

#tax_wedge
table_b_individual$tax_wedge<-(formatC(round(table_b_individual$tax_wedge,digits=1),format = "f",digits=1))

#personal_surtax
table_b_individual$personal_surtax<-if_else(table_b_individual$personal_surtax==1,"Yes","No")

#personal_other_rev
table_b_individual$personal_other_rev<-as.numeric(table_b_individual$personal_other_rev)
table_b_individual$personal_other_rev<-paste(formatC(round(table_b_individual$personal_other_rev,digits=0),format = "f",digits=0),"%",sep="")

#capital_gains_rate
table_b_individual$capital_gains_rate<-table_b_individual$capital_gains_rate*100
table_b_individual$capital_gains_rate<-paste((formatC(round(table_b_individual$capital_gains_rate,digits=1),format = "f",digits=1)),"%",sep="")

#dividends_rate
table_b_individual$dividends_rate<-table_b_individual$dividends_rate*100
table_b_individual$dividends_rate<-paste((formatC(round(table_b_individual$dividends_rate,digits=1),format = "f",digits=1)),"%",sep="")

headers<-c("",
           "Ordinary Income Taxes and Payroll Taxes",
           "",
           "",
           "Income Tax Complexity",
           "",
           "Capital Gains/Dividends",
           "",
           "")
columns<-c("Country",
           "Top Personal Income Tax Rate",
           "Top Income Tax Rate Threshold (a)",
           "Ratio of Marginal to Average Tax Wedge",
           "Income Tax Complexity (Surtax on personal income)",
           "Income Tax Complexity (Share of revenue collected through non-standard social security and payroll taxes) (c)",
           "Top Marginal Capital Gains Tax Rate (b)",
           "Top Marginal Dividends Tax Rate (b)")
notes_1<-c("Notes:",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_2<-c("(a) Multiple of the average income at which the highest tax bracket applies, in U.S. dollars in Purchasing Power Parity (PPP).",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_3<-c("(b) After any imputation, credit, or offset. Includes surtaxes.",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
table_b_individual<-rbind(headers,columns,table_b_individual,notes_1,notes_2,notes_3)

write.csv(table_b_individual,paste(final_outputs,"table_b_individual.csv",sep=""),row.names = F)


#Table C Consumption####
#Raw Data
table_c_consumption_raw<-subset(raw_data_2024,raw_data_2024$year==2024)
#names(table_c_consumption_raw)

keep<-c("country","vat_rate",
        "vat_threshold",
        "vat_base")
table_c_consumption<-table_c_consumption_raw[keep]

table_c_consumption <- table_c_consumption[order(table_c_consumption$country),]

#Format variables
#vat_rate
table_c_consumption$vat_rate<-paste((formatC(round(table_c_consumption$vat_rate,digits=1),format = "f",digits=1)),"%",sep="")

#vat_threshold
table_c_consumption$vat_threshold<-dollar(table_c_consumption$vat_threshold,largest_with_cents = 1)

#vat_base
table_c_consumption$vat_base<-table_c_consumption$vat_base*100
table_c_consumption$vat_base<-paste((formatC(round(table_c_consumption$vat_base,digits=1),format = "f",digits=1)),"%",sep="")

#fix US and Canada to add footnote markers
table_c_consumption$vat_rate[4]<-paste0(table_c_consumption$vat_rate[4]," (b)")
table_c_consumption$vat_rate[38]<-paste0(table_c_consumption$vat_rate[38]," (c)")

headers<-c("",
           "Consumption Tax Rate",
           "Consumption Tax Base",
           "")
columns<-c("Country",
           "VAT/Sales Tax Rate",
           "VAT/Sales Tax Threshold (a)",
           "VAT/Sales Tax Base as a Percent of Total Consumption")
notes_1<-c("Notes:",
           "",
           "",
           "")

notes_2<-c("(a) In U.S. dollars (PPP).",
           "",
           "",
           "")

notes_3<-c("(b) The Canadian rate is the average of the total sales tax rate for the provinces and includes Goods and Services Tax, Provincial Sales Tax, and Retail Sales Tax where applicable.",
           "",
           "",
           "")
notes_4<-c("(c) The United States' rate is the combined weighted average state and local sales tax rate.",
           "",
           "",
           "")
table_c_consumption<-rbind(headers,columns,table_c_consumption,notes_1,notes_2,notes_3,notes_4)

write.csv(table_c_consumption,paste(final_outputs,"table_c_consumption.csv",sep=""),row.names = F)

#Table D Property####
#Raw Data
table_d_property_raw<-subset(raw_data_2024,raw_data_2024$year==2024)
#names(table_d_property_raw)

keep<-c("country","property_tax", 
        "property_tax_collections",
        "net_wealth",
        "estate_or_inheritance_tax",
        "transfer_tax",
        "asset_tax",
        "capital_duties",
        "financial_transaction_tax")

table_d_property_raw<-table_d_property_raw[keep]
table_d_property_raw$property_taxes_deductible<-if_else(table_d_property_raw$property_tax==0.5,1,0)

table_d_property_raw <- table_d_property_raw[order(table_d_property_raw$country),]


#Text Data
table_d_property_text<-read_csv(paste(source_data,"table_d_property.csv",sep=""))


colnames(table_d_property_text)<-c("country","property_tax",
                                  "property_taxes_deductible",
                                  "property_tax_collections",
                                  "net_wealth",
                                  "estate_or_inheritance_tax",
                                  "transfer_tax",
                                  "asset_tax",
                                  "capital_duties",
                                  "financial_transaction_tax")
table_d_property_text<-table_d_property_text[2:39,]


#Replace raw data with text data for select columns
replace<-c("property_tax","net_wealth","estate_or_inheritance_tax","transfer_tax","asset_tax")
table_d_property_text<-table_d_property_text[replace]
table_d_property<-table_d_property_raw[,!names(table_d_property_raw) %in% replace]
table_d_property<-cbind(table_d_property,table_d_property_text)

table_d_property<-table_d_property[c("country","property_tax", 
                                   "property_taxes_deductible",
                                   "property_tax_collections",
                                   "net_wealth",
                                   "estate_or_inheritance_tax",
                                   "transfer_tax",
                                   "asset_tax",
                                   "capital_duties",
                                   "financial_transaction_tax")]

#Format variables
#property_taxes_deductible
table_d_property$property_taxes_deductible<-if_else(table_d_property$property_taxes_deductible==1,"Yes","No")

#property_tax_collections
table_d_property$property_tax_collections<-paste((formatC(round(table_d_property$property_tax_collections,digits=1),format = "f",digits=1)),"%",sep="")

#capital_duties
table_d_property$capital_duties<-if_else(table_d_property$capital_duties==1,"Yes","No")

#financial_transaction_tax
table_d_property$financial_transaction_tax<-if_else(table_d_property$financial_transaction_tax==1,"Yes","No")


headers<-c("",
           "Real Property Taxes",
           "",
           "",
           "Wealth/Estate Taxes",
           "",
           "Capital/Transaction Taxes",
           "",
           "",
           "")

columns<-c("Country",
           "Real Property or Land Tax",
           "Real Property Taxes Deductible",
           "Real Property Taxes as % of Capital Stock",
           "Wealth Tax",
           "Estate/Inheritance Tax",
           "Transfer Taxes",
           "Asset Taxes",
           "Capital Duties",
           "Financial Transaction Tax")
notes_1<-c("Notes:",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_2<-c("(a) Applies to some real estate (vacation homes).",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")

notes_3<-c("(b) Tax on the imputed rent of properties. Applies to machinery.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_5<-c("(c) The Land Appreciation Tax is levied like a capital gains tax on the sale of property.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")
notes_6<-c("(d) The purchaser of real property is subject to a purchase tax.",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "",
           "")



table_d_property<-rbind(headers,columns,table_d_property,notes_1,notes_2,notes_3,notes_4,notes_5,notes_6)

write.csv(table_d_property,paste(final_outputs,"table_d_property.csv",sep=""),row.names = F)


#Table E Cross-Border####
#Raw Data
table_e_cross_border_raw<-subset(raw_data_2024,raw_data_2024$year==2024)

keep<-c("country",
        "dividends_exemption",
        "capital_gains_exemption",
        "country_limitations",
        "dividends_withholding_tax",
        "interest_withholding_tax",
        "royalties_withholding_tax",
        "tax_treaties",
        "cfc_rules",
        "thin_capitalization_rules",
        "minimum_tax")
table_e_cross_border_raw<-table_e_cross_border_raw[keep]
table_e_cross_border_raw$cfc_income<-table_e_cross_border_raw$cfc_rules
table_e_cross_border_raw$cfc_exemption<-table_e_cross_border_raw$cfc_rules

table_e_cross_border_raw <- table_e_cross_border_raw[order(table_e_cross_border_raw$country),]

#Text Data
table_e_cross_border_text<-read_csv(paste(source_data,"table_e_cross_border.csv",sep=""))


colnames(table_e_cross_border_text)<-c("country",
                                       "dividends_exemption",
                                       "capital_gains_exemption",
                                       "country_limitations",
                                       "dividends_withholding_tax",
                                       "interest_withholding_tax",
                                       "royalties_withholding_tax",
                                       "tax_treaties",
                                       "cfc_rules",
                                       "cfc_exemption",
                                       "cfc_income",
                                       "thin_capitalization_rules",
                                       "minimum_tax")
table_e_cross_border_text<-table_e_cross_border_text[2:39,]


#Replace raw data with text data for select columns
replace<-c("country_limitations","cfc_rules","cfc_income","cfc_exemption","thin_capitalization_rules")
table_e_cross_border_text<-table_e_cross_border_text[replace]
table_e_cross_border<-table_e_cross_border_raw[,!names(table_e_cross_border_raw) %in% replace]
table_e_cross_border<-cbind(table_e_cross_border,table_e_cross_border_text)

table_e_cross_border<-table_e_cross_border[c("country",
                                             "dividends_exemption",
                                             "capital_gains_exemption",
                                             "country_limitations",
                                             "dividends_withholding_tax",
                                             "interest_withholding_tax",
                                             "royalties_withholding_tax",
                                             "tax_treaties",
                                             "cfc_rules",
                                             "cfc_income",
                                             "cfc_exemption",
                                             "thin_capitalization_rules",
                                             "minimum_tax")]

#Format variables
#dividends_exemption
table_e_cross_border$dividends_exemption<-table_e_cross_border$dividends_exemption*100
table_e_cross_border$dividends_exemption<-paste((formatC(round(table_e_cross_border$dividends_exemption,digits=1),format = "f",digits=1)),"%",sep="")

#capital_gains_exemption
table_e_cross_border$capital_gains_exemption<-table_e_cross_border$capital_gains_exemption*100
table_e_cross_border$capital_gains_exemption<-paste((formatC(round(table_e_cross_border$capital_gains_exemption,digits=1),format = "f",digits=1)),"%",sep="")

#dividends_withholding_tax
table_e_cross_border$dividends_withholding_tax<-table_e_cross_border$dividends_withholding_tax*100
table_e_cross_border$dividends_withholding_tax<-paste((formatC(round(table_e_cross_border$dividends_withholding_tax,digits=1),format = "f",digits=1)),"%",sep="")

#interest_withholding_tax
table_e_cross_border$interest_withholding_tax<-table_e_cross_border$interest_withholding_tax*100
table_e_cross_border$interest_withholding_tax<-paste((formatC(round(table_e_cross_border$interest_withholding_tax,digits=1),format = "f",digits=1)),"%",sep="")

#royalties_withholding_tax
table_e_cross_border$royalties_withholding_tax<-table_e_cross_border$royalties_withholding_tax*100
table_e_cross_border$royalties_withholding_tax<-paste((formatC(round(table_e_cross_border$royalties_withholding_tax,digits=1),format = "f",digits=1)),"%",sep="")

#minimum_tax
table_e_cross_border$minimum_tax <- case_when(
  table_e_cross_border$minimum_tax == 1 ~ "Income Inclusion Rule and Untertaxed Profits Rule",
  table_e_cross_border$minimum_tax == 0.5 ~ "Income Inclusion Rule",
  table_e_cross_border$minimum_tax == 0 ~ "None",
  TRUE ~ NA_character_  # Handles any other cases, returning NA)
)

#US GILTI and BEAT
table_e_cross_border$minimum_tax[table_e_cross_border$country=="United States"] <- "GILTI and BEAT"

headers<-c("",
           "Participation Exemption",
           "",
           "",
           "Withholding Taxes",
           "",
           "",
           "Tax Treaties",
           "Anti-Tax Avoidance Rules",
           "",
           "",
           "",
           "")

columns<-c("Country",
           "Dividend Exemption",
           "Capital Gains Exemption",
           "Country Limitations",
           "Dividend Withholding Tax",
           "Interest Withholding Tax",
           "Royalties Withholding Tax",
           "Number of Tax Treaties",
           "Controlled Foreign Corporation Rules",
           "Controlled Foreign Corporation Rules: Income",
           "Controlled Foreign Corporation Rules: Exemptions",
           "Interest Deduction Limitations",
           "Global Minimum Tax Provisions")

table_e_cross_border<-rbind(headers,columns,table_e_cross_border)

write.csv(table_e_cross_border,paste(final_outputs,"table_e_cross_border.csv",sep=""),row.names = F)
