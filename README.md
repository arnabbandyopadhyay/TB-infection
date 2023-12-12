# WHO Global Tuberculosis Report 2023

Code and data used to develop the WHO Global Tuberculosis Report for 2023. The report was published on 7 November 2023 at https://www.who.int/teams/global-tuberculosis-programme/tb-reports/global-tuberculosis-report-2023/

# Folders

* **data**: External datasets:

## Snapshot data

* **agg**: TB/HIV indicators with rules to be used to calculate aggregates from `view_TME_master_TBHIV_for_aggregates`

* **covid**: Impact of COVID on services and response to the UNHLM commitments from `view_TME_master_covid_unhlm`

* **drfq**: DRS records used to estimate fluoroquinolone resistance among RR-TB patients from `view_DRS_for_estimation_sldst`

* **drhnew**: DRS records used to estimate HR-TB among new TB patients from `view_DRS_for_estimation_new_INH`

* **drhret**: DRS records used to estimate HR-TB among previously treated TB patients from `view_DRS_for_estimation_ret_INH`

* **drnew**: DRS records used to estimate RR-TB among new TB patients from `view_DRS_for_estimation_new`

* **drret**: DRS records used to estimate RR-TB among previously treated TB patients from `view_DRS_for_estimation_ret`

* **drroutine**: Routine drug resistance surveillance records from `view_TME_master_dr_surveillance`

* **ltbi**: Estimates of TPT coverage among children (numbers derived from reported data) from `view_TME_estimates_ltbi`

* **monthly**: Provisional monthly or quarterly notifications from `dcf.latest_provisional_c_newinc`

* **sty**: Services, PPM, community engagement, M&E systems from `view_TME_master_strategy`

* **tb**: TB notifications from `view_TME_master_notifications`

* **tpt**: TB preventive treatment from `view_TME_master_contacts_tpt`

* **tx**: Treatment outcomes from `view_TME_master_outcomes`

* **vrgtb**: VR data reported by countries in the European Region from `dcf.latest_vr`


## Other data

### Explanatory 

* **dic**: Data dictionary from `view_TME_data_dictionary`

* **codes**: Meaning of codes used for categorical variables from `view_TME_data_codes`

### Reference: countries, country groups, population and SDG indicators

* **cty**: Country and area names in 4 languages, their codes and WHO region and status from `view_TME_master_report_country`

* **datacoll**: Options set for the data collection form for each country-data collection year combinations from `view_TME_master_data_collection`

* **grptypes**: Themes by which to group countries from `view_country_group_types`

* **grp**: Country groups within each grouping theme (e.g. the 4 income groups of High, Upper Middle, Lower Middle and Low in the World Bank income classification) from `view_country_groups`

* **grpmbr**: Countries belonging to each country group from `view_country_group_membership`

* **pop**: UN Population Division population estimates from `view_TME_estimates_population`

* **sdg**: SDG indicator data and codes relevant to TB incidence from `external_indicators.view_indicator_data`

* **sdgdef**: Full names of SDG indicators and their sources from `"external_indicators.view_indicator_definition`

