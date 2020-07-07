#CFC Rules Model
cfc_rules_2014 <- read_csv(paste(source_data,"cfc_rules_2014.csv",sep=""))
cfc_rules_2015 <- read_csv(paste(source_data,"cfc_rules_2015.csv",sep=""))
cfc_rules_2016 <- read_csv(paste(source_data,"cfc_rules_2016.csv",sep=""))
cfc_rules_2017 <- read_csv(paste(source_data,"cfc_rules_2017.csv",sep=""))
cfc_rules_2018 <- read_csv(paste(source_data,"cfc_rules_2018.csv",sep=""))
cfc_rules_2019 <- read_csv(paste(source_data,"cfc_rules_2019.csv",sep=""))
cfc_rules_2020 <- read_csv(paste(source_data,"cfc_rules_2019.csv",sep=""))

cfc_rules<-rbind(cfc_rules_2014,cfc_rules_2015,cfc_rules_2016,cfc_rules_2017,cfc_rules_2018,cfc_rules_2019,cfc_rules_2020)

cfc_rules$cfc_rules<-rowMeans(cfc_rules[,5:7])


write.csv(cfc_rules, file = paste(intermediate_outputs,"cfc_rules_data.csv",sep=""),row.names=F)
