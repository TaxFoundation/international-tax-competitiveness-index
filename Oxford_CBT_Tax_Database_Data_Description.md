Note: This document is a reproduction of the data description file that accompanied the 2017 version of the Oxford University Centre for Business Taxation CBT Tax Database. The database is used as part of the _International Tax Competitiveness Index_ for the variables `machines_cost_recovery`, `buildings_cost_recovery`, and `intangibles_cost_recovery`. The source for these data are in the `source-data` folder in the file named `CBT_tax_database_web_2019_all_ame.csv`. The code file `allowances_ame_OECD_2019.R` transforms the cost recovery variables into present discounted value variables.

For these variables in the _Index_, years prior to 2018 are based on "Oxford University Centre for Business Taxation, 'CBT Tax Database 2017,' http://eureka.sbs.ox.ac.uk/id/eprint/4635". Calculations for 2018 and 2019 are based on Elke Asen and Daniel Bunn, "Capital Cost Recovery across the OECD, 2019," Tax Foundation, April 2, 2019, https://taxfoundation.org/publications/capital-cost-recovery-across-the-oecd/.

At some point the file addresses for many of the files linked to in this document were changed or the files were taken down, so the links do not work as they should. This document is reproduced here somewhat as an archival element and also because the variable explanations are relevant to the _ITCI_.

# CBT Tax Database
# Data Description
### Oxford University Centre for Business Taxation
### January 2017
## 1. Introduction
This document briefly describes the data on corporate income tax systems that have been collected by the Oxford University Centre for Business Taxation and is now available on the CBT website. It provides a detailed information on all the variables available, the country and year coverage. Since the development of the database is an ongoing work, more information will become available over time. This note refers to the state of the database as of January 2017. 

The information in this database for the years 2002 – 2012 has been used in the CBT Corporate Tax Ranking 2012 . The database includes raw data variables such as corporate tax rates, aspects of the legal definition of the corporate tax base (depreciation rates and types), and inventory valuation methods. It also includes measures of EATRs and EMTRs as used in the CBT Corporate Tax Ranking 2012. The database covers G20 and OECD countries over the period 1983 – 2017 (in some case 1979 – 2017) as specified below.

The CBT database builds on an existing database which has been created in 2006 as a multi-country database and developed over the years by various Research Fellows at the Centre, and earlier at the Institute for Fiscal Studies. The original version uses various sources such as OECD Tax Database, IBFD (International Bureau of Fiscal Documentation), World Tax Database from the University of Michigan, KPMG and E&Y and covered mainly OECD countries. The data currently in the database comes from various sources, mainly from:
-	The Worldwide Corporate Tax Guide published by E&Y; years available: 2002-2017
-	data for 2011 - 2017 comes mainly from the online IBFD Tax Research Platform where they provide very detailed Country Surveys
-	G20 countries data has been updated to be consistent with IBFD "Global corporate tax handbook" (years 2007 - 2010) and "European tax handbook" (years 1990 - 2010)
-	ZEW Intermediate Report 2011, “Effective Tax levels using Devereux/Griffith methodology”
-	Deloitte Tax Highlights and International Tax and Business Guide; years available: 2009, 2010
-	KPMG Tax Rate Survey; years available: 1998 - 2009
-	PKF Worldwide Tax Guide; years available: 2007 - 2009

We update the database each year to make it consistent with the most recently available information. We aim to make sure that the all the information included in the database applies in 1st January of the given year. Therefore if the tax year is different than calendar year, any reforms introduced in a given tax year that started after 1st January will not appear in the data until the following year.

This brief description is organized as follows: section 2 lists all the countries covered in the sample, section 3 explains in more detail the features of each of the variables and what they comprise of. Section 4 explains how to obtain the data from the database and who to contact in case of any queries.

## 2. Country and year coverage

