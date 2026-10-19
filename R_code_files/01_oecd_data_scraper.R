#OECD data scraper
####OECD Data Scraper####

#R's default download timeout is 60 seconds. The tax wedge query below returns about 2 MB
#and takes roughly 45 seconds on a good day, so it fails intermittently at the default.
#Set here as well as in 00_master_file.R so that running this script on its own works.
options(timeout = max(600, getOption("timeout")))

#Helper for the revenue share variables (corporate_other_rev, turnover_tax_rev,
#personal_other_rev). Those are ratios of two OECD revenue codes, so a country-year with
#no observation on either side cannot be computed and comes through as NA. Coercing every
#NA to zero would turn "not yet published" into "no such tax", which silently understates
#the most recent years. The rules applied here are:
#  - a country with no observation in any year has no such tax  -> zero throughout
#  - NAs at the end of a country's series are unpublished data   -> carry the last year
#    forward, but for at most max_carry years. Beyond that a missing series is more likely
#    to mean the tax is gone than that the data is late, so it falls to zero.
#  - leading and interior gaps are treated as no revenue         -> zero
fill_revenue_share <- function(df, value_col, country_col = "country", year_col = "year",
                               max_carry = 2) {
  df <- df[order(df[[country_col]], df[[year_col]]), ]
  for (cty in unique(df[[country_col]])) {
    rows <- which(df[[country_col]] == cty)
    v <- df[[value_col]][rows]
    if (all(is.na(v))) {
      v[] <- 0
    } else {
      last_obs <- max(which(!is.na(v)))
      if (last_obs < length(v)) {
        carry_to <- min(length(v), last_obs + max_carry)
        v[(last_obs + 1):carry_to] <- v[last_obs]
      }
      v[is.na(v)] <- 0
    }
    df[[value_col]][rows] <- v
  }
  df
}

#corporate_rate####

#corporate_rate<-get_dataset("Table_II1",filter= list(c(oecd_countries),c("COMB_CIT_RATE")), start_time = 2014)
#corporate_rate<-corporate_rate[c(2,3,5)]
#colnames(corporate_rate)<-c("country","corporate_rate","year")

corporate_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_CIT@DF_CIT,2.0", filter="AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE+DNK+EST+FIN+FRA+DEU+GRC+HUN+ISL+IRL+ISR+ITA+JPN+KOR+LVA+LTU+LUX+MEX+NLD+NZL+NOR+POL+PRT+SVK+SVN+ESP+SWE+CHE+TUR+GBR+USA.A..ST..S13...")
corporate_rate<-corporate_rate[c("ObsValue","REF_AREA","TIME_PERIOD")]
colnames(corporate_rate)<-c("corporate_rate","ISO_3","year")

corporate_rate$corporate_rate <- as.numeric(corporate_rate$corporate_rate)
corporate_rate$corporate_rate <- corporate_rate$corporate_rate/100

corporate_rate <- subset(corporate_rate, year >= 2014)

#Missing Colombia
missing_colombia <- c(0.35,"COL",2026)
corporate_rate <- rbind(corporate_rate, missing_colombia)

#Missing Israel
missing_israel <- c(0.23,"ISR",2026)
corporate_rate <- rbind(corporate_rate, missing_israel)

#Missing Turkey
missing_turkey <- c(0.25,"TUR",2026)
corporate_rate <- rbind(corporate_rate, missing_turkey)

write.csv(corporate_rate, file = paste(intermediate_outputs,"oecd_corporate_rate.csv",sep=""), row.names = FALSE)

#r_and_d_credit####

#r_and_d_credit <- get_dataset("RDSUB",filter= list(c(oecd_countries), c("SME","LARGE"), c("PROFITABLE", "LOSS-MAKING")), start_time = 2013)
#r_and_d_credit <- r_and_d_credit[c(1,2,3,4,6)]
#colnames(r_and_d_credit) <- c("country","r_and_d_credit","Profit", "Size", "year")
#r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
#r_and_d_credit$r_and_d_credit <- as.numeric(r_and_d_credit$r_and_d_credit)

