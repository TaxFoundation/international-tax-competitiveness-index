#PWC Paying Taxes Data####

#Import data
pwc_paying_taxes <- read_excel(paste(source_data,"pwc_paying_taxes.xlsx",sep=""),
                               range = "B1:BH191")

#Rename variables
pwc_paying_taxes<-
  pwc_paying_taxes %>%
  rename(
     country = ...1,
     region = ...2,
     income = ...3,
     corporate_time_2018 = `2018...4`,
     labor_time_2018 = `2018...5`,
     consumption_time_2018 = `2018...6`,
     total_time_2018 = `2018...7`,
     profit_payments_2018 = `2018...8`,
     labor_payments_2018 = `2018...9`,
     other_payments_2018 = `2018...10`,
     total_payments_2018 = `2018...11`,
     corporate_time_2017 = `2017...12`,
     labor_time_2017 = `2017...13`,
     consumption_time_2017 = `2017...14`,
     total_time_2017 = `2017...15`,
     profit_payments_2017 = `2017...16`,
     labor_payments_2017 = `2017...17`,
     other_payments_2017 = `2017...18`,
     total_payments_2017 = `2017...19`,
     corporate_time_2016 = `2016...20`,
     labor_time_2016 = `2016...21`,
     consumption_time_2016 = `2016...22`,
     total_time_2016 = `2016...23`,
     profit_payments_2016 = `2016...24`,
     labor_payments_2016 = `2016...25`,
     other_payments_2016 = `2016...26`,
     total_payments_2016 = `2016...27`,
     corporate_time_2015 = `2015...28`,
     labor_time_2015 = `2015...29`,
     consumption_time_2015 = `2015...30`,
     total_time_2015 = `2015...31`,
     profit_payments_2015 = `2015...32`,
     labor_payments_2015 = `2015...33`,
     other_payments_2015 = `2015...34`,
     total_payments_2015 = `2015...35`,
     corporate_time_2014 = `2014...36`,
     labor_time_2014 = `2014...37`,
     consumption_time_2014 = `2014...38`,
     total_time_2014 = `2014...39`,
     profit_payments_2014 = `2014...40`,
     labor_payments_2014 = `2014...41`,
     other_payments_2014 = `2014...42`,
     total_payments_2014 = `2014...43`,
     corporate_time_2013 = `2013...44`,
     labor_time_2013 = `2013...45`,
     consumption_time_2013 = `2013...46`,
     total_time_2013 = `2013...47`,
     profit_payments_2013 = `2013...48`,
     labor_payments_2013 = `2013...49`,
     other_payments_2013 = `2013...50`,
     total_payments_2013 = `2013...51`,
     corporate_time_2012 = `2012...52`,
     labor_time_2012 = `2012...53`,
     consumption_time_2012 = `2012...54`,
     total_time_2012 = `2012...55`,
     profit_payments_2012 = `2012...56`,
     labor_payments_2012 = `2012...57`,
     other_payments_2012 = `2012...58`,
     total_payments_2012 = `2012...59`
  )

#Drop redundant row
pwc_paying_taxes <- pwc_paying_taxes[-c(1), ]

#Join with country names
pwc_paying_taxes<-merge(pwc_paying_taxes,iso_country_codes,by=c("country"),all=T)

#Subset for OECD countries
pwc_paying_taxes<-subset(pwc_paying_taxes,pwc_paying_taxes$ISO_3 %in% oecd_countries)

#Transpose data year by year####
#2012####
pwc_paying_taxes_2012<-pwc_paying_taxes %>%
  select(country:income,corporate_time_2012:total_payments_2012,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2012:total_payments_2012)
pwc_paying_taxes_2012$year<-2012

pwc_paying_taxes_2012<-pwc_paying_taxes_2012%>%
  spread(variable,value)

pwc_paying_taxes_2012<-  pwc_paying_taxes_2012 %>%
  rename(corporate_time = corporate_time_2012,
         labor_time = labor_time_2012,
         consumption_time = consumption_time_2012,
         total_time = total_time_2012,
         profit_payments = profit_payments_2012,
         labor_payments = labor_payments_2012,
         other_payments = other_payments_2012,
         total_payments = total_payments_2012)

#2013####
pwc_paying_taxes_2013<-pwc_paying_taxes %>%
  select(country:income,corporate_time_2013:total_payments_2013,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2013:total_payments_2013)
pwc_paying_taxes_2013$year<-2013

pwc_paying_taxes_2013<-pwc_paying_taxes_2013%>%
  spread(variable,value)

