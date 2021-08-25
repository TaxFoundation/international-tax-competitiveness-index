#Clean up working environment####
rm(list=ls())
gc()

#Directory Variables####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
R_code_files<-"C:/Github/international-tax-competitiveness-index/R_code_files/"
source_data<-"C:/Github/international-tax-competitiveness-index/source_data/"
intermediate_outputs<-"C:/Github/international-tax-competitiveness-index/intermediate_outputs/"
final_data<-"C:/Github/international-tax-competitiveness-index/final_data/"
final_outputs<-"C:/Github/international-tax-competitiveness-index/final_outputs/"
country_outputs<-"C:/Github/international-tax-competitiveness-index/country_outputs/"
new_zealand_reform<-"C:/Github/international-tax-competitiveness-index/new_zealand_reform/"


#Define Using function####
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

#Load libraries####
using(OECD)
using(readxl)
using(plyr)
using(dplyr)
using(reshape2)
using(countrycode)
using(tidyverse)
using(stringr)
using(IMFData)
using(readr)
#using(xlsx)
using(scales)

#Define list of OECD countries####
oecd_countries<-c("AUS",
                  "AUT",
                  "BEL",
                  "CAN",
                  "CHL",
                  "COL",
                  "CZE",
                  "DNK",
                  "EST",
                  "FIN",
                  "FRA",
                  "DEU",
                  "GRC",
                  "HUN",
                  "ISL",
                  "IRL",
                  "ISR",
                  "ITA",
                  "JPN",
                  "KOR",
                  "LVA",
                  "LUX",
                  "LTU",
                  "MEX",
                  "NLD",
                  "NZL",
                  "NOR",
                  "POL",
                  "PRT",
                  "SVK",
                  "SVN",
                  "ESP",
                  "SWE",
                  "CHE",
                  "TUR",
                  "GBR",
                  "USA")

#Read in ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
iso_country_codes <- read_csv(paste(source_data,"iso_country_codes.csv",sep=""))
colnames(iso_country_codes)<-c("country","ISO_2","ISO_3")
                              
#Run code files####
source("01_oecd_data_scraper.R")
source("02_cost_recovery.R")
source("03_vat_data.R")
source("04_property_tax_collections.R")
source("05_cfc_rules.R")
source("06_paying_taxes.R")
source("07_packaging_data.R")
source("08_index_calculations.R")
source("09_output_tables.R")