The database consists of 43 G20 and OECD countries. 34 countries belong to the OECD and 19 are the G20 members. Some countries are members of both groups. Data for the following countries is available: Argentina, Australia, Austria, Belgium, Brazil, Canada, Chile, China, Czech Republic, Denmark, Estonia, Finland, France, Germany, Greece, Hungary, Iceland, India, Indonesia, Ireland, Israel, Italy, Japan, South Korea, Luxembourg, Mexico, Netherlands, New Zealand, Norway, Poland, Portugal, Russia, Saudi Arabia, Slovak Republic, Slovenia, South Africa, Spain Sweden, Switzerland, Turkey, United Kingdom, and United States.

The years covered span the period 1983 – 2017 for most of the countries, some data is available for the period 1979 – 2017.

Additional data for Bulgaria, Bosnia and Herzegovina, Croatia, Romania, Serbia and Ukraine is provided for years 2004-2017.

## 3. Variables available
## 3.1 Corporate tax rate
The corporate tax rates worksheet contains information on the statutory corporate tax rates in each country. The file consists of columns describing country code, year, top corporate tax rate at federal level, any surcharge levied, any local corporate tax rate (also whether it is based on an average of localities, or is a “typical” rate) whether local tax is deductible and finally the total corporate tax rate, which is the sum of all the tax rates that exist in a given country in a given year taking into account the deductions available.

Note: The local business tax in Canada for years 2011 and 2012 has been changed from 13% used in the CBT Corporate Tax Ranking 2012 to 11.75% according to suggestions received upon the report publication.

## Variables:
| Name: |	Format |Description|
|---|---|---|
|country|3 digit string|3 digit ISO Code|
|year|4 digit number|Calendar year (NOT fiscal year) |
|top_corp_tax_rate|Numeric, not in %|Top statutory corporate tax rate at central government level – excluding eventual surcharges, on distributed profits|
|surcharge|	Numeric, not in %|	Surcharges on corporate tax|
|local_top_corp_tax_rate|	Numeric, not in %|	Top statutory corporate tax rate at lower government levels|
|local_tax_deductible	|Numeric, not in %	|This variable takes value 0 if no local tax is applicable or local corporate tax payments are NOT deductible from central government corporation tax, 1 if local taxes are deductible from central taxes, e.g. 0.5 if 50 percent are deductible|
|local_is_average	|Dummy	|0 if no local tax or if the local tax of a particular place is used. 1 if the local corporate tax rate is an average of all provinces|
|local_is_typical|Dummy|	0 if no local tax or if the local tax an average of all provinces. 1 if the local corporate tax rate is for a typical place (mostly economic capital)|
|total_corp_tax_rate|	Numeric, not in %	|Sum of federal tax rate, local tax rate taking into account surcharge and deductibility of local taxes|



## 3.2 Corporate tax base
The corporate tax base worksheet includes information on the depreciation rates and types and inventory valuation method. It describes three assets: industrial buildings, plant and machinery and intangibles (patents) and for each of those it has information about depreciation method (either straight line, declining balance, declining balance with a switch to straight line or any variation), depreciation rates and number of years over which the asset is permitted to depreciate. It also includes information on the method of inventory valuation, which can be either last in first out (LIFO), average or first in first out (FIFO). Where more than one valuation method is applicable the most preferable method was chosen (we prefer LIFO over average over FIFO).

Sometimes, for certain assets, data was not available for depreciation rates and methods or else it was stated that depreciation must be computed in accordance with the statutory useful lives of the assets. When this occurred we make assumptions as to what are the useful lives of all three assets used in the database. They are as follows:

- for industrial buildings: 25 years useful life
- for plants and machinery: 7 years useful life
- for patents: 10 years useful life

The depreciation rates were computed accordingly.

