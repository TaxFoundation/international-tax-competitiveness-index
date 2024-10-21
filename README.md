# International Tax Competitiveness Index
The Tax Foundation’s [_International Tax Competitiveness Index_](https://taxfoundation.org/publications/international-tax-competitiveness-index/) (_ITCI_) measures the degree to which the 38 OECD countries’ tax systems promote competitiveness through low tax burdens on business investment and neutrality through a well-structured tax code. The _ITCI_ considers 41 variables across five categories: Corporate Taxes, Individual Taxes, Consumption Taxes, Property Taxes, and Cross-Border Tax Rules.

The _ITCI_ attempts to display not only which countries provide the best tax environment for investment but also the best tax environment to start and grow a business.

## Explanation of Files in Repository
### /main directory
Location of the readme, and source documentation.

### /R_code_files
Location of the .R code files

### /source-data
Location of **input** files to several .R code files including:
1. `01_oecd_data_scraper.R`
2. `02_cost_recovery.R`
3. `03_vat_data.R`
4. `04_property_tax_collections.R`
5. `05_cfc_rules.R`
6. `06_paying_taxes.R` (no longer in use for the 2022 version)
7. `07_packaging_data.R`

### /intermediate-outputs
Location of some of the input files to `07_packaging_data.R`

### /final-data
Location of output files from `07_packaging_data.R` which are input files to `08_index_calculations.R`.

### /final-outputs
Location of the output files from `08_index_calculations.R` and `09_output_tables.R`.

## R code files in `/R_code_files`
### `00_master_file.R`
This code defines important variables and functions and can run the other code files in the repository.

### `01_oecd_data_scraper.R`
This code pulls down data from the OECD portal for the following variables:
1. `corporate_rate`
2. `r_and_d_credit`
3. `top_income_rate`
4. `threshold_top_income_rate`
5. `tax_wedge`
6. `dividends_rate`
7. `corporate_other_rev`
8. `personal_other_rev `

### `02_cost_recovery.R`
This code takes the Oxford Centre for Business Taxation tax database data (and additions to that made by Tax Foundation) to calculate present discounted values for capital allowances for investments in machinery, buildings, and intangibles. The main input file is `cost_recovery_data.csv`, which can be found in /source-data. Descriptions of the variables in that file can be found in `oxford_cbt_tax_database_data_description.md`, which is located in the main directory. The output from `02_cost_recovery.R` is the data for the following variables:
1. `machines_cost_recovery`
2. `buildings_cost_recovery`
3. `intangibles_cost_recovery`

### `03_vat_data.R`
This code organizes and combines data for the following variables:
1. `vat_rate` 
2. `vat_threshold`
3. `vat_base`

### `04_property_tax_collections.R`
This code uses IMF capital stock data and OECD property tax revenue data to produce the `property_tax_collections` variable.

### `05_cfc_rules.R`
This code takes the CFC rules input files and creates the `cfc_rules` variable as a composite of the three features of CFC rules systems. See `CFC Rules Model.md` in the main directory for more information.

### `06_paying_taxes.R` (_*No longer in use for the 2022 version*_)
This code organizes PwC's Paying Taxes data for the following variables:
1. `corporate_time`
2. `profit_payments`
3. `other_payments`
4. `labor_payments`
5. `labor_time`
6. `consumption_time`

The input file is `pwc_paying_taxes.csv`, which can be found in /source-data.

### `07_packaging_data.R`
This file combines the source data and intermediate output data. The outputs are complete datasets for 2014-2022 stored in /final-data.

### `08_index_calculations.R`
This file is the main file for calculating _Index_ scores and ranks.

### `09_output_tables.R`
This file creates the tables used in the report.

## Designing your own reform scenario
If you would like to see how a reform might impact a country's rank and score in the _Index_, you need to adjust only a handful of files.

After downloading the repository you should edit the directory variables in `00_master_file.R` to ensure that the downloaded files paths match where they are located on your computer. Then you can run the `00_master_file.R` code up through `#Run code files####`. At that point you can run `source(“08_index_calculations.R”)` to produce the baseline rankings and scores from this year’s version of the _Index_. You may want to save the baseline output `data_2024_run.csv` to a new folder so that the results will not be overwritten in the next step.

Next, you can create your reform scenario by manipulating the files in the `/final_data` folder. For example, if you wanted to test how a reduction in the French corporate tax rate would impact its rank and score, you could edit the `final_index_data_2024.csv` file to change the corporate_rate variable for France to be 15 percent. 

Once that change is made and the file is saved, you can run the `08_index_calculations.R` file again and note the changes relative to the previous baseline.

These two steps can be repeated for each reform scenario.

## Adding a country to the _Index_
If you would like to research the tax system of a particular country and add it to the _Index_, you can do so by following the methodology behind each variable (the information in `source_documentation.md` in the main directory will be helpful in this endeavor) and adding the country and variable values to the spreadsheets in the /final-data folder. Optimally, you will add values for each variable and each year back to 2014. Once the spreadsheets in the `/final-data` folder have been edited with a new row of data for the country you are adding, you can run the `08_index_calculations.R` file and explore the results.

If you have fully researched the data values for all the variables for the country for each year of the _Index_ and created a file with those sources, you could then create a pull request that we will review to determine if we would like to include the additional country in the repository and, potentially, the next version of the _Index_.

## Methodology
The ITCI is a relative ranking of the competitiveness and neutrality of the tax code in each of the 38 OECD countries. It utilizes 42 variables across five categories: corporate income tax, individual taxes, consumption taxes, property taxes, and cross-border tax rules. Each category has multiple subcategories, and each subcategory can hold several of the 41 variables. For example, the consumption tax category contains two subcategories: rate and base. The consumption tax base subcategory then includes two variables: “VAT/sales tax threshold” and “VAT/sales tax base as a percent of total consumption.”

The ITCI is designed to measure a country’s tax code on a relative basis rather than on an absolute measurement. This means that a score of 100 does not signify the absolute best possible tax code but the best tax code among the 38 OECD countries. Each country’s score on the ITCI represents its relative difference from the best country’s score.

### The Calculation of the Variable, Subcategory, Category, and Final Score
First, the standard deviation and average of each variable is calculated. The standard deviation measures the average difference of a country’s tax variables from the mean among all 38 countries.  For example, the average corporate income tax rate across the 38 OECD countries is about 23.6 percent, with a standard deviation of 5.3 percentage points. This means that on average, an OECD country’s corporate tax rate is 5.3 percentage points off from the mean rate of 23.6 percent.

To compare variables with each other, it is necessary to standardize them, because each variable has a different mean and standard deviation. To standardize the variables, each observation is given a normalized score (z-score). This sets every variable’s mean to 0 with a standard deviation of 1. Each country’s score for each variable is a measure of its difference from the mean across all countries for that variable. A score of 0 means a country’s score is equal to the average, a score of -1 means it is one standard deviation below average, and a score of 1 is one standard deviation above average.

The score for the corporate tax rate demonstrates this process. As mentioned, the average corporate income tax rate among the 38 OECD countries is 23.9 percent, and the standard deviation is 5.2 percentage points. The United States’ corporate tax rate normalized score is -0.34,  or 0.34 standard deviations less competitive than the average OECD country. In contrast, Ireland’s tax rate of 12.5 percent is 2.18 standard deviations more competitive than the average OECD country.

The next step is to combine variable scores to calculate subcategory scores. Within subcategories, each individual variable’s score is equally weighted and added together. For instance, the subcategory of cost recovery includes seven variables: loss carryback, loss carryforward, the present discounted value of depreciation schedules for machines, industrial buildings, and intangibles, inventory accounting method, and allowance for corporate equity. The scores for each of these seven variables are multiplied by 1/7, or 14.3 percent, to give them equal weight, and then added together. The result is the cost recovery subcategory score.

#### Calculating Subcategory Scores
From here, two transformations occur. First, to eliminate any negative values, the lowest z-score is multiplied by minus one. Then one is added to that value. For example, Colombia has the worst z-score for the corporate income tax rate subcategory (-2.14). Thus, -2.1403 multiplied by negative one is 2.1403. Adding one to that product gives 3.1403. Then 3.14 is added to each country’s z-score giving the adjusted z-score. This sets the worst score in each subcategory to 1. For Colombia, -2.14 plus 3.14 equals 1. 

Second, the adjusted subcategory scores for each country are scaled to 100, relative to the country with the best score in each subcategory. This is done by taking each country’s adjusted z-score and dividing it by the best adjusted z-score in each category. For example, Hungary, which has the lowest corporate tax rate, has the best adjusted corporate rate subcategory z-score of 2.85, and receives a final subcategory score of 100.

#### Calculating Category Scores
The same method is used to create the category scores. First, the z-score for subcategories is averaged to create the initial category score. Then, the worst z-score is multiplied by minus one and one is added to that product That resulting amount is added to each country’s z-score. For example, Colombia has the worst initial corporate category score of -0.91. Thus, -0.91 multiplied by negative one is 0.91. Adding one to that product gives 1.91. Then 1.91 is added to each country’s initial category score to give the adjusted initial category score. This sets the worst score in each category to 1. For Colombia, -0.91 plus 1.91 equals 1.

Second, the adjusted initial category scores for each country are scaled to 100, relative to the country with the best score in each category. This is done by taking each country’s adjusted initial category score and dividing it by the best adjusted initial category score in each category. For example, Latvia, which has the best corporate category score, has the best adjusted category score of 1.25, and receives a final category score of 100.

#### Calculating the Final Scores
The same method is used to create the final score. First, the initial category scores are averaged to create the initial final score. Then, the lowest value of the initial final score is multiplied by negative one and one is added to that product. That resulting amount is added to each country’s initial final score. For example, Colombia has the worst initial final score of -0.47. Thus, -0.47 multiplied by negative one is 0.47. Adding one to that product gives 1.47. Then 1.47 is added to each country’s initial final score (the adjusted initial final score). This sets the worst score in each category to 1.

Second, the adjusted initial final scores for each country are scaled to 100, relative to the country with the best score in each category. This is done by taking each country’s adjusted initial final score and dividing it by the best adjusted initial final score in each category. For example, Estonia, which has the best final score, has the best adjusted final score of 1.72, and receives a final category score of 100.

## What Drives the Final Score?
Because the _Index_ is constructed to compare 38 countries along 42 variables, it is possible that even despite the methods described above that certain variables, subcategories, or categories could be more highly correlated with the final score.
To evaluate this tendency, this section reviews the correlation coefficients between the components of the _Index_ and the final score.

### Specific Categories
The following table shows the correlation coefficients between the category scores and the final score. The average of these correlations is 0.54 with the weakest correlate being Consumption Taxes (0.29) and the strongest correlate being Property Taxes (0.69). This data can be found in `/final_outputs` in the file `categories_correlation.csv`.

| Category |	Correlation Coefficient with the Final Score |
|---|---|
|Corporate Taxes|	0.65|
|Individual Income Taxes|	0.61|
|Consumption Taxes|	0.29|
|Property Taxes	|0.69|
|Cross-Border Tax Rules|	0.46|
 
### Specific Subcategories
The next table shows the correlation coefficients between the subcategory scores and the final score. The average of these correlations is 0.39 with the weakest correlate being Tax Treaties (-0.04) and the strongest correlate being Incentives Complexity (0.57). This data can be found in `/final_outputs` in the file `subcategories_correlation.csv`.

| Subcategory	| Correlation Coefficient with the Final Score|
|---|---|
|Corporate Rate| 0.39 |
|Cost Recovery|	0.49 |
|Incentives/Complexity| 0.57 |
|Income Taxes| 0.54 |
|Income Tax Complexity| 0.13 |
|Capital Gains and Dividends| 0.51 |
|Consumption Tax Rate| 0.14 |
|Consumption Tax Base| 0.33 |
|Real Property Taxes| 0.49 |
|Wealth/Estate Taxes| 0.50 |
|Capital/Transation Taxes| 0.50 |
|Dividends/Capital Gains Exemption (Territoriality)| 0.40 |
|Withholding Taxes| 0.49 |
|Tax Treaties| -0.04 |
|International Tax Regulations| 0.36 |


### The Methodology
The method used to construct the _Index_ relies heavily on normalizing variables using z-scores, scaled around zero. To test whether this method significantly alters the final score, we also calculated the _Index_ by normalizing variables on a scale of 0 to 10. Though the final results are not perfectly identical, the correlation between the final score developed using z-scores and the alternative normalization method is 0.968 for the 2022 scores.

## Explanation of Data
A more thorough description of these data and how the Tax Foundation uses them is contained within the [*International Tax Competitiveness Index*](https://taxfoundation.org/publications/international-tax-competitiveness-index/). When possible, the data is from the current year as of July (e.g., 2024 data for the _2024 Index_). If current data were not available, there is a time lag, as noted after each variable description.


| Name | Description |
| --- | --- |
| `ISO_2` | Country 2-character ISO Code |
| `ISO_3` | Country 3-character ISO Code |
| `country` | Name of each OECD nation in the Index, in English. |
| `year` | Year |
| `corporate_rate` | The top marginal corporate tax rate in a given nation. No time lag. |
| `loss_carryback` | Number of years a corporation may apply current losses against previous tax bills, allowing for tax rebates. No time lag. If there is a general limitation on the amount of income that losses can be used to offset income, the number of years is reduced by that percentage. E.g. only 50 percent of taxable income can be offset with losses and there is a one year loss carryback, the `loss_carryback` variable would show `0.5`.|
| `loss_carryforward` | Number of years a corporation may apply current losses against future tax bills, lowering those years’ taxable income. No time lag. If there is a general limitation on the amount of income that losses can be used to offset income, the number of years is reduced by that percentage. E.g. only 50 percent of taxable income can be offset with losses and there is a 20 year loss carryforward, the `loss_carryforward` variable would show `10`.|
| `machines_cost_recovery` | Percentage of the present value cost of machinery that corporations can write off over the depreciable life of the asset. No time lag. |
| `buildings_cost_recovery` | Percentage of the present value cost of buildings that corporations can write off over the depreciable life of the asset. No time lag. |
| `intangibles_cost_recovery` | Percentage of the present value cost of intangibles that corporations can write off over the depreciable life of the asset. No time lag. |
| `inventory` | Score given based on a country’s allowable inventory cost accounting methods. Countries that allow Last In, First Out (LIFO) score `1`; countries that allow Average Cost of Inventory score `0.5`; countries that only allow First In, First Out (FIFO) score `0`. No time lag. |
| `allowance_corporate_equity` | Indicates which countries have an allowance for corporate equity (sometimes also referred to as “notional interest deduction”), which gives businesses a deduction based on their (additional) equity stock. Countries with allowances for corporate equity are marked with `1`; countries without them are marked as `0`. No time lag. |
| `patent_box` | Indicates which countries have patent boxes, which create lower tax rates for corporate income generated through patented products. Countries without patent boxes are marked with `0`; countries with patent boxes are marked as `1`. No time lag. |
| `r_and_d_credit` | Indicates the extent to which countries offer research and development (R&D) tax credits or other expenditure-based R&D tax incentives, measured as the implied tax subsidy rates on R&D expenditures. The variable is the average of profitable and loss-making SMEs and large businesses. 1-year time lag. |
| `digital_services_tax` | Indicates whether a country has a digital services tax which is a tax targeted at digital companies over a certain size threshold and the tax rate applies to gross revenues. No time lag. |
| `corporate_time` | Complexity of tax system measured by average time in hours needed to comply with a country's corporate tax requirements. 3-year time lag. No longer in use, replaced with `corporate_alt_minimum`.|
| `corporate_alt_minimum` | Complexity of tax system measured by number of rates applied to corporate profits. Includes alternative minimum taxes, number of tax brackets, and the existence of special general tax rates other than patent box rates. No time lag.|
| `profit_payments` | Complexity of tax system measured by number of yearly profit payments. 3-year time lag. No longer in use, replaced with `corporate_surtax`.|
| `corporate_surtax` | Complexity of tax system measured by the existence of a surtax applied to corporate income tax. No time lag.|
| `other_payments` | Complexity of tax system measured by number of other yearly tax payments. 3-year time lag. No longer in use, replaced with `corporate_other_rev`.|
| `corporate_other_rev` | Complexity of tax system measured by share of revenue collected outside of normal taxes on income. Revenue codes 1300 and 6100. 2-year time lag.|
| `top_income_rate` | The top marginal income tax rate. 1-year lag. |
| `threshold_top_income_rate` | Measure to show at what level the top statutory personal income tax rate applies, expressed as a multiple of the average income. 1-year time lag. |
| `tax_wedge` | The total tax cost of labor in a country (includes individual income tax and payroll tax). This is the average of the ratio of the marginal tax wedge to the average tax wedge for employees at the 67th, 100th, and 167th percentiles. 1-year time lag. |
| `labor_payments` | Complexity of tax system measured by number of yearly labor tax payments. 3-year time lag. No longer in use, replaced with `personal_surtax`.|
| `personal_surtax` | Complexity of tax system measured by the existence of a surtax applied to personal income tax. No time lag.|
| `labor_time` | Complexity of tax system measured by average time in hours needed to comply with a country’s labor tax requirements.32-year time lag. No longer in use, replaced with `personal_other_rev`.|
| `personal_other_rev` |Complexity of tax system measured by share of revenue collected outside of normal taxes on on payroll. Revenue code 2400. 2-year time lag.|
| `capital_gains_rate` | Tax rate for capital gains after any imputation, credit, or offset. When the capital gains tax rate varies by type of asset sold, the tax rate applying to the sale of listed shares after an extended period of time is used. No time lag. |
| `index_capital_gains` | Whether a country indexes basis for purposes of capital gains tax. No longer in use. |
| `dividends_rate` |  The total top marginal dividend tax rate after any imputation or credit system. No time lag. |
| `vat_rate` | The national (or average) consumption tax rate (either sales tax or VAT) for a country. No time lag. |
| `vat_threshold` | The upper sales limit in U.S. dollars for which a corporation does not need to pay consumption taxes. No time lag. |
| `vat_base` | The ratio of consumption taxes collected to potential collections if standard consumption tax rates were applied equally across all goods/services. This ratio measures exemptions to the taxes and/or noncompliance. 2-year time lag. |
| `consumption_time` | Complexity of consumption taxes measured by average time in hours needed for corporations to comply with a country's consumption tax requirements. 3-year time lag. No longer in use. |
| `property_tax` | Indicates whether capital additions to land are taxed. Fully taxing land and improvements is marked `0`; allowing deductions of taxes on improvements from corporate income taxes is marked `0.5`; taxing only land or not having a property tax is marked `1`. No time lag. |
| `property_tax_collections` | Property taxes collected in a country as a percentage of capital stock. 2-year time lag. |
| `net_wealth` | Indicates the existence of taxes on net wealth. Countries with wealth taxes are marked `1`; countries with wealth taxes on only some asset classes are marked `0.5`; those without are marked `0`. No time lag. |
| `estate_or_inheritance_tax` | Indicates the existence of taxes on estates or inheritances. Countries with such taxes are marked `1`; those without are marked `0`. No time lag. |
| `transfer_tax` | Indicates the existence of taxes on the transfer (buying and selling) of real property. Countries with property transfer taxes are marked `1`; those without are marked `0`. No time lag. |
| `asset_tax` | Indicates the existence of a tax on net corporate assets. Countries with an asset tax are marked `1`; those without are marked `0`. No time lag. |
| `capital_duties` | Indicates the existence of a tax on the issuance of shares of stock. Countries with a capital duties tax are marked `1`; those without are marked `0`. No time lag. |
| `financial_transaction_tax` | Indicates the existence of a tax on the transfer of financial assets. Countries with financial transaction taxes are marked `1`; those without are marked `0`. No time lag. |
| `dividends_exemption` | Percentage of dividends paid from foreign subsidiaries which are exempt from domestic taxes. No time lag. |
| `capital_gains_exemption` | Percentage of capital gains from foreign investments which are exempted from domestic taxes. No time lag. |
| `country_limitations` | Indicates whether a country has certain exemptions to a territorial tax system based on the source of the foreign income. Existence of exemptions are marked as `1`; no exemptions are marked `0`. No time lag. |
| `dividends_withholding_tax` | Required withholding for tax payments on dividends to be paid to foreign investors or businesses. No time lag. |
| `interest_withholding_tax` | Required withholding for tax payments on interest to be paid to foreign investors or businesses. No time lag. |
| `royalties_withholding_tax` | Required withholding for tax payments on royalties to be paid to foreign investors or businesses. No time lag. |
| `tax_treaties` | Number of foreign nations with which a country has tax treaties. 1-year time lag. |
| `cfc_rules` | Indicates existence and strictness of Controlled Foreign Corporation (CFC) rules. This combines measures of whether CFC rules exist, whether they tax passive or active income, and whether they provide exemptions. Countries without CFC rules are marked `0`; those with the strictest are marked `1`, countries in between have various scores. No time lag. |
| `thin_capitalization_rules` | Indicates whether a country puts thin capitalization restrictions on companies’ debt-to-asset ratios. Countries that limit interest deductions with only transfer pricing regulations are scored as `0`. Countries with debt-to-equity ratios receive a score of `0.5`, and countries with interest-to-pretax-earning limits receive a score of `1`. No time lag. |
| `minimum_tax` | Indicates whether a country imposes a general minimum tax. Countries with an Income Inclusion Rule (IIR) or GILTI in the U.S.are marked as `0.5`; Countries that impose both an IIR and an Under-Taxed Profits Rule (UTPR) or BEAT in the U.S. are marked as `1`. No time lag. |

The _ITCI_ uses the most up-to-date data available as of July 2024.