************************************************************************************************************

/* This do-file contains codes for the following -

1. Match WVS regions to GADM polygons
2. Match CRU coordinates to GADM polygons
3. Match GDIS coordinates to GADM polygons

4a. Create an individual level dataset of the WVS with CRU climate and GDIS disaster variables. 
4b. Create a region level climate-disaster dataset with CRU and GDIS variables. 

Note - the GADM polygon variable is gid_1 (first level of sub-division) in all files.


Updated: 5 Dec 2023
      */

************************************************************************************************************

***********************************************************
* Part I: Matching WVS longitudinal data to GADM regions
***********************************************************

* cd ""
use WVS/WVS_TimeSeries_stata_v1_6, replace


//Step 1: Get coordinates for regions which have a ISO 3166-2 code

decode X048ISO, gen (reg_iso)
decode S003, gen(country)
contract X048ISO reg_iso S003
drop _freq
drop if reg_iso==""


split reg_iso
egen region = concat(reg_iso2 reg_iso3 reg_iso4 reg_iso5 reg_iso6 reg_iso7 reg_iso8 reg_iso9), punct(" ")
drop reg_iso9 reg_iso8 reg_iso7 reg_iso6 reg_iso5 reg_iso4 reg_iso3 reg_iso2

opencagegeo, key(12bbfc1f09a74c7881659c200c213103) country(country) state(region)    //API key from https://opencagedata.com //

save WVS/wvs_match1.dta


//Step 2: Get coordinates for regions which dont have a ISO 3166-2 code

clear
use WVS/WVS_TimeSeries_stata_v1_6, replace

keep if X048ISO==.
br X048WVS X048ISO      //to check
contract S003 X048WVS
drop _freq
drop if X048WVS==.

decode S003, gen(country)
decode X048WVS, gen(wvsreg)

replace wvsreg="GB: Wales" if wvsreg=="GB:Wales"
replace wvsreg="EE: Central Estonia" if wvsreg=="EE:Central Estonia"
replace wvsreg="EE: North Estonia" if wvsreg=="EE:North Estonia"
replace wvsreg="EE: South Estonia" if wvsreg=="EE:South Estonia"

split wvsreg
egen region = concat(wvsreg2 wvsreg3 wvsreg4 wvsreg5 wvsreg6 wvsreg7 wvsreg8 wvsreg9 wvsreg10), punct(" ")
drop wvsreg10 wvsreg9 wvsreg8 wvsreg7 wvsreg6 wvsreg5 wvsreg4 wvsreg3 wvsreg2 wvsreg1

replace region = subinstr(region, "-", "", .)
replace region = subinstr(region, "area", "", .)
replace region = subinstr(region, "region", "", .)
replace region = strrtrim(region)

replace region="Southern Albania" if region=="ALBANIA  Southern Albania"
replace region="Central Albania" if region=="ALBANIA  Central Albania"
replace region="Northern Albania" if region=="ALBANIA  Northern Albania"

replace region="Republica Srpska" if region=="BOSNIA AND HERZEGOVINA  Republica Srpska"
replace region="Federation of Bosnia i Herzegov" if region=="BOSNIA AND HERZEGOVINA  Federation of Bosnia i Herzegov"

replace region="Huazhong" if region=="Hua'zhong"
replace region="Huabei" if region=="Hua'bei"
replace region="Huadong" if region=="Hua'dong"
replace region="Zhongnan" if region=="Zhong'nan"
replace region="Xinan" if region=="Xi'nan"

replace region="Central Bohemia" if region=="Støedoèeský kraj  Central Bohemia"
replace region="West Bohemia" if region=="Západoèeský kraj  West Bohemia"
replace region="South Bohemia" if region=="Jihoèeský kraj  South Bohemia"
replace region="North Bohemia" if region=="Severoèeský kraj  North Bohemia"
replace region="East Bohemia " if region=="Východoèeský kraj  East Bohemia"
replace region="South Moravia" if region=="Jihomoravský kraj  South Moravia"
replace region="North Moravia" if region=="Severomoravský kraj  North Moravia"

replace region="Northeastern Estonia" if region=="NorthEastern Estonia"

*Note - The provinces in Finland have changed thrice 1918. These are matched to the best aproximate region of today.
replace region="North Karelia" if region=="PohjoisKarjala"
replace region="Central Finland" if region=="KeskiSuomi"
replace region="Southwest Finland" if region=="Turun ja Porin"
replace region="Kanta-Häme" if region=="Hämeen"
replace region="Kymenlaakso" if region=="Kymen"
replace region="South Savo" if region=="Mikkelin"
replace region="North Savo" if region=="Kuopion"
replace region="Ostrobothnia" if region=="Vaasan"
replace region="North Ostrobothnia" if region=="Oulun"
replace region="Lapland" if region=="Lapin"

