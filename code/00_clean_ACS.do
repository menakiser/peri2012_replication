/* Clean ACS data to obtain splits by STEM occupation
10/15/2025
mena kiser
*/

clear all
clear matrix
set mem 100m
set matsize 110

global wd "/Users/jimenakiser/liegroup Dropbox/Jimena Villanueva Kiser/peri2012_replication/"
global rd "/Users/jimenakiser/liegroup Dropbox/raw_backup/immigration_productivity/2025_10_10/data/"

* remember variable names
describe using "$rd/empl_wages_iv_state_60_06.dta"
/* variable names
statefip year howo_us_L howo_for_L empl_us_L empl_for_L hourly_us_L hourly_for_L howo_us_H howo_for_H empl_us_H empl_for_H hourly_us_H hourly_for_H foreign_pop foreign_imputed us_pop name state_code border_distance border_dummy ny_dist miami_dist la_dist */



use "$wd/data/usa_00046", clear

*data restrictions

//1) Eliminate people living in group quarters (military or convicts): those with the gq variable equal to 0, 3 or 4.
drop if inlist(gq, 0, 3, 4)

//2) Eliminate people younger than 17.
drop if age<=17

//3) Eliminate those who worked 0 weeks last year, which corresponds to wkswork2=0 in 1960 and 1970 and wkswork1=0 in 1980-1990-2000 and ACS.
drop if wkswork2==0 & year == 1960 | year == 1970
drop if wkswork1==0 & year >= 1980

//4) Once we calculate experience as age-(time first worked), where (time first worked) is 16 for workers
//with no HS degree, 19 for HS graduates, 21 for workers with some college education and 23 for college graduates,
//we eliminate all those with experience 1 and 40.

//5) Eliminate those workers who do not report valid salary income (999999
drop if incwage==999999 //already dropped with previous restrictions

//6)  Eliminate the self-employed (keeping those for whom the variable CLASSWKD is between 20 and 28).
drop if (classwkrd>=10 & classwkrd<= 19 )| classwkrd==29

*--------------------------------------------*
* individual variables

*education levels for internal use, combining educd and higraded
gen inteduc = 0 //left as zero if no answer
replace inteduc = 1 if (educd>=1 & educd<=50 )| educd==61 | (higraded>=10 & higraded<=142)  //less than high school (post1980) or less than grade 12 (pre1980)
replace inteduc = 2 if (educd>=62 & educd<=65)| (higraded>=150 & higraded<=152) //high school or ged or completed 12th grade (pre1980)
replace inteduc = 3 if (educd>=70 & educd<= 90) | (higraded>=160 & higraded<=182) //some college but no degree 
replace inteduc = 4 if (educd==101) | (higraded>=190 & higraded<=192) //bachelors or completed 4th year of college
replace inteduc = 5 if (educd>=110 & educd<999 ) | (higraded>=200 & higraded<999 ) //over 4 years of college

*education
gen L = inteduc>=1 & inteduc<=2  //high school or less
gen H = inteduc>=3 //at least some college 

* potential experience
gen age_firstwrk = 0
replace age_firstwrk = 17 if inteduc==1 //less than high school
replace  age_firstwrk = 19 if inteduc==2 //high school
replace age_firstwrk = 21 if inteduc==3 //some college but no degree
replace age_firstwrk = 23 if inteduc>=4 //college degree or more  
gen potential_exp = age-age_firstwrk
* immigration status
gen imm = bpld>= 1500 & bpld!=90011 & bpld!=90021 //born outside of the us and territories
replace imm = 0 if citizen==1 //exclude born abroad to american parents, naturalized citizens and non-citizens are included

* weeks worked in a year
replace wkswork1 = 6.5 if wkswork2==1 & (year==1960 | year==1970)
replace wkswork1 = 20 if wkswork2==2 & (year==1960 | year==1970)
replace wkswork1 = 33 if wkswork2==3 & (year==1960 | year==1970)
replace wkswork1 = 43.5 if wkswork2==4 & (year==1960 | year==1970)
replace wkswork1 = 48.5 if wkswork2==5 & (year==1960 | year==1970)
replace wkswork1 = 51 if wkswork2==6 & (year==1960 | year==1970)
replace wkswork1 = . if wkswork1==0

* hours worked in a week
replace uhrswork = 7.5 if hrswork2==1 & (year==1960 | year==1970)
replace uhrswork = 22 if hrswork2==2 & (year==1960 | year==1970)
replace uhrswork = 32 if hrswork2==3 & (year==1960 | year==1970)
replace uhrswork = 37 if hrswork2==4 & (year==1960 | year==1970)
replace uhrswork = 40 if hrswork2==5 & (year==1960 | year==1970)
replace uhrswork = 44.5 if hrswork2==6 & (year==1960 | year==1970)
replace uhrswork = 54 if hrswork2==7 & (year==1960 | year==1970)
replace uhrswork = 70 if hrswork2==8 & (year==1960 | year==1970)
replace uhrswork = . if uhrswork==0 //top coded at 99

* yearly wages 







* STEM OCCUPATION
gen stemocc=0
replace stemocc = 1 if inlist(occ2010,110, 300, 360 )
replace stemocc = 1 if occ2010>=1000 & occ2010<=1240
replace stemocc = 1 if occ2010>=1310 & occ2010<=1560
replace stemocc = 1 if occ2010>=1600 & occ2010<=1965
replace stemocc = 1 if occ2010==4930

gen stemdeg = 0
replace stemdeg = 1 if degfieldd>=2400 & degfieldd<=2499 //engineering
replace stemdeg = 1 if degfieldd>=2500 & degfieldd<=2599 //bio
replace stemdeg = 1 if degfieldd>=3700 & degfieldd<=3799 //math stats
replace stemdeg = 1 if degfieldd>=5000 & degfieldd<=5099 //physical sciences
replace stemdeg = 1 if degfieldd>=2400 & degfieldd<=2499 //engineering
