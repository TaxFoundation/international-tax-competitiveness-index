# CFC Rules Model
The averaging function in `05_cfc_rules.R` creates the  `cfc_rules` variable. The inputs are the `cfc_rules_2014.csv`,`cfc_rules_2015.csv`,`cfc_rules_2016.csv`,`cfc_rules_2017.csv`,`cfc_rules_2018.csv`,`cfc_rules_2019.csv`, and `cfc_rules_2020.csv` files in the `/source-data` folder and the output is the `cfc_rules_data.csv` file in the `/intermediate-outputs` folder.

Each country’s score in this subcomponent is based on three aspects of controlled foreign corporation (CFC) rules: 
1. Whether a country has CFC regulations; 
2. whether CFC rules apply to passive income or all income; and 
3. the breadth of exemptions from the general CFC rules. Countries receive the best score if they do not have CFC rules. 

Countries with CFC rules that have exemptions or only apply to passive income or income associated with non-genuine arrangements receive a better score. Countries score worst if they have CFC rules that apply to all income and have no exemptions. 

Zero is the best score. 

The value of the `cfc_rules` variable is a simple average of three variables:

## `exists`: determines if the country has CFC rules or not.

    Equal to 1 if CFC rules exist and 0 if CFC rules do not exist.

## `active`: determines if the country's CFC regime taxes active income

    Equal to 1 if CFC rules apply to active income; equal to 0 if they apply only to passive income or the country does not have a CFC regime; equal to 0.5 if there is a formula based on a share of passive income that triggers full inclusion or the country exempts CFCs with substantial activities.

## `no_exemption`: determines if the country has exemptions to its CFC regime

    Equal to 1 if CFC rules do not have exemptions; equal to 0 if there are exemptions for countries (including based on an effective or statutory rate test) or if there are no CFC rules; equal to 0.5 if there is a formula based on a share of passive income that triggers full inclusion.