replace region="Izabal" if region=="Oriente/Izabal/Verapaces"

replace region="North Danubian" if region=="NorthDanubian"
replace region="South Danubian" if region=="SouthDanubian"
replace region="Central Hungary" if region=="CentralHungary"

*Note - Some regions in Japan have been clubbed together in WVS. They are matched to the province with the larger population.
replace region="Tohuku" if region=="Hokkaido/Tohoku"
replace region="Chubu" if region=="Chubu,Hokuriku"
replace region="Kyushu" if region=="Chugoku,Shikoku,Kyushu,Okinawa"
replace region="Kanto" if region=="KitaKanto"

replace region="North" if region=="MontenegroNorth"
replace region="Central" if region=="MontenegroCenter"
replace region="Coastal" if region=="MontenegroSouth"

*Note - Norway regions are based on NUTS-2
replace region="Oslo and Akershus" if region=="NO01Oslo and Akershus"
replace region="Hedmark and Oppland" if region=="NO02Hedmark and Oppland"
replace region="Vestfold" if region=="NO03SouthEastern Norway"
replace region="Agder and Rogaland" if region=="NO04Agder and Rogaland"
replace region="Western Norway" if region=="NO05Western Norway"
replace region="Trøndelag" if region=="NO06Trøndelag"

replace region="North" if region=="Norte"
replace region="South" if region=="Sur"
replace region="West" if region=="Oeste"
replace region="East" if region=="Este"
replace region="Central" if region=="Centro"

replace region="Bucharest" if region=="Bucuresti"
replace region="Greater Wallachia" if region=="Mutenia"
replace region="Dobruja" if region=="Dobrogia"

replace region="Bratislava Region" if region=="SK01 Bratislava Region (Bratislavský kraj)"
replace region="Central Slovakia" if region=="SK03 Central Slovakia (Stredné Slovensko)"
replace region="Eastern Slovakia" if region=="SK04 Eastern Slovakia (Východné Slovensko)"
replace region="Western Slovakia" if region=="SK02 Western Slovakia (Západné Slovensko)"

replace region="Mura" if region=="Pomurska"
replace region="Drava" if region=="Podravska"
replace region="Carinthia" if region=="Koroska"
replace region="Savinja" if region=="Savinjska"
replace region="Upper Carniola" if region=="Gorensjka"
replace region="Central Sava" if region=="Zasavska"
replace region="Gorizia" if region=="Goriska"
replace region="Coastal–Karst" if region=="ObalnoKraska"
replace region="Southeast Slovenia" if region=="JV Slovenija"
replace region="Littoral–Inner Carniola" if region=="Notr.  Kraska"
replace region="Central Slovenia" if region=="Osrednjeslovenska"
replace region="Lower Sava" if region=="Spodnjeposavska"

replace region="Ankara" if region=="Ankara (center)"

replace region="Skopje" if region=="Skopski"
replace region="Pelagonia" if region=="Pelagoniski"
replace region="Southwestern" if region=="Ohridski"
replace region="Polog" if region=="Poloski"
replace region="Northeastern" if region=="Kumanovski"
replace region="Vardar" if region=="Vardarska"
replace region="Eastern" if region=="Bregalnicki"

*Note - Some regions in Venezuela have been clubbed together in WVS. They are matched to the province with the larger population.
replace region="Miranda" if region=="Capital: D.F./Miranda"
replace region="Falcon" if region=="Occidental: Zulia/Falcón"
replace region="Aragua" if region=="Central: Aragua, Carabobo, Lara"
replace region="Amazonas" if region=="Oriente:Anzoátegui,Bolivar,Sucre,Monagas,Espar.,Amazon"
replace region="Trujillo" if region=="Andes: Mérida, Táchira, Trujillo"
replace region="Cojedes" if region=="Llanos: Apure,Barinas,Portuguesa,Cojedes,Guárico,Yaracuy"


kountry country , from(other) marker stuck
rename _ISO3N_ code
drop MARKER
kountry code , from(iso3n) to(iso2c) marker     //check marker before next step
drop code MARKER

rename _ISO2C_ code
replace code="TW" if country=="Taiwan ROC"
replace code="MK" if country=="North Macedonia"

opencagegeo, key(12bbfc1f09a74c7881659c200c213103) country(country) state(region)    //API key from https://opencagedata.com

save WVS/wvs_match2.dta

//To check results in BOTH dta files 

gen c_match=1 if country== g_country
replace c_match=. if g_quality==1
sort c_match
br country region g_formatted g_quality c_match            //Note - Now manually check all the results

