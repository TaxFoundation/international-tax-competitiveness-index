# International Tax Competitiveness Index

The Tax Foundation’s [International Tax Competitiveness Index](https://taxfoundation.org/publications/international-tax-competitiveness-index/) (ITCI) measures the degree to which the 36 OECD countries’ tax systems promote competitiveness through low tax burdens on business investment and neutrality through a well-structured tax code. The ITCI considers more than forty variables across five categories: Corporate Taxes, Individual Taxes, Consumption Taxes, Property Taxes, and International Tax Rules.

The ITCI attempts to display not only which countries provide the best tax environment for investment but also the best tax environment to start and grow a business.

## Methodology

The ITCI is a relative ranking of the competitiveness and neutrality of the tax code in each of the 36 OECD countries. It utilizes over 40 variables across five categories: corporate tax, individual taxes, consumption taxes, property taxes, and international tax rules. Each category has multiple subcategories, and each subcategory holds a number of the 40 variables. For example, the consumption tax category contains three subcategories: rate, base, and complexity. The consumption tax base subcategory then has two variables: consumption tax as a percentage of total consumption and VAT threshold.

The ITCI is designed to measure a country’s tax code on its relative competitiveness rather than on an absolute measurement. This means that a score of 100 does not signify the absolute best possible tax code but the best tax code among the 36 OECD countries. Each country’s score on the ITCI represents its relative distance from the best country’s score.


### The Calculation of the Variable, Subcategory, Category, and Final Score
First, the standard deviation and average of each variable is calculated. The standard deviation measures the average difference of a country’s tax variables from the mean among all 36 countries.  For example, the average corporate income tax rate across the 36 OECD countries is about 23.6 percent, with a standard deviation of 5.4 percentage points. This means that on average, an OECD country’s corporate tax rate is 5.4 percentage points off from the mean rate of 23.6 percent.

To compare each variable, it is necessary to standardize them, because each variable has a different mean and standard deviation. To standardize the variables, each observation is given a normalized score. This sets every variable’s mean to 0 with a standard deviation of 1. Each country’s score for each variable is a measure of its difference from the mean across all countries for that variable. A score of 0 means a country’s score is equal to the average, a score of -1 means it is one standard deviation below average, and a score of 1 is one standard deviation above average.

The score for the corporate tax rate demonstrates this process. Of the 36 OECD countries, the average corporate income tax rate is 23.6 percent, and the standard deviation is 5.4 percentage points. The United States’ corporate tax rate normalized score is -0.42,  or 0.42 standard deviations less competitive than the average OECD country. In contrast, Ireland’s tax rate of 12.5 percent is 2.03 standard deviations more competitive than the average OECD country.

The next step is to combine variable scores to calculate subcategory scores. Within subcategories, each individual variable’s score is equally weighted and added together. For instance, the subcategory of cost recovery includes six variables: loss carryback, loss carryforward, the present discounted value of depreciation schedules for machines, industrial buildings, and intangibles, and inventory accounting method. The scores for each of these six variables are multiplied by 1/6, or 16.6 percent, to give them equal weight, and then added together. The result is the cost recovery subcategory score.

### Calculating Subcategory Scores
From here, two transformations occur. First, to eliminate any negative values, the inverse of the lowest z-score plus one in each subcategory is added to each country’s z-score. For example, France has the worst z-score for the corporate income tax rate subcategory (-1.99). Thus, 1.99 plus 1 (2.99) is added to each country’s z-score (the adjusted z-score). This sets the worst score in each subcategory to 1.
Second, the adjusted subcategory scores for each country are scaled to 100, relative to the country with the best score in each subcategory. This is done by taking each country’s adjusted z-score and dividing it by the best adjusted z-score in each category. For example, Hungary, which has the lowest corporate tax rate, has the best adjusted corporate rate subcategory z-score of 5.66, and receives a final subcategory score of 100.

###Calculating Category Scores
The same method is used to create the category scores. First, the z-score for subcategories are averaged to create the initial category score. Then, the inverse of the worst z-score plus one in each category is added to each country’s z-score. For example, Japan has the worst initial corporate category score of -0.84. Thus, 0.84 plus 1 (1.84) is added to each country’s initial category score (the adjusted initial category score). This sets the worst score in each category to 1.
Second, the adjusted initial category scores for each country are scaled to 100, relative to the country with the best score in each category. This is done by taking each country’s adjusted initial category score and dividing it by the best adjusted initial category score in each category. For example, Latvia, which has the best corporate category score, has the best adjusted category score of 3.05, and receives a final category score of 100.

###Calculating the Final Scores
The same method is used to create the final score. First, the initial category scores are averaged to create the initial final score. Then, the inverse of the worst initial final score plus one is added to each country’s initial final score. For example, France has the worst initial final score of -0.53. Thus, 0.53 plus 1 (1.53) is added to each country’s initial final score (the adjusted initial final score). This sets the worst score in each category to 1.

Second, the adjusted initial final scores for each country are scaled to 100, relative to the country with the best score in each category. This is done by taking each country’s adjusted initial final score and dividing it by the best adjusted initial final score in each category. For example, Estonia, which has the best final score, has the best adjusted final score of 2.34, and receives a final category score of 100.


## Explanation of Data

A more thorough description of these data and how the Tax Foundation uses them is contained within the [International Tax Competitiveness Index](https://taxfoundation.org/publications/international-tax-competitiveness-index/)

| Name | Description |
| --- | --- |
| `country` | Name of each OECD nation in the Index, in English. |
| `corprate` | The top marginal corporate tax rate in a given nation. |
| `losscarryback` | Number of years a corporation may apply current losses against previous tax bills, allowing for tax rebates. |
| `losscarryforward` | Number of years a corporation may apply current losses against future tax bills, lowering those years' taxable income. |
| `pdvmachines` | Percentage of the present value cost of machinery that corporations can write off over the depreciable life of the asset. |
| `pdvbuildings` | Percentage of the present value cost of buildings that corporations can write off over the depreciable life of the asset. |
| `pdvintangibles` | Percentage of the present value cost of intangibles that corporations can write off over the depreciable life of the asset. |
| `inventory` | Score given based on a country's allowable inventory cost accounting methods. Countries that allow Last In, First Out (LIFO) score `1`; countries that allow Average Cost of Inventory score `0.5`; countries that only allow First In, First Out (FIFO) score `0`. |
| `patentbox` | Indicates which countries have patent boxes, which create lower tax rates for income generated through patented products. Countries without patent boxes are marked with `0`, countries with patent boxes are marked as `1`. |
| `rndcredit` | Indicates which countries offer research and development tax credits. Countries without such credits are marked `0`; those with R&D credits are marked `1`. |
| `corptime` | Complexity of tax system measured by average time in hours needed to comply with a country's corporate tax requirements. |
| `profitpayments` | Complexity of tax system measured by number of yearly profit payments. |
| `otherpayments` | Complexity of tax system measured by number of other yearly tax payments. |
| `incrate` | The top marginal income tax rate. |
| `progressivity` | Measure of progressivity of individual income tax rates as a ratio of minimum income level at which the top rate applies to the average income. |
| `taxwedge` | Total tax cost of labor in a country (includes individual income tax and payroll tax). |
| `laborpayments` | Complexity of tax system measured by number of yearly labor tax payments. |
| `labortime` | Complexity of tax system measured by average time in hours needed to comply with a country's labor tax requirements. |
| `capgainsrate` | Tax rate for capital gains. |
| `divrate` |  The total top marginal dividend tax rate after any imputation or credit system. |
| `vatrate` | The national (or average) consumption tax rate (either sales tax or VAT) for a country. |
| `threshold` | The upper sales limit in US dollars for which a corporation does not need to pay consumption taxes. |
| `base` | The ratio of consumption taxes collected to potential collections if consumption tax rates were applied equally across all goods/services. This ratio measures exemptions to the taxes and/or noncompliance. |
| `consumptiontime` | Complexity of consumption taxes measured by average time in hours needed for corporations to comply with a country's consumption tax requirements. |
| `propertytaxes` | Indicates whether capital additions to land are taxed. Fully taxing land and improvements is marked `1`; allowing deductions of taxes on improvements from corporate income taxes is marked `0.5`; taxing only land or not having a property tax is marked `0`. |
| `propertytaxescollections` | Property taxes collected in a country as a percentage of GDP. |
| `netwealth` | Indicates the existence of taxes on net wealth. Countries with wealth taxes are marked `1`; those without are marked `0`. |
| `estate/inheritance tax` | Indicates the existence of taxes on estates or inheritances. Countries with such taxes are marked `1`; those without are marked `0`. |
| `transfertaxes` | Indicates the existence of taxes on the transfer (buying and selling) of real property. Countries with property transfer taxes are marked `1`; those without are marked `0`. |
| `Assettaxes` | Indicates the existence of a tax on net corporate assets. Countries with an asset tax are marked `1`; those without are marked `0`. |
| `capitalduties` | Indicates the existence of a tax on the issuance of shares of stock. Countries with a capital duties tax are marked `1`; those without are marked `0`. |
| `financialtrans` | Indicates the existence of a tax on the transfer of financial assets. Countries with financial transfer taxes are marked `1`; those without are marked `0`. |
| `dividendexempt` | Percentage of dividends paid from foreign subsidiaries which are exempt from local taxes. |
| `capgainsexemption` | Indicates whether capital gains from foreign investments are exempted from local taxes. Fully exempt is marked as `1`; non-exempt is marked as `0`. |
| `divwithhold` | Required withholding for tax payments on dividends to be paid to foreign investors or businesses. |
| `intwithhold` | Required withholding for tax payments on interest to be paid to foreign investors or businesses. |
| `roywithhold` | Required withholding for tax payments on royalties to be paid to foreign investors or businesses. |
| `taxtreaties` | Number of foreign nations with which a country has tax treaties. |
| `cfcrules` | Indicates existence of controlled foreign corporation rules. Countries with CFC rules are marked `1`; those without are marked `0`. |
| `country limitations` | Indicates whether country has certain exemptions to a territorial tax system based on the source of the foreign income. Existence of exemptions are marked as `1`; no exemptions are marked `0`.  |
| `thincap` | Indicates whether a country puts thin capitalization resitrictions on companies' debt-to-asset ratios. Countries with restrictions are marked as `1`; those without are marked `0`. |

The ITCI uses the most up-to-date data available as of July 2019.