## Variables:
| Name: |	Format |Description|
|---|---|---|
|country|	3 digit string|	3 digit ISO Code|
|year|	4 digit number|	Calendar year (NOT fiscal year) make judgement if calendar year and fiscal year diverge|
|taxdepbuildtype|	String|	SL: for straight line; DB: for declining balance; DB or SL: for declining balance with a switch to straight line; SL2: for straight line depreciation with changing rates; initialDB: for Declining Balance with initial allowance. _For other values see note below._|
|taxdepmachtype		|String|	SL: for straight line; DB: for declining balance; DB or SL: for declining balance with a switch to straight line; SL2: for straight line depreciation with changing rates; initialDB: for Declining Balance with initial allowance. _For other values see note below._|
|taxdepintangibltype		|String|	SL: for straight line; DB: for declining balance; DB or SL: for declining balance with a switch to straight line; SL2: for straight line depreciation with changing rates; initialDB: for Declining Balance with initial allowance. _For other values see note below._|
|taxdeprbuilddb|	Numeric, not in %|	Rate of depreciation applicable if depreciation according to declining balance (if DB or DB or SL), if SL2, the first applicable rate|
|taxdeprmachdb	|	Numeric, not in %|	Rate of depreciation applicable if depreciation according to declining balance (if DB or DB or SL), if SL2, the first applicable rate|
|taxdeprintangibldb		|Numeric, not in %|	Rate of depreciation applicable if depreciation according to declining balance (if DB or DB or SL), if SL2, the first applicable rate|
|taxdeprbuildsl|	Numeric, not in %|	Rate of depreciation applicable if depreciation according to straight line (SL), if SL2, the second applicable rate|
|taxdeprmachsl|		Numeric, not in %|	Rate of depreciation applicable if depreciation according to straight line (SL), if SL2, the second applicable rate|
|taxdeprintangiblsl	|	Numeric, not in %|	Rate of depreciation applicable if depreciation according to straight line (SL), if SL2, the second applicable rate|
|taxdeprbuildtimedb|	Numeric, not in %	|Years the first rate is applicable (the rate in taxdepr(_asset name_)db), under a DB, DB or SL or a SL2 method. 
|taxdepmachtimedb	|	Numeric, not in %	|Years the first rate is applicable (the rate in taxdepr(_asset name_)db), under a DB, DB or SL or a SL2 method. 
|taxdepintangibltimedb		|Numeric, not in %	|Years the first rate is applicable (the rate in taxdepr(_asset name_)db), under a DB, DB or SL or a SL2 method. |
|taxdeprbuildtimesl	|Numeric, not in %	|Years the second rate is applicable (the rate in taxdepr(_asset name_)sl), under a SL, DB or SL or a SL2 method.|
|taxdepmachtimesl|	Numeric, not in %	|Years the second rate is applicable (the rate in taxdepr(_asset name_)sl), under a SL, DB or SL or a SL2 method.|	
|taxdepintangibltimesl	|	Numeric, not in %	|Years the second rate is applicable (the rate in taxdepr(_asset name_)sl), under a SL, DB or SL or a SL2 method.|	
|inventoryval|	string	|This can be LIFO, average, or FIFO. If more than one method is allowed, the tax optimal method is chosen, ranking is 1) LIFO, 2) average, 3) FIFO.|


# 3.3 Effective average tax rate (EATR) & Effective marginal tax rate (EMTR)
The EATR and EMTR worksheet includes measures of the both effective tax rates. The file consists of columns describing country code, year, EATR and EMTR. For a description of the methodology and the assumptions used in the calculation of the EATRs and EMTRs please refer to Appendix A in the CBT Corporate Tax Ranking 2012 (See http://www.sbs.ox.ac.uk/centres/tax/Documents/reports/CBT%20tax%20ranking%20appendices.pdf).

## Variables:
| Name: |	Format |Description|
|---|---|---|
|country: |	3 digit string|	3 digit ISO Code|
|year: 	|4 digit number	|Calendar year (NOT fiscal year) make judgement if calendar year and fiscal year diverge|
|EATR	|Numeric, not in %|	Effective average tax rate|
|EMTR	|Numeric, not in %	|Effective marginal tax rate|


# 4 How to access the data
The database consists of a single Microsoft Excel file with three worksheets corresponding to the information described in Section 3. The database is available on the CBT website: www.sbs.ox.ac.uk/centres/tax/Pages/Reports.asp. If you have any queries regarding the information in the data please email: katarzyna.bilicka@sbs.ox.ac.uk.