#r_and_d_credit <- spread(r_and_d_credit,year,r_and_d_credit)

r_and_d_credit <- get_dataset("OECD.STI.STP,DSD_RDTAX@DF_RDSUB,1.0","TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE.A....")
r_and_d_credit <- r_and_d_credit[c(6,8,9,10,11)]
colnames(r_and_d_credit) <- c("r_and_d_credit","profit","ISO_3","size","year")
r_and_d_credit$year <- as.numeric(r_and_d_credit$year)
r_and_d_credit$r_and_d_credit <- as.numeric(r_and_d_credit$r_and_d_credit)
r_and_d_credit <- r_and_d_credit[!is.na(r_and_d_credit$year), ]

r_and_d_credit <- aggregate(r_and_d_credit ~ ISO_3 + year, data = r_and_d_credit, FUN = mean, na.rm = TRUE)
r_and_d_credit$year <- r_and_d_credit$year + 1

write.csv(r_and_d_credit, file = paste(intermediate_outputs,"oecd_r_and_d_credit.csv",sep=""), row.names = FALSE)


#top_income_rate####

#top_income_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("TOP_TRATE")), start_time = 2013)
#top_income_rate<-top_income_rate[c(1,2,6)]
#colnames(top_income_rate)<-c("country","top_income_rate","year")

top_income_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..TS_PIT..S13......")
top_income_rate<-top_income_rate[c(10,11,14)]
colnames(top_income_rate)<-c("top_income_rate","ISO_3","year")

top_income_rate$year<-as.numeric(top_income_rate$year)

#Chile increased its top personal income tax rate from 35% to 40% as of 2020
#top_income_rate[c('top_income_rate')][top_income_rate$country == "CHL" & top_income_rate$year >= 2019,] <- "40"

#Colombia increased its top personal income tax rate from 33% to 39% as of 2019 and it has not changed since
#top_income_rate[c('top_income_rate')][top_income_rate$country == "COL" & top_income_rate$year >= 2019,] <- "39"

top_income_rate$top_income_rate<-as.numeric(top_income_rate$top_income_rate)

#top_income_rate$year<-top_income_rate$year+1

top_income_rate$top_income_rate<-top_income_rate$top_income_rate/100

#all_in_rate

#all_in_rate<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("PER_ARATE")), start_time = 2013)
#all_in_rate<-all_in_rate[c(1,2,6)]
#colnames(all_in_rate)<-c("country","all_in_rate","year")

all_in_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..PIT_SSC_R_TH..S13......")
all_in_rate<-all_in_rate[c(10,11,14)]
colnames(all_in_rate)<-c("all_in_rate","ISO_3","year")


all_in_rate$year<-as.numeric(all_in_rate$year)
all_in_rate$all_in_rate<-as.numeric(all_in_rate$all_in_rate)

#all_in_rate$year<-all_in_rate$year+1
all_in_rate$all_in_rate<-all_in_rate$all_in_rate/100

#Create current year from prior year values
top_rate_current <- subset(top_income_rate, year == 2025)
top_rate_current$year <- 2026
top_income_rate <- rbind(top_income_rate, top_rate_current)

all_in_current <- subset(all_in_rate, year == 2025)
all_in_current$year <- 2026
all_in_rate <- rbind(all_in_rate, all_in_current)

#take the max of top rate or all-in rate
top_income_rate<-merge(top_income_rate,all_in_rate, by=c("ISO_3","year"))
top_income_rate$top_income_rate<-pmax(top_income_rate$top_income_rate,top_income_rate$all_in_rate)

