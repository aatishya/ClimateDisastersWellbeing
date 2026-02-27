
********************************************************************************
/*

How Much do People Care about Climate Natural Disasters?
Aatishya Mohanty, Nattavudh Powdthavee, Cheng Keat Tang, Andrew J. Oswald

Updated: 31 January 2026  

*/

*********************************************************************************************************************************************
****Table 1 and 2.  Cross-National Life Satisfaction/ Equations with Disaster Variables – World Values Survey Data 1990 to 2018 
*********************************************************************************************************************************************


local myado "/Users/a/Library/Application Support/Stata/ado/personal/reg2hdfespatial" // Change this accordingly to your own personal ado folder
adopath + "`myado'"
which reg2hdfespatial

local myado "/Users/a/Library/Application Support/Stata/ado/personal/ols_spatial_HAC"  // Change this accordingly to your own personal ado folder
adopath + "`myado'"
which ols_spatial_HAC

cap: ssc install tmpdir
cap: ssc install hdfe
cap: ssc install reg2hdfe


capture program drop tmpdir
program define tmpdir, rclass
return local tmpdir "/tmp"
end


use wvs, clear
rename gid_1 GID_1
merge m:1 GID_1 using gadm/gadm36_1_data.dta, keep(match master) keepusing(y_center x_center)
rename y_center latitude
rename x_center longitude
rename GID_1 gid_1
egen region_id = group(gid_1)
merge m:1 region_id using "regions.dta", keep(match master) nogen
keep if !missing(region_id)


********************************************************************************
*** Set Sample
********************************************************************************

cap: drop inc1-inc10
cap: drop education1-education3
cap: drop religious* 
cap: drop kids_no*
cap: drop honest_no*

tab income1, gen (inc)
tab edu, gen(education)
tab religion, gen (religious)
tab kids, gen (kids_no)
tab honesty, gen(honest_no)
****************************

local varlist "satisfied happy"
local cl "reg"
foreach x in `varlist'{
eststo clear
cap: drop sample_`x'
local controls "age_21_30 age_31_40 age_41_50 age_51_60 age_abv_61 inc2 inc3 inc4 inc5 inc6 inc7 inc8 inc9 inc10 employed education2 education3 male married_dum divorced health_status1 health_status2 health_status3 health_status4 religious4 honest_no10"
qui: reghdfe `x' drought flood storm total_disaster `controls' , absorb(year reg) cl(`cl')
 gen sample_`x'=1 if e(sample)==1
}



*****with natural logs
************************************


local varlist "drought flood storm total_disaster"
foreach x in `varlist' {
gen l_`x'=ln(1+ `x')
	
}


local varlist "satisfied happy"
local disaster "l_storm l_flood l_drought l_total_disaster"
local cl "reg"
foreach x in `varlist'{
	eststo clear

	foreach d in `disaster'{

local age "age_21_30 age_31_40 age_41_50 age_51_60 age_abv_61"
local income "inc2 inc3 inc4 inc5 inc6 inc7 inc8 inc9 inc10 employed"
local gender "male married_dum divorced"
local education "education2 education3"
local health "health_status1 health_status2 health_status3 health_status4 religious4 honest_no10"

eststo: reg2hdfespatial `x' `d' `age' `income' `gender' `education' `health' if sample_`x'==1, timevar(year) panelvar(`cl') lat(latitude) lon(longitude) distcutoff(500) 
sum `x' if e(sample)==1
estadd scalar mean = r(mean)
sum `x' if e(sample)==1
estadd scalar sd = r(sd)
distinct country if e(sample)==1
estadd scalar grou = r(ndistinct)

	}
esttab using output/wvs_dis_`x'_conley_log_ci, rtf b(3) ci(3) nomtitle star(* 0.10 ** 0.05 *** 0.01) r2 obslast nogaps onecell stats(N r2 mean sd grou, fmt(0 2 0 2 2 0) label("Observations" "R-squared" "Mean Dep. Var." "Std. Dev." "No. of countries")) title(Table - Life Satisfaction/Happiness Equations with Disaster Variables – World Values Survey Data 1990 to 2018) keep(l_drought l_flood l_storm l_total_disaster) replace
}


****************************************************************************************************************************************************************
****Table S1A and S2A. Cross-National Life Satisfaction Equations with Disaster Variables – World Values Survey Data 1990 to 2018.  Inverse Hyperbolic Sine IHS Version.
****************************************************************************************************************************************************************


local varlist "drought flood storm total_disaster"
foreach x in `varlist' {
gen sine_`x'=asinh(`x')
	
}


local varlist "satisfied happy"
local disaster "sine_storm sine_flood sine_drought sine_total_disaster"
local cl "reg"
foreach x in `varlist'{
	eststo clear

	foreach d in `disaster'{

local age "age_21_30 age_31_40 age_41_50 age_51_60 age_abv_61"
local income "inc2 inc3 inc4 inc5 inc6 inc7 inc8 inc9 inc10 employed"
local gender "male married_dum divorced"
local education "education2 education3"
local health "health_status1 health_status2 health_status3 health_status4 religious4 honest_no10"