destring, replace
replace g_lat=. if c_match==.
replace g_lon=. if c_match==.

//Spatial join to GADM polygon
geoinpoly g_lat g_lon using "WVS/gadm_coordinates.dta"
tab _ID, missing
        
merge m:1 _ID using "WVS/gadm1_data.dta", keep(master match) nogen

save WVS/wvs_match1.dta, replace                                //repeat spatial join for wvs_match2.dta


//Merge manually matched regions

import WVS/excel wvs-gadm_match.xlsx, sheet("gadm_match1") firstrow clear     //Manual match of unmatched regions
save WVS/match1.dta, replace

use WVS/wvs_match1.dta, replace 
merge 1:1 reg_iso1 region using WVS/match1.dta
drop _me Notes
replace gid_1= gid_1a if gid_1==""
save WVS/wvs_match1.dta, replace      

tab reg_iso if gid_1==""      //now manually check the rest of the blank regions   

import excel WVS/wvs-gadm_match.xlsx, sheet("gadm_match1a") firstrow clear   //Manual match of rest of the blank regions
save WVS/match1a.dta, replace

use WVS/wvs_match1.dta, replace 
merge 1:1 reg_iso1 region using WVS/match1a.dta
drop _me
replace gid_1= gid_1b if gid_1==""
save WVS/wvs_match1.dta, replace      
                
keep reg_iso gid_1
save WVS/wvs_reg1.dta, replace


****
import excel WVS/wvs-gadm_match.xlsx, sheet("gadm_match2") firstrow clear     //Manual match of unmatched regions
keep id gid_1
save WVS/match2.dta, replace

use WVS/wvs_match2.dta, replace 
merge 1:1 id using WVS/match2.dta
drop _me
replace gid_1= gid_1a if gid_1==""
save WVS/wvs_match2.dta, replace                              

tab X048WVS if gid_1==""      //now manually check the rest of the blank regions                        

import excel WVS/wvs-gadm_match.xlsx, sheet("gadm_match2a") firstrow clear     //Manual match of rest of the blank regions
keep id gid_1b
save WVS/match2a.dta, replace

use WVS/wvs_match2.dta, replace 
merge 1:1 id using WVS/match2a.dta
drop _me
replace gid_1= gid_1b if gid_1==""
save WVS/wvs_match2.dta, replace    

keep country wvsreg gid_1
rename gid_1 gid_1a
replace wvsreg="GB:Wales" if wvsreg=="GB: Wales"
save WVS/wvs_reg2.dta, replace                          


//Merge matched files to master WVS data

clear
use WVS/WVS_TimeSeries_stata_v1_6, replace

decode X048ISO, gen (reg_iso)
decode S003, gen(country)
decode X048WVS, gen(wvsreg)

merge m:1 reg_iso using WVS/wvs_reg1.dta
drop _me

merge m:1 country wvsreg using WVS/wvs_reg2.dta
drop _me

replace gid_1= gid_1a if gid_1==""
drop gid_1a
gen wave= S002
gen year=S020

save wvs.dta, replace


********************************************************************************
* Part II: Generate Yearly Disaster Observations from GDIS
********************************************************************************

//NOTE: gdis.csv is the raw data. It was joined to gadm sub-region polygons using QGIS

** Spatial Join in QGIS
import delimited using gdis/gdis_join.csv, clear
rename aarthquake earthquake

** Generating annual counts of disasters by country
local varlist "drought earthquake extreme_temperature flood storm"
collapse (sum) `varlist', by (gid_1 year)
drop if year==.
save gdis/gadm_gdis, replace

* generating balanced panel: expand data by number of years in sample: (2020-1960)+1
contract gid_1
expand 59
sort gid_1
by gid_1: gen year = _n+1959
sort gid_1 year
tab year

save gdis/balanced.dta, replace

use gdis/gadm_gdis, replace
merge 1:1 gid_1 year using gdis/balanced
drop _freq _merge

local varlist "drought earthquake extreme_temperature flood storm"
foreach x in `varlist'{
replace `x' =0 if `x'==.
}

egen total_disaster = rowtotal(drought earthquake flood storm)

save gadm_gdis, replace

 
 *******************************************************************************
* Part III: Merge WVS with GDIS data
*       Individual level WVS dataset with climate and disaster data
********************************************************************************
 
 use wvs, replace


merge m:1 gid_1 year using gdis/gadm_gdis
drop if _me==2
drop _me

save, replace

********************************************************************************
*** Recoding WVS variables
********************************************************************************

gen happy = A008
replace happy=. if (happy <0)
replace happy = 4-happy
label var happy "Feeling of happiness (0)Not at all - (3)Very happy; A008"