#Latvia: the OECD table reports a top statutory PIT rate of 0 for 2025, so the pmax above
#falls back to the all-in rate alone (10.4%, essentially the employee social contribution).
#Latvia moved to a two-rate schedule on 1 January 2025: 25.5% up to EUR 105,300 and 33% above
#it, plus an additional 3% on income over EUR 200,000 (Deloitte Latvia Highlights 2026). The
#top marginal rate is therefore 36%. Surcharges are included in this variable elsewhere -
#Germany's 47.475% is 45% plus the 5.5% solidarity surcharge - so the 3% is included here too.
#Set after the pmax so the broken OECD value cannot override it. 2026 is affected as well
#because it is copied forward from 2025 above.
top_income_rate$top_income_rate[top_income_rate$ISO_3 == "LVA" &
                                  top_income_rate$year >= 2025] <- 0.36

#Missing Netherlands
#missing_netherlands <- c("NLD",2014,0.52,0.526)
#top_income_rate <- rbind(top_income_rate, missing_netherlands)

#threshold_top_income_rate####

#threshold<-get_dataset("Table_I7",filter= list(c(oecd_countries),c("THRESHOLD")), start_time = 2013)
#threshold<-threshold[c(1,2,6)]

threshold<-get_dataset("OECD.CTP.TPS,DSD_TAX_PIT@DF_PIT_TOP_EARN_THRESH,1.0", filter=".A..TS_PIT_TH..S13......")
threshold<-threshold[c(10,11,14)]
colnames(threshold)<-c("threshold_top_income_rate","ISO_3","year")

threshold$year<-as.numeric(threshold$year)

#Create current year from prior year values
threshold_current <- subset(threshold, year == 2025)
threshold_current$year <- 2026
threshold <- rbind(threshold, threshold_current)

#Latvia: as with the top rate above, the OECD table reports 0 for 2025 and 2026. The 36% top
#marginal rate applies above EUR 200,000, which is 12.12 times average income. Set after the
#rbind so both years are covered.
threshold$threshold_top_income_rate[threshold$ISO_3 == "LVA" &
                                      threshold$year >= 2025] <- 12.12

#threshold$year<-threshold$year+1

#Missing Netherlands
#missing_netherlands <- c(1.179464,"NLD",2014)
#threshold <- rbind(threshold, missing_netherlands)
#missing_netherlands <- c(1.221825,"NLD",2015)
#threshold <- rbind(threshold, missing_netherlands)

#tax_wedge####

#martax_wedge

martax_wedge<-get_dataset("OECD.CTP.TPS,DSD_TAX_WAGES_COMP@DF_TW_COMP,",".MR_TW_PE.PT_COS_LB.S_C0.AW167+AW67+AW100._Z.A")

martax_wedge<-martax_wedge[c(5,9,10,11)]
colnames(martax_wedge)<-c("income","martax_wedge","ISO_3","year")
martax_wedge$martax_wedge<-as.numeric(martax_wedge$martax_wedge)
martax_wedge<-spread(martax_wedge,year,martax_wedge)