eststo: reg2hdfespatial `x' `d' `age' `income' `gender' `education' `health' if sample_`x'==1, timevar(year) panelvar(`cl') lat(latitude) lon(longitude) distcutoff(500) 
sum `x' if e(sample)==1
estadd scalar mean = r(mean)
sum `x' if e(sample)==1
estadd scalar sd = r(sd)
distinct country if e(sample)==1
estadd scalar grou = r(ndistinct)

	}
esttab using output/wvs_dis_`x'_conley_ihs_ci, rtf b(3) ci(3) nomtitle star(* 0.10 ** 0.05 *** 0.01) r2 obslast nogaps onecell stats(N r2 mean sd grou, fmt(0 2 0 2 2 0) label("Observations" "R-squared" "Mean Dep. Var." "Std. Dev." "No. of countries")) title(Table - Life Satisfaction/Happiness Equations with Disaster Variables – World Values Survey Data 1990 to 2018) keep(sine_drought sine_flood sine_storm sine_total_disaster) replace
}



**********************************************************************************************************************
****Table 3a.  U.S. Life Satisfaction Equations with Disaster Variables – United States Data 2005 to 2011 [GDIS data] 
**********************************************************************************************************************

use brfss_state.dta, replace


local varlist "drought flood storm total_disasters"
foreach x in `varlist' {
gen l_`x'=ln(1+ `x')
	
}

est clear

local controls "age18_24 age25_29 age30_34 age35_39 age40_44 age45_49 age50_54 age55_59 age60_64 age65_69 age70_74 age75_79 married divorced widowed separated never_married health_excel health_vgood health_fair health_poor i.income2 i.educa male"


eststo: reghdfe lfsat l_storm `controls', absorb(year state_fips) cl(state_fips)
distinct state_fips if e(sample)==1
estadd scalar group = r(ndistinct)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)

eststo: reghdfe lfsat l_flood `controls', absorb(year state_fips) cl(state_fips)
distinct state_fips if e(sample)==1
estadd scalar group = r(ndistinct)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)

eststo: reghdfe lfsat l_drought `controls', absorb(year state_fips) cl(state_fips)
distinct state_fips if e(sample)==1
estadd scalar group = r(ndistinct)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)

eststo: reghdfe lfsat l_total_disasters `controls', absorb(year state_fips) cl(state_fips)
distinct state_fips if e(sample)==1
estadd scalar group = r(ndistinct)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)


esttab * using output/results_usa_state, rtf b(3) ci(3) nomtitle star(* 0.10 ** 0.05 *** 0.01) /*
*/ r2 obslast nogaps onecell  /*
*/stats(N r2 mean sd group, fmt(0 2 0 2 2 0) label("Observations" "R-squared" "Mean Dep. Var." "Std. Dev." "No. of states"))/*
*/ title(Table: Logged Life Satisfaction Equations with Disaster Variables - United States Data 2005 to 2011) keep(l_storm  l_flood l_drought l_total_disasters) replace



***********************************************************************************************************************************************************
****Table 3b - U.S. Life Satisfaction Equations with Disaster Variables – United States Data 2005 to 2011 [Federal Emergency Management Agency, FEMA, data] 
***********************************************************************************************************************************************************

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


**************************************

est clear

local controls "age18_24 age25_29 age30_34 age35_39 age40_44 age45_49 age50_54 age55_59 age60_64 age65_69 age70_74 age75_79 married divorced widowed separated never_married health_excel health_vgood health_fair health_poor i.income2 i.educa male"

eststo: reghdfe lfsat l_storm_fema `controls', absorb(year _state) cl(_state)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)
distinct _state if e(sample)==1
estadd scalar grou = r(ndistinct)

eststo: reghdfe lfsat l_flood_fema `controls', absorb(year _state) cl(_state)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)
distinct _state if e(sample)==1
estadd scalar grou = r(ndistinct)

eststo: reghdfe lfsat l_total_disasters_fema `controls', absorb(year _state) cl(_state)
sum lfsat if e(sample)==1
estadd scalar mean = r(mean)
sum lfsat if e(sample)==1
estadd scalar sd = r(sd)
distinct _state if e(sample)==1
estadd scalar grou = r(ndistinct)


esttab * using output/results_usa_fema_st, rtf b(3) ci(3) nomtitle star(* 0.10 ** 0.05 *** 0.01) /*
*/ r2 obslast nogaps onecell  /*
*/stats(N r2 mean sd grou, fmt(0 2 0 2 2 0) label("Observations" "R-squared" "Mean Dep. Var." "Std. Dev." "No. of states"))/*
*/ title(Table: Logged Life Satisfaction Equations with Disaster Variables - United States FEMA Data 2005 to 2011 - state FE) keep(l_storm_fema  l_flood_fema l_drought_fema l_total_disasters_fema) append




