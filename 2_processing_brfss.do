*************************************************
//Processing and assembling the following datasets -

// BRFSS
// GDIS
// FEMA
*************************************************

********************************************************************************
* Assemble BRFSS
********************************************************************************

use cdbrfs05.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2005_cleaned.dta, replace

use cdbrfs06.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2006_cleaned.dta, replace

use cdbrfs07.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2007_cleaned.dta, replace

use cdbrfs08.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2008_cleaned.dta, replace

use cdbrfs09.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2009_cleaned.dta, replace

use cdbrfs10.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2010_cleaned.dta, replace

use llcp2011.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2011_cleaned.dta, replace

use llcp2012.xpt.dta, clear
keep _state     idate imonth iday iyear ctycode numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2012_cleaned.dta, replace

use llcp2013.xpt.dta, clear
keep _state     idate imonth iday iyear numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2013_cleaned.dta, replace

use BRFSS/llcp2014.xpt.dta, clear
keep _state     idate imonth iday iyear numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2014_cleaned.dta, replace

use BRFSS/llcp2015.xpt.dta, clear
keep _state     idate imonth iday iyear numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2015_cleaned.dta, replace

use BRFSS/llcp2016.xpt.dta, clear
keep _state     idate imonth iday iyear numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2016_cleaned.dta, replace

use BRFSS/llcp2017.xpt.dta, clear
keep _state     idate imonth iday iyear numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy qlmentl2 qlstres2  qlhlth2 _prace  sex
save BRFSS2017_cleaned.dta, replace

use BRFSS/llcp2022.xpt.dta, clear
rename income3 income2
keep _state     idate imonth iday iyear numadult genhlth menthlth  _ageg5yr marital children educa employ income2 lsatisfy  _prace  sex
save BRFSS/BRFSS2022_cleaned.dta, replace



**Append
use BRFSS/BRFSS2005_cleaned.dta, clear
append using BRFSS/BRFSS2006_cleaned.dta
append using BRFSS/BRFSS2007_cleaned.dta
append using BRFSS/BRFSS2008_cleaned.dta
append using BRFSS/BRFSS2009_cleaned.dta
append using BRFSS/BRFSS2010_cleaned.dta
append using BRFSS/BRFSS2011_cleaned.dta
append using BRFSS/BRFSS2012_cleaned.dta
append using BRFSS/BRFSS2013_cleaned.dta
append using BRFSS/BRFSS2014_cleaned.dta
append using BRFSS/BRFSS2015_cleaned.dta
append using BRFSS/BRFSS2016_cleaned.dta
append using BRFSS/BRFSS2017_cleaned.dta
append using BRFSS/BRFSS2022_cleaned.dta


cd ""
save brfss.dta, replace

**Labeling
gen lfsat = 1 if lsatisfy==4
replace lfsat = 2 if lsatisfy==3
replace lfsat = 3 if lsatisfy==2
replace lfsat = 4 if lsatisfy==1
lab def lfsat 1 "Very dissatisfied" 2 "Dissatisfied" 3 "Satisfied" 4 "Very satisfied"
lab val lfsat lfsat
drop lsatisfy

replace qlmentl2 = 0 if qlmentl2==88 
replace qlmentl2 = . if qlmentl2==77 | qlmentl2==99

replace qlstres2  = 0 if qlstres2 ==88 
replace qlstres2  = . if qlstres2 ==77 | qlstres2 ==99

replace qlhlth2  = 0 if qlhlth2 ==88 
replace qlhlth2  = . if qlhlth2 ==77 | qlhlth2 ==99

destring iyear,  replace

 
tab _ageg5yr, gen(age)
rename age1 age18_24
rename age2 age25_29
rename age3 age30_34
rename age4 age35_39
rename age5 age40_44
rename age6 age45_49
rename age7 age50_54
rename age8 age55_59
rename age9 age60_64
rename age10 age65_69
rename age11 age70_74
rename age12 age75_79
rename age13 age80
drop age14   //its measured for no response

replace income2=. if income2==77 | income2==99   //refused to respond or not answered

replace educa=. if educa==9  //refused to respond

tab marital, gen(married)
drop married7 //refused to response

rename married1 married
rename married2 divorced
rename married3 widowed
rename married4 separated
rename married5 never_married

tab genhlth, gen(genhlth)     // genhlth6 genhlth7 //refused to respond or not answered

rename genhlth1 health_excel
rename genhlth2 health_vgood
rename genhlth3 health_good
rename genhlth4 health_fair
rename genhlth5 health_poor

replace children=0 if children==88   //no kids
replace children=. if children==99   //refused to respond

tab employ1, gen(employ_)
rename employ_1 employed
rename employ_2 selfemployed
drop employ_9  //refused to respond

tab sex, gen(sex)
rename sex1 male
rename sex2 female
drop sex3 //refused to respond

***********************
**Convert county codes into 4/5 digit FIPS codes

replace ctycode=. if ctycode==777  //not answered
replace ctycode=. if ctycode==999  //refused to respond

tostring _state, gen(string1) format("%02.0f") 
tostring ctycode, gen(string2) format("%03.0f")
egen county_fips = concat(string1 string2)
replace county_fips="" if strpos(county_fips,".")>0
destring county_fips, replace


*******************************************
rename iyear year

save brfss.dta, replace



********************************************************************************
* Get GDIS disaster data 
********************************************************************************
use gdis/gdis.dta 

******************************

