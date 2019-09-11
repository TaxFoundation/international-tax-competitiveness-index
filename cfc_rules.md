# CFC Rules Model
The averaging function in `05_cfc_rules.R` creates the  `cfc_rules` variable. The inputs are the `cfcrules2014-2019` files in the `/source-data` folder and the output is the `CFC Rules Data.csv` file in the `/intermediate-outputs` folder.

Each country’s score in this subcomponent is based on three aspects of controlled foreign corporation (CFC) rules: 
1. Whether a country has CFC regulations; 
2. whether CFC rules apply to passive income or all income; and 
3. the breadth of exemptions from the general CFC rules. Countries receive the best score if they do not have CFC rules. 

Countries with CFC rules that have exemptions or only apply to passive income or income associated with non-genuine arrangements receive a better score. Countries score the worst if they have CFC rules that apply to all income and have no exemptions. 

Zero is the best score. 

The value of the `cfc_rules` variable is a simple average of three binary variables:

## `exists`: determines if the country has CFC rules or not.

    Equal to 1 if CFC rules exist and 0 if CFC rules do not exist.

## `active`: determines if the country's CFC regime taxes active income

    Equal to 1 if CFC rules apply to active income and equal to 0 if they apply only to passive income or the country does not have a CFC regime

## `exemption`: determines if the country has exemptions to its CFC regime

    Equal to 1 if CFC rules do not have exemptions; equal to zero if there are no CFC rules or if there are exemptions.