gen satisfied = A170
replace satisfied=. if (satisfied <0)
label var satisfied "Satisfaction with your life (1) Dissatisfied - (10)Satisfied; A170"



********************************************************************************
*** Generating controls and other variables
********************************************************************************

gen age =X003
gen age_sq = age^2

* age dummies
g age_bel_21 = 1 if age<=21
replace age_bel_21 = 0 if age_bel_21==.

forvalues x = 21(10)51{
local y = `x' + 9
gen age_`x'_`y' = 1 if age>`x' & age<=`y'
replace age_`x'_`y' = 0 if age_`x'_`y' ==.	
}

g age_abv_61 = 1  if age>61
replace age_abv_61 = 0 if age_abv_61==.

gen income1 = X047
replace income1=. if (income1 <0)
label variable income1 "Scale of incomes: lowest (1) highest (10); X047"

gen income2 = X047
replace income2=. if (income2 <0)
recode income2 (1/3=1) (4/7=2) (8/10=3)
label variable income2 "Scale of incomes: recoded low(1-3) middle(4-7) high(8-10); X047"

gen edu = X025R
replace edu=. if (edu <0)
label variable edu "Education level: lowest(1) medium (2) highest (3); X025R"

gen male = X001
replace male=. if (male <0)
replace male=0 if male==2
label variable male "Sex of respondent: Male(1) female(0); X001"

gen freedom = A173
replace freedom=. if (freedom <0)
label variable freedom "Freedom of choice & control: lowest (1) highest (10); A173"

gen employed = X028
recode employed (1/3=1) (4/9=0)
label variable employed "Employment status: employed (1) unemployed/others (0); A173"

gen married = X007
recode married (1/2=1) (3/8=0)
label variable married "Marital status: Married/living tog (1) Others (0); X007"

tab X007, gen(m)
rename (m1 m2 m3 m4 m5 m6)(married_dum cohabit divorced seperated widowed single)

gen honesty = F116
replace honesty=. if (honesty <0)
replace honesty=10-honesty
label variable honesty "Justifiable to cheat on taxes: recoded Always (0) Never (10); F116"

gen trust = A165
recode trust (2=0)
label variable trust "Most people can be trusted: Yes (1) No (0); A165"

gen religion = A006
replace religion = 4-religion
label variable religion "Importance of religion: recoded Not at all (0) Very imp. (3); A006"

gen health=A009
replace health = 5-health
label variable health "Subjective health state: recoded very poor (0) very good(4); A009"

gen family = A001
replace family = 4-family
label variable family "Importance of family: recoded Not at all (0) Very imp. (3); A001"

gen work = A005
replace work = 4-work
label variable work "Importance of work: recoded Not at all (0) Very imp. (3); A005"

gen pol_orient = E033
label var pol_orient "Political orientation: Left (1) Right (2); E033"

gen urban = X050C
recode urban (2=0)
label var urban "Urban dummy; X050C"

gen leisure = A003
replace leisure = 4-leisure
label variable leisure "Importance of leisure: recoded Not at all (0) Very imp. (3); A003"

gen kids = X011
label variable kids "No. of children; X011" 

egen c=group(country)
label var c "Obs grouped by country"

egen reg=group(wvsreg)
label var reg "Obs grouped by wvs  region"


tab health, gen(health_status)
label var health_status1 "Health (very poor)"
label var health_status2 "Health (poor)"
label var health_status3 "Health (normal)"
label var health_status4 "Health (good)"
label var health_status5 "Health (very good)"

********************************************************************************
*** label disaster variables
********************************************************************************

rename gid_1 GID_1
merge m:1 GID_1 using gadm/gadm36_1_data.dta
drop if _me==2
drop _me x_center y_center GID_0 VARNAME_1 NL_NAME_1 TYPE_1 ENGTYPE_1 CC_1 HASC_1
rename GID_1 gid_1 
rename NAME_0 country
rename NAME_1 region
drop ID

label var gid_1 "Sub-region code, GADM"

label var drought "Annual count of droughts"
label var earthquake "Annual count of earthquakes"
label var extreme_temperature "Annual count of extreme temperature"
label var flood "Annual count of floods"
label var storm "Annual count of storms"
label var total_disaster "Annual count of total disasters"


label var cld "Avg. annual cloud cover"
label var dtr "Avg. annual Diurnal temperature range"
label var frs "Avg. annual frost days"
label var pet "Avg. annual potential evapotranspiration"
label var pre "Avg. annual precipitation"
label var tmn "Avg. annual min. temperature"
label var tmp "Avg. annual temperature"
label var tmx "Avg. annual max. temperature"
label var vap "Avg. annual vapour pressure"
label var wet "Avg. annual wet days"

save wvs, replace