martax_wedge2013<-aggregate(martax_wedge$`2013`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2014<-aggregate(martax_wedge$`2014`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2015<-aggregate(martax_wedge$`2015`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2016<-aggregate(martax_wedge$`2016`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2017<-aggregate(martax_wedge$`2017`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2018<-aggregate(martax_wedge$`2018`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2019<-aggregate(martax_wedge$`2019`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2020<-aggregate(martax_wedge$`2020`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2021<-aggregate(martax_wedge$`2021`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2022<-aggregate(martax_wedge$`2022`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2023<-aggregate(martax_wedge$`2023`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2024<-aggregate(martax_wedge$`2024`,by=list(martax_wedge$ISO_3),FUN=mean)
martax_wedge2025<-aggregate(martax_wedge$`2025`,by=list(martax_wedge$ISO_3),FUN=mean)


#avgtax_wedge

avgtax_wedge<-get_dataset("OECD.CTP.TPS,DSD_TAX_WAGES_COMP@DF_TW_COMP,",".AV_TW.PT_COS_LB.S_C0.AW167+AW67+AW100._Z.A")

avgtax_wedge<-avgtax_wedge[c(5,9,10,11)]
colnames(avgtax_wedge)<-c("income","avgtax_wedge","ISO_3","year")
avgtax_wedge$avgtax_wedge<-as.numeric(avgtax_wedge$avgtax_wedge)

avgtax_wedge<-spread(avgtax_wedge,year,avgtax_wedge)

avgtax_wedge2013<-aggregate(avgtax_wedge$`2013`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2014<-aggregate(avgtax_wedge$`2014`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2015<-aggregate(avgtax_wedge$`2015`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2016<-aggregate(avgtax_wedge$`2016`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2017<-aggregate(avgtax_wedge$`2017`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2018<-aggregate(avgtax_wedge$`2018`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2019<-aggregate(avgtax_wedge$`2019`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2020<-aggregate(avgtax_wedge$`2020`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2021<-aggregate(avgtax_wedge$`2021`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2022<-aggregate(avgtax_wedge$`2022`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2022<-aggregate(avgtax_wedge$`2022`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2023<-aggregate(avgtax_wedge$`2023`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2024<-aggregate(avgtax_wedge$`2024`,by=list(avgtax_wedge$ISO_3),FUN=mean)
avgtax_wedge2025<-aggregate(avgtax_wedge$`2025`,by=list(avgtax_wedge$ISO_3),FUN=mean)

countries<-avgtax_wedge2020$Group.1

tax_wedge2013<-martax_wedge2013$x/avgtax_wedge2013$x
tax_wedge2014<-martax_wedge2014$x/avgtax_wedge2014$x
tax_wedge2015<-martax_wedge2015$x/avgtax_wedge2015$x
tax_wedge2016<-martax_wedge2016$x/avgtax_wedge2016$x
tax_wedge2017<-martax_wedge2017$x/avgtax_wedge2017$x
tax_wedge2018<-martax_wedge2018$x/avgtax_wedge2018$x
tax_wedge2019<-martax_wedge2019$x/avgtax_wedge2019$x
tax_wedge2020<-martax_wedge2020$x/avgtax_wedge2020$x
tax_wedge2021<-martax_wedge2021$x/avgtax_wedge2021$x # Previously: tax_wedge2021<-martax_wedge2020$x/avgtax_wedge2021$x
tax_wedge2022<-martax_wedge2022$x/avgtax_wedge2022$x
tax_wedge2023<-martax_wedge2023$x/avgtax_wedge2023$x
tax_wedge2024<-martax_wedge2024$x/avgtax_wedge2024$x
tax_wedge2025<-martax_wedge2025$x/avgtax_wedge2025$x

tax_wedge<-data.frame(countries,tax_wedge2013,tax_wedge2014,tax_wedge2015,tax_wedge2016,tax_wedge2017,tax_wedge2018,tax_wedge2019,tax_wedge2020,tax_wedge2021,tax_wedge2022, tax_wedge2023, tax_wedge2024, tax_wedge2025)

colnames(tax_wedge)<-c("ISO_3","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025")
tax_wedge<-gather(tax_wedge,"year","tax_wedge","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025")
tax_wedge$year<-as.numeric(tax_wedge$year)
tax_wedge$year<-tax_wedge$year+1

tax_wedge[c('tax_wedge')][tax_wedge$ISO_3 == "COL" & tax_wedge$year >=2014,] <- 0

#Remove aggregates
tax_wedge <- tax_wedge[!tax_wedge$ISO_3 %in% c("EU22OECD", "OECD_REP"), ]

write.csv(tax_wedge, file = paste(intermediate_outputs,"oecd_taxwedge.csv",sep=""), row.names = FALSE)

#dividends_rate####

dividends_rate<-get_dataset("OECD.CTP.TPS,DSD_TAX_CIT@DF_CIT_DIVD_INCOME,1.0", filter="CHE+TUR+GBR+USA+SVK+SVN+ESP+SWE+MEX+NLD+NZL+NOR+POL+PRT+LVA+LTU+LUX+ISL+IRL+ISR+ITA+JPN+KOR+FIN+DNK+EST+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE.A.NPT.....")
dividends_rate<-dividends_rate[c(5,7,11)]
colnames(dividends_rate)<-c("dividends_rate","ISO_3","year")

dividends_rate$dividends_rate<-as.numeric(dividends_rate$dividends_rate)
dividends_rate$dividends_rate<-dividends_rate$dividends_rate/100

#Missing Slovakia
#missing_slovakia <- c(0.07,"SVK",2024)
#dividends_rate <- rbind(dividends_rate, missing_slovakia)
 
dividends_rate<-subset(dividends_rate,year>2013)

#Create current year from prior year values
dividends_rate_current <- subset(dividends_rate, year == 2025)
dividends_rate_current$year <- 2026
dividends_rate <- rbind(dividends_rate, dividends_rate_current)


#corporate_other_rev####
#Revenue is pulled as levels (USD) rather than as a share of GDP, because the
#variable is a share of corporate tax revenue: (1300 + 6100) / (1300 + 6100 + 1200).
#1300 and 6100 are siblings of 1200 in the OECD classification, not subsets of it,
#so the numerator has to be added into the denominator.
corporate_other_rev <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD",
                                   "TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE..S13.T_6100+T_1300+T_1200..USD.A")
corporate_other_rev<-corporate_other_rev[c(8,7,9,12)]
colnames(corporate_other_rev)<-c("country","corporate_other_rev","tax","year")
corporate_other_rev<-corporate_other_rev[corporate_other_rev$year >=2012,]

corporate_other_rev<-spread(corporate_other_rev,tax,corporate_other_rev)
corporate_other_rev$`1300`<-as.numeric(corporate_other_rev$`1300`)
corporate_other_rev$`6100`<-as.numeric(corporate_other_rev$`6100`)
corporate_other_rev$`1200`<-as.numeric(corporate_other_rev$`1200`)

#NAs are left in place here rather than coerced to zero, so that unpublished years stay
#distinguishable from years with genuinely no revenue. fill_revenue_share resolves them below.
#The numerator is NA only where neither of its two codes is reported.
corporate_num_parts <- corporate_other_rev[c("1300","6100")]
corporate_other_rev$numerator<-ifelse(rowSums(!is.na(corporate_num_parts)) == 0,
                                      NA,
                                      rowSums(corporate_num_parts, na.rm = TRUE))
corporate_other_rev$denominator<-corporate_other_rev$numerator+corporate_other_rev$`1200`
corporate_other_rev$corporate_other_rev<-ifelse(!is.na(corporate_other_rev$denominator) &
                                                  corporate_other_rev$denominator>0,
                                                corporate_other_rev$numerator/corporate_other_rev$denominator,
                                                NA)
corporate_other_rev<-corporate_other_rev[c("country","year","corporate_other_rev")]

corporate_other_rev<-subset(corporate_other_rev,country%in%oecd_countries)

corporate_other_rev$year<-as.numeric(corporate_other_rev$year)
corporate_other_rev$corporate_other_rev<-as.numeric(corporate_other_rev$corporate_other_rev)

#Add in Australia 2023 numbers
#Australia: 2024 data not available -> use 2023 data
missing_australia <- subset(corporate_other_rev, subset = country == "AUS" & year == "2023")
missing_australia[missing_australia$year == 2023, "year"] <- 2024
missing_australia$corporate_other_rev<-as.numeric(missing_australia$corporate_other_rev)

#Add in Japan 2023 numbers
#Japan: 2024 data not available -> use 2023 data
#missing_japan <- subset(corporate_other_rev, subset = country == "JPN" & year == "2023")
#missing_japan[missing_japan$year == 2023, "year"] <- 2024
#missing_japan$corporate_other_rev<-as.numeric(missing_japan$corporate_other_rev)

#combine
corporate_other_rev<-rbind(corporate_other_rev,missing_australia)
corporate_other_rev$year<-corporate_other_rev$year+2

corporate_other_rev<-fill_revenue_share(corporate_other_rev,"corporate_other_rev")



write.csv(corporate_other_rev, file = paste(intermediate_outputs,"oecd_corporate_other_rev.csv",sep=""), row.names = FALSE)
corporate_other_rev<-read.csv(paste(intermediate_outputs,"oecd_corporate_other_rev.csv",sep=""))

corporate_other_rev <- corporate_other_rev %>%
  rename(ISO_3 = country)

#turnover_tax_rev####
#Share of business tax revenue raised through turnover taxes: 5113 / (5113 + 1200).
#OECD code 5113 is "turnover and other general taxes on goods and services"
turnover_tax_rev <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD",
                                  "TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE..S13.T_5113+T_1200..USD.A")
turnover_tax_rev<-turnover_tax_rev[c(8,7,9,12)]
colnames(turnover_tax_rev)<-c("country","turnover_tax_rev","tax","year")
turnover_tax_rev<-turnover_tax_rev[turnover_tax_rev$year >=2012,]

turnover_tax_rev<-spread(turnover_tax_rev,tax,turnover_tax_rev)
turnover_tax_rev$`5113`<-as.numeric(turnover_tax_rev$`5113`)
turnover_tax_rev$`1200`<-as.numeric(turnover_tax_rev$`1200`)

#As for corporate_other_rev, NAs are left in place and resolved by fill_revenue_share below.
turnover_tax_rev$denominator<-turnover_tax_rev$`5113`+turnover_tax_rev$`1200`
turnover_tax_rev$turnover_tax_rev<-ifelse(!is.na(turnover_tax_rev$denominator) &
                                                turnover_tax_rev$denominator>0,
                                              turnover_tax_rev$`5113`/turnover_tax_rev$denominator,
                                              NA)
turnover_tax_rev<-turnover_tax_rev[c("country","year","turnover_tax_rev")]

turnover_tax_rev<-subset(turnover_tax_rev,country%in%oecd_countries)

turnover_tax_rev$year<-as.numeric(turnover_tax_rev$year)
turnover_tax_rev$turnover_tax_rev<-as.numeric(turnover_tax_rev$turnover_tax_rev)

#Australia: 2024 data not available -> use 2023 data, as for corporate_other_rev
missing_australia <- subset(turnover_tax_rev, subset = country == "AUS" & year == "2023")
missing_australia[missing_australia$year == 2023, "year"] <- 2024
missing_australia$turnover_tax_rev<-as.numeric(missing_australia$turnover_tax_rev)

turnover_tax_rev<-rbind(turnover_tax_rev,missing_australia)

#Two-year time lag, as for corporate_other_rev and personal_other_rev
turnover_tax_rev$year<-turnover_tax_rev$year+2

#Resolves the unpublished trailing years, Greece among them.
turnover_tax_rev<-fill_revenue_share(turnover_tax_rev,"turnover_tax_rev")

#Latvia is the one case where the carry-forward is wrong. The only item behind code 5113
#was the mandatory procurement component (Obligata iepirkuma komponente), an electricity
#levy that was phased out: EUR 148.9m in 2020, 117.7m in 2021, 17.6m in 2022 and nothing
#reported afterwards in the EU National Tax Lists. The trailing gap is a genuine zero, not
#unpublished data, so it is set back to zero here. Years below are index years, i.e. data
#year plus the two-year lag, so 2025 corresponds to data year 2023.
turnover_tax_rev$turnover_tax_rev[turnover_tax_rev$country == "LVA" &
                                        turnover_tax_rev$year >= 2025] <- 0

write.csv(turnover_tax_rev, file = paste(intermediate_outputs,"oecd_turnover_tax_rev.csv",sep=""), row.names = FALSE)
turnover_tax_rev<-read.csv(paste(intermediate_outputs,"oecd_turnover_tax_rev.csv",sep=""))

turnover_tax_rev <- turnover_tax_rev %>%
  rename(ISO_3 = country)

#personal_other_rev####
#As with corporate_other_rev, revenue is pulled as levels (USD) so the variable can
#be expressed as a share rather than as a percentage of GDP. Here 2400 (unallocable
#social security contributions) IS a subset of 2000 (total social security
#contributions), so the denominator is 2000 alone - adding the numerator back in
#would double count it.
personal_other_rev <- get_dataset("OECD.CTP.TPS,DSD_REV_COMP_OECD@DF_RSOECD",
                                   "TUR+GBR+USA+SVN+ESP+SWE+CHE+NLD+NZL+NOR+POL+PRT+SVK+ITA+JPN+KOR+LVA+LTU+LUX+MEX+ISL+IRL+ISR+DNK+EST+FIN+FRA+DEU+GRC+HUN+AUS+AUT+BEL+CAN+CHL+COL+CRI+CZE..S13.T_2400+T_2000..USD.A")
personal_other_rev<-personal_other_rev[c(8,7,9,12)]
colnames(personal_other_rev)<-c("country","personal_other_rev","tax","year")
personal_other_rev<-personal_other_rev[personal_other_rev$year >=2012,]

personal_other_rev<-subset(personal_other_rev,country%in%oecd_countries)

personal_other_rev<-spread(personal_other_rev,tax,personal_other_rev)
personal_other_rev$`2400`<-as.numeric(personal_other_rev$`2400`)
personal_other_rev$`2000`<-as.numeric(personal_other_rev$`2000`)

#As for the two corporate series, NAs are left in place and resolved by
#fill_revenue_share below.
personal_other_rev$personal_other_rev<-ifelse(!is.na(personal_other_rev$`2000`) &
                                                personal_other_rev$`2000`>0,
                                              personal_other_rev$`2400`/personal_other_rev$`2000`,
                                              NA)

personal_other_rev<-personal_other_rev[c("country","personal_other_rev","year")]

personal_other_rev$year<-as.numeric(personal_other_rev$year)

#Add in Australia 2023 numbers
#Australia: 2024 data not available -> use 2023 data
missing_australia <- subset(personal_other_rev, subset = country == "AUS" & year == "2023")
missing_australia[missing_australia$year == 2023, "year"] <- 2024
missing_australia$personal_other_rev<-as.numeric(missing_australia$personal_other_rev)

#Add in Japan 2023 numbers
#Japan: 2024 data not available -> use 2023 data
#missing_japan <- subset(personal_other_rev, subset = country == "JPN" & year == "2023")
#missing_japan[missing_japan$year == 2023, "year"] <- 2024
#missing_japan$personal_other_rev<-as.numeric(missing_japan$personal_other_rev)

#combine
personal_other_rev<-rbind(personal_other_rev,missing_australia)
personal_other_rev$year<-personal_other_rev$year+2

personal_other_rev<-fill_revenue_share(personal_other_rev,"personal_other_rev")

write.csv(personal_other_rev, file = paste(intermediate_outputs,"oecd_personal_other_rev.csv",sep=""), row.names = FALSE)
personal_other_rev<-read.csv(paste(intermediate_outputs,"oecd_personal_other_rev.csv",sep=""))

personal_other_rev <- personal_other_rev %>%
  rename(ISO_3 = country)

#End OECD data scraper#

#output####

# ISO_3 and country merge

OECDvars_data <- merge(corporate_rate, r_and_d_credit, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, top_income_rate, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, threshold, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, tax_wedge, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, dividends_rate, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, corporate_other_rev, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, turnover_tax_rev, by=c("ISO_3","year"))
OECDvars_data <- merge(OECDvars_data, personal_other_rev, by=c("ISO_3","year"))

#Drop all_in_rate, which is only used above to take the max against the top rate.
#Dropped by name rather than by position: every frame merged above already carries its
#final column name, so no positional renaming is needed.
OECDvars_data$all_in_rate <- NULL

OECDvars_data <- merge(OECDvars_data,iso_country_codes,by="ISO_3")

OECDvars_data <- OECDvars_data[c("ISO_2","ISO_3","country","year","corporate_rate","r_and_d_credit", "top_income_rate", "threshold_top_income_rate", "tax_wedge", "dividends_rate","corporate_other_rev","turnover_tax_rev","personal_other_rev")]

write.csv(OECDvars_data, file = paste(intermediate_outputs,"oecd_variables_data.csv",sep=""), row.names = FALSE)
