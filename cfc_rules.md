# CFC Rules Model
The averaging function in `05_cfc_rules.R` creates the  `cfc_rules` variable. The inputs are the `cfc_rules_2014.csv`,`cfc_rules_2015.csv`,`cfc_rules_2016.csv`,`cfc_rules_2017.csv`,`cfc_rules_2018.csv`,`cfc_rules_2019.csv`, `cfc_rules_2020.csv`, `cfc_rules_2021.csv`, `cfc_rules_2022.csv`, `cfc_rules_2023.csv`, and `cfc_rules_2024.csv` files in the `/source-data` folder and the output is the `cfc_rules_data.csv` file in the `/intermediate-outputs` folder.

Each country’s score in this subcomponent is based on three aspects of controlled foreign corporation (CFC) rules: 
1. Whether a country has CFC regulations; 
2. whether CFC rules apply to passive income or all income;  
3. the breadth of exemptions from the general CFC rules. Countries receive the best score if they do not have CFC rules; and

Countries with CFC rules that have exemptions or only apply to passive income or income associated with non-genuine arrangements receive a better score. Countries score worst if they have CFC rules that apply to all income, have no exemptions, and do not have a general minimum tax rule for foreign earnings. 

Zero is the best score. 

The value of the `cfc_rules` variable is a simple average of three variables:

## `exists`: determines if the country has CFC rules or not.

    Equal to 1 if CFC rules exist and 0 if CFC rules do not exist.

## `active`: determines if the country's CFC regime taxes active income

    Equal to 1 if CFC rules capture both active and passive income; equal to 0.5 if the rules use a threshold based on the share of passive income to decide whether all of the entity's income is treated as passive; equal to 0 if they apply only to passive income, or only to income associated with non-genuine arrangements, or the country does not have a CFC regime.

A threshold is the only route to 0.5, and it must switch the regime to full inclusion. Where a passive-income share merely opens the door to attributing the passive income itself — a de minimis gate rather than a switch — the rules still reach passive income only and the score is 0. Austria and Belgium are the countries this distinguishes: their one-third tests decide whether passive income is attributed at all, not whether the entity's whole income is treated as passive.

An exemption for CFCs carrying out substantial economic activities does not by itself reduce the score, because it narrows who the rules reach rather than which income they cover; where such an exemption is the only qualification, the score follows the reach of the rules. Regimes implementing the "Model B" approach of the EU Anti-Tax Avoidance Directive attribute income arising from non-genuine or artificial arrangements rather than a category of income, and are scored 0.

## `no_exemption`: determines if the country has exemptions to its CFC regime

    Equal to 1 if CFC rules do not have exemptions; equal to 0 if there are exemptions for countries (including based on an effective or statutory rate test) or if there are no CFC rules; equal to 0.5 if there is a formula based on a share of passive income that triggers full inclusion.
