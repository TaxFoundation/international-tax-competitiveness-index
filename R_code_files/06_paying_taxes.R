#PWC Paying Taxes Data####

#Import data
pwc_paying_taxes <- read_excel(paste(source_data,"pwc_paying_taxes.xlsx",sep=""),
                               range = "B1:BH191")

#Rename variables
pwc_paying_taxes<-
  pwc_paying_taxes %>%
  rename(
     country = X__1,
     region = X__2,
     income = X__3,
     corporate_time_2018 = `2018`,
     labor_time_2018 = `2018__1`,
     consumption_time_2018 = `2018__2`,
     total_time_2018 = `2018__3`,
     profit_payments_2018 = `2018__4`,
     labor_payments_2018 = `2018__5`,
     other_payments_2018 = `2018__6`,
     total_payments_2018 = `2018__7`,
     corporate_time_2017 = `2017`,
     labor_time_2017 = `2017__1`,
     consumption_time_2017 = `2017__2`,
     total_time_2017 = `2017__3`,
     profit_payments_2017 = `2017__4`,
     labor_payments_2017 = `2017__5`,
     other_payments_2017 = `2017__6`,
     total_payments_2017 = `2017__7`,
     corporate_time_2016 = `2016`,
     labor_time_2016 = `2016__1`,
     consumption_time_2016 = `2016__2`,
     total_time_2016 = `2016__3`,
     profit_payments_2016 = `2016__4`,
     labor_payments_2016 = `2016__5`,
     other_payments_2016 = `2016__6`,
     total_payments_2016 = `2016__7`,
     corporate_time_2015 = `2015`,
     labor_time_2015 = `2015__1`,
     consumption_time_2015 = `2015__2`,
     total_time_2015 = `2015__3`,
     profit_payments_2015 = `2015__4`,
     labor_payments_2015 = `2015__5`,
     other_payments_2015 = `2015__6`,
     total_payments_2015 = `2015__7`,
     corporate_time_2014 = `2014`,
     labor_time_2014 = `2014__1`,
     consumption_time_2014 = `2014__2`,
     total_time_2014 = `2014__3`,
     profit_payments_2014 = `2014__4`,
     labor_payments_2014 = `2014__5`,
     other_payments_2014 = `2014__6`,
     total_payments_2014 = `2014__7`,
     corporate_time_2013 = `2013`,
     labor_time_2013 = `2013__1`,
     consumption_time_2013 = `2013__2`,
     total_time_2013 = `2013__3`,
     profit_payments_2013 = `2013__4`,
     labor_payments_2013 = `2013__5`,
     other_payments_2013 = `2013__6`,
     total_payments_2013 = `2013__7`,
     corporate_time_2012 = `2012`,
     labor_time_2012 = `2012__1`,
     consumption_time_2012 = `2012__2`,
     total_time_2012 = `2012__3`,
     profit_payments_2012 = `2012__4`,
     labor_payments_2012 = `2012__5`,
     other_payments_2012 = `2012__6`,
     total_payments_2012 = `2012__7`
  )

#Drop redundant row
pwc_paying_taxes <- pwc_paying_taxes[-c(1), ]

#Join with country names
pwc_paying_taxes<-merge(pwc_paying_taxes,iso_country_codes,by=c("country"),all=T)

#Subset for OECD countries
pwc_paying_taxes<-subset(pwc_paying_taxes,pwc_paying_taxes$ISO_3 %in% oecd_countries)

#Transpose data year by year####
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