pwc_paying_taxes_2013<-  pwc_paying_taxes_2013 %>%
  rename(corporate_time = corporate_time_2013,
         labor_time = labor_time_2013,
         consumption_time = consumption_time_2013,
         total_time = total_time_2013,
         profit_payments = profit_payments_2013,
         labor_payments = labor_payments_2013,
         other_payments = other_payments_2013,
         total_payments = total_payments_2013)

#2014####
pwc_paying_taxes_2014<-pwc_paying_taxes %>%
  select(country:income,corporate_time_2014:total_payments_2014,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2014:total_payments_2014)
pwc_paying_taxes_2014$year<-2014

pwc_paying_taxes_2014<-pwc_paying_taxes_2014%>%
  spread(variable,value)

pwc_paying_taxes_2014<-  pwc_paying_taxes_2014 %>%
  rename(corporate_time = corporate_time_2014,
         labor_time = labor_time_2014,
         consumption_time = consumption_time_2014,
         total_time = total_time_2014,
         profit_payments = profit_payments_2014,
         labor_payments = labor_payments_2014,
         other_payments = other_payments_2014,
         total_payments = total_payments_2014)



#2015####
pwc_paying_taxes_2015<-pwc_paying_taxes %>%
  select(country:income,corporate_time_2015:total_payments_2015,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2015:total_payments_2015)
pwc_paying_taxes_2015$year<-2015

pwc_paying_taxes_2015<-pwc_paying_taxes_2015%>%
  spread(variable,value)

pwc_paying_taxes_2015<-  pwc_paying_taxes_2015 %>%
  rename(corporate_time = corporate_time_2015,
         labor_time = labor_time_2015,
         consumption_time = consumption_time_2015,
         total_time = total_time_2015,
         profit_payments = profit_payments_2015,
         labor_payments = labor_payments_2015,
         other_payments = other_payments_2015,
         total_payments = total_payments_2015)

#2016####
pwc_paying_taxes_2016<-pwc_paying_taxes %>%
  select(country:income, corporate_time_2016:total_payments_2016,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2016:total_payments_2016)
pwc_paying_taxes_2016$year<-2016

pwc_paying_taxes_2016<-pwc_paying_taxes_2016%>%
  spread(variable,value)

pwc_paying_taxes_2016<-  pwc_paying_taxes_2016 %>%
  rename(corporate_time = corporate_time_2016,
         labor_time = labor_time_2016,
         consumption_time = consumption_time_2016,
         total_time = total_time_2016,
         profit_payments = profit_payments_2016,
         labor_payments = labor_payments_2016,
         other_payments = other_payments_2016,
         total_payments = total_payments_2016)

#2017####
pwc_paying_taxes_2017<-pwc_paying_taxes %>%
  select(country:income, corporate_time_2017:total_payments_2017,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2017:total_payments_2017)
pwc_paying_taxes_2017$year<-2017

pwc_paying_taxes_2017<-pwc_paying_taxes_2017%>%
  spread(variable,value)

pwc_paying_taxes_2017<-  pwc_paying_taxes_2017 %>%
  rename(corporate_time = corporate_time_2017,
         labor_time = labor_time_2017,
         consumption_time = consumption_time_2017,
         total_time = total_time_2017,
         profit_payments = profit_payments_2017,
         labor_payments = labor_payments_2017,
         other_payments = other_payments_2017,
         total_payments = total_payments_2017)

#2018####
pwc_paying_taxes_2018<-pwc_paying_taxes %>%
  select(country:total_payments_2018,ISO_2,ISO_3)%>%
  gather(variable,value,corporate_time_2018:total_payments_2018)
pwc_paying_taxes_2018$year<-2018

pwc_paying_taxes_2018<-pwc_paying_taxes_2018%>%
  spread(variable,value)

pwc_paying_taxes_2018<-  pwc_paying_taxes_2018 %>%
  rename(corporate_time = corporate_time_2018,
         labor_time = labor_time_2018,
         consumption_time = consumption_time_2018,
         total_time = total_time_2018,
         profit_payments = profit_payments_2018,
         labor_payments = labor_payments_2018,
         other_payments = other_payments_2018,
         total_payments = total_payments_2018)

#Join####
pwc_paying_taxes<-rbind(pwc_paying_taxes_2012,
                        pwc_paying_taxes_2013,
                        pwc_paying_taxes_2014,
                          pwc_paying_taxes_2015,
                          pwc_paying_taxes_2016,
                          pwc_paying_taxes_2017,
                          pwc_paying_taxes_2018)

pwc_paying_taxes<-pwc_paying_taxes[,-c(2:3,13:14)]


write.csv(pwc_paying_taxes, file = paste(intermediate_outputs,"pwc_paying_taxes.csv",sep=""), 
          row.names = FALSE)