//Convert the shapefile to Stata datasets
shp2dta using US_County_Boundaries/US_County_Boundaries.shp, ///
    genid(_ID) data("US_County_Boundaries.dta") coor("US_County_Boundaries_coor.dta") replace


geoinpoly latitude longitude using "US_County_Boundaries_coor.dta"
tab _ID, missing
        
merge m:1 _ID using "US_County_Boundaries.dta", keep(master match) nogen

drop if STFIPS==""

rename STFIPS state_fips

*Collapse CRU variables by year

rename aarthquake earthquake
 
collapse (sum) drought earthquake extreme_temperature flood storm,	by (state_fips year)

destring state_fips, replace


save gdis/gdis_usa_state.dta, replace



preserve 
use brfss, replace
duplicates drop _state, force
keep _state
rename _state state_fips
expand 2018-1960+1
sort state_fips
by state_fips: gen year = _n+1959
save gdis_county_panel_state.dta, replace 
restore 


********************************************************************************
* Match to BRFSS data
********************************************************************************


use brfss.dta, replace

drop if _state==.
rename _state state_fips
merge m:1 state_fips year using gdis_usa_state

drop if _me==2
drop _me

drop if state_fips==78
drop if state_fips==72
drop if state_fips==02
drop if state_fips==15


save brfss_state,replace 

********************************************************************************
* Get FEMA disaster data 
********************************************************************************

/*
Notes:
- Data is downloaded from https://www.fema.gov/about/openfema/data-sets#disaster
- Refer to the section on Disaster Information
*/


local filelist "FemaWebDeclarationAreas FemaWebDisasterDeclarations FemaWebDisasterSummaries"

foreach f in `filelist'{
import delimited using `f'.csv, clear
sa `f'.dta, replace
}

* Preparing disaster details for matching:
use FemaWebDisasterDeclarations.dta, clear

local datelist "declarationdate incidentbegindate incidentenddate"
foreach d in `datelist'{
split `d', p("T")
split `d'1, p("-")
rename (`d'11 `d'12 `d'13)(year month day)
destring year month day, replace force
gen `d'_d = mdy(month, day, year)
format `d'_d %td
label var `d'_d "`d' date"
drop `d'1 `d'2 year month day
}

local varlist "declarationdate_d incidentbegindate_d incidentenddate_d disasternumber disastername statecode statename incidenttype region declarationtype"
keep `varlist'
sa FEMA_disaster_details.dta, replace


/*
Notes:
- ID for disaster is disaster_number
- Classification for disaster type is incidenttype - we need to recategorize them to make sense.
- We can use declaration date (year)
- County code is placecode. 
- In this incident data, it is possible to have multiple funding requests for different projects associated with the same disaster - we will probably need to collapse that and consider that as one disaster incident.
- Presumably, we will count the number of counties affected by the accidents based on the funding assistance incidents. 
- Program description type tells us the different type of requests made. 
*/


** Preparing FEMA disaster funding request data at micro-area county levels:
use FemaWebDeclarationAreas.dta, clear

* merging in disaster date details
merge m:1 disasternumber using FEMA_disaster_details.dta, keep(match master) nogen 

* dropping duplicates: multiple incidents 
duplicates drop disasternumber placecode, force 

* generating diastertype:
gen year = year(declarationdate_d)
keep if declarationtype=="Major Disaster"
tab incidenttype, gen(disaster_t)

gen storm=1 if disaster_t2==1 | disaster_t14==1 | disaster_t15==1 | disaster_t20==1 | disaster_t24==1
replace storm=0 if storm==.

rename disaster_t8 flood
rename disaster_t4 drought

* collapsing disasters by year (we should try aggregate the disaster type up)
collapse (firstnm) statecode statename placename  (sum) storm flood drought, by (placecode year)

replace statename = strrtrim( statename )
merge m:1 statename using state_name                            //statename brought over from BRFSS 
drop if _me==2
drop _me 

* Create county fips with missing for non-standard codes
// Note from the FEMA website - placeCode: "A unique code system FEMA uses internally to recognize locations that takes the numbers '99' + the 3-digit county FIPS code. There are some declared locations that dont have recognized FIPS county codes in which case we assigned a unique identifier"

gen cty_fips = .
replace cty_fips = mod(placecode, 1000) if int(placecode/1000) == 99

* See the distribution of starting digits
gen first_two = int(placecode/1000)
tab first_two

* Count valid FIPS (starting with 99)
count if int(placecode/1000) == 99

* Create 5-digit FIPS with leading zeros preserved
gen county_fips = string(_state, "%02.0f") + string(cty_fips, "%03.0f")

replace county_fips="" if county_fips==".."
destring county_fips, replace

merge m:1 county_fips using county_fips                    //county_fips brought over from BRFSS 
drop if _me==1                                             //not in brfss
drop _me

rename storm storm_fema
rename flood flood_fema
rename drought drought_fema

egen total_disasters_ferma = rowtotal(storm_fema flood_fema)

save fema_disaster_county_year.dta, replace


********************************************************************************
* Match to BRFSS data
********************************************************************************

use brfss, replace

 merge m:1 county_fips year using FEMA\fema_disaster_county_year

drop if _me==2
drop _me


**************
rename total_disasters_ferma total_disasters_fema 

local varlist "flood_fema storm_fema total_disasters_fema"
foreach x in `varlist' {
replace `x'=0 if `x'==.
}

local varlist "flood_fema storm_fema total_disasters_fema"
foreach x in `varlist' {
gen l_`x'=ln(1+`x')
	
}

save brfss, replace
