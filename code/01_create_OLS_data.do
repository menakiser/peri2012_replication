/* generating data for OLS table 1 creation from Peri (2012)
*/

clear
clear matrix
set mem 100m
set matsize 110

global wd "/Users/jimenakiser/liegroup Dropbox/Jimena Villanueva Kiser/peri2012_replication/"
global rd "/Users/jimenakiser/liegroup Dropbox/raw_backup/immigration_productivity/2025_10_10/data/"


/* data with employment hours, immigrants and imputed immigrants */
insheet using "$rd/cap_gsp_60_08.csv", clear //fips, state, gsp, and capital
drop if fips==0
gen statefip=fips
drop state fips
keep if year== 1960 | year==1970 |year==1980 | year==1990 | year==2000 |year==2006
sort year statefip
merge 1:1 year statefip using "$rd/empl_wages_iv_state_60_06.dta"
drop _merge
sort statefip year


** generate labor supply, (hours and employment) and wages for more and less educated
gen empl=empl_us_H+empl_for_H+empl_us_L+empl_for_L
gen hours=howo_for_L+howo_for_H+howo_us_L+howo_us_H
gen hours_perworker=hours/empl

gen hours_perworker_us=(howo_us_L+howo_us_H)/(empl_us_H+empl_us_L)
gen empl_for=empl_for_H+empl_for_L
gen empl_us=empl_us_H+empl_us_L

gen hourly_H=(hourly_us_H*howo_us_H+hourly_for_H*howo_for_H)/(howo_us_H+howo_for_H)
gen hourly_L=(hourly_us_L*howo_us_L+hourly_for_L*howo_for_L)/(howo_us_L+howo_for_L)

gen w_H=(hourly_us_H*howo_us_H+hourly_for_H*howo_for_H)/(howo_us_H+howo_for_H)
gen w_L=(hourly_us_L*howo_us_L+hourly_for_L*howo_for_L)/(howo_us_L+howo_for_L)


** generate share of hours worked by high skilled
gen h=(howo_for_H+howo_us_H)/hours
gen h_us=(howo_us_H)/(howo_us_L+howo_us_H)

** generate percentage increase in total employment, and hours per person and share of high skilled
sort statefip year

gen d_hours_perworker=(hours_perworker-hours_perworker[_n-1])/hours_perworker[_n-1] if year>1960
//or gen d_hours_perworker=ln(hours_perworker)-ln(hours_perworker[_n-1]) if year>1960
gen d_empl=(empl-empl[_n-1])/empl[_n-1] if year>1960
gen d_empl_lag=d_empl[_n-1] if year>1970
gen d_hours_perworker_lag=d_hours_perworker[_n-1] if year>1970
gen d_h=(h-h[_n-1])/h  if year>1960
//or gen d_h=ln(h)-ln(h[_n-1]) if year>1960
gen d_h_lag=d_h[_n-1] if year>1970

**explanatory variable
gen d_immi_empl=(empl_for-empl_for[_n-1])/empl[_n-1] if year>1960
gen d_immi_pop=(foreign_pop-foreign_pop[_n-1])/(foreign_pop[_n-1]+us_pop[_n-1]) if year>1960
gen d_immi_imputed=(foreign_imputed-foreign_imputed[_n-1])/(foreign_imputed[_n-1]+us_pop[_n-1]) if year>1960


/* capital and GSP manipulations*/
gen gsp_worker=(gsp*1000000000)/empl
gen gsp_worker_lag=gsp_worker[_n-1]

/* cap per worker a'la garofal-yamarik */
gen kap=(cap*1000000000)
gen kap_worker=(cap*1000000000)/empl
gen k_y_ratio=(kap_worker/gsp_worker)


/** construct the betas from the formula in the text****/
gen alpha=0.33
gen sigma=1.75

gen beta=( (w_H)^(sigma/(sigma-1)) * h^(1/(sigma-1)) )/( (w_H)^(sigma/(sigma-1)) * h^(1/(sigma-1)) + (w_L)^(sigma/(sigma-1)) * (1-h)^(1/(sigma-1)) )
gen phi=( (beta*h)^((sigma-1)/sigma) + ((1-beta)*(1-h))^((sigma-1)/sigma) )^(sigma/(sigma-1))
gen A=(gsp_worker^(1/(1-alpha)))*(kap_worker^(-alpha/(1-alpha)))*(hours_perworker^(-1))*(phi^(-1))

sort statefip year
*** percentage changes:

gen d_beta=ln(beta)-ln(beta[_n-1]) if year>1960
gen d_phi=ln(phi)-ln(phi[_n-1]) if year>1960
gen d_A=ln(A)-ln(A[_n-1]) if year>1960
gen lnA=ln(A[_n-1])
gen lnA_lag=lnA[_n-1]

gen lnbeta=ln(beta[_n-1])

gen d_A_lag=d_A[_n-1] if year>1970
gen d_beta_lag=d_beta[_n-1] if year>1970
gen d_phi_lag=d_phi[_n-1] if year>1970
gen d_gsp_worker= ln(gsp_worker)-ln(gsp_worker[_n-1]) if year>1960

gen lnempl=ln(empl)

**** growth rates
sort statefip year
gen d_kap= ln(kap)-ln(kap[_n-1]) if year>1960
gen d_kap_worker = ln(kap_worker)-ln(kap_worker[_n-1]) if year>1960
gen d_k_y_ratio_corrected= (0.34/0.66)*(ln(k_y_ratio)-ln(k_y_ratio[_n-1])) if year>1960
gen lnk_y_ratio_lag=ln(k_y_ratio[_n-1])

gen lnkap=ln(kap)
gen d_gsp_worker_lag= d_gsp_worker[_n-1] if year>1970
gen d_k_y_ratio_lag=d_k_y_ratio_corrected[_n-1] if year>1970
gen d_kap_lag=d_kap[_n-1] if year >1970
gen d_k_y_ratio= ln(k_y_ratio)-ln(k_y_ratio[_n-1]) if year>1960


gen lngsp_worker=ln(gsp_worker)
gen lngsp_worker_lag=lngsp_worker[_n-1]
gen lnkap_worker=ln(kap_worker)


*** variables for the US workers
gen d_us_empl=(empl_us-empl_us[_n-1])/empl[_n-1] if year>1960
gen d_hours_perworker_us=(hours_perworker_us-hours_perworker_us[_n-1])/hours_perworker_us[_n-1] if year>1960
gen d_h_us=(h_us-h_us[_n-1])/h[_n-1] if year>1960

gen d_hourly_H=(hourly_H-hourly_H[_n-1])/hourly_H[_n-1] if year>1960
gen d_hourly_L=(hourly_L-hourly_L[_n-1])/hourly_H[_n-1] if year>1960


*** distance IV

gen bord_dist_70=0
replace bord_dist_70=ln(border_distance) if year==1970
gen bord_dist_80=0
replace bord_dist_80=ln(border_distance) if year==1980
gen bord_dist_90=0
replace bord_dist_90=ln(border_distance) if year==1990
gen bord_dist_00=0
replace bord_dist_00=ln(border_distance) if year==2000
gen bord_dist_06=0
replace bord_dist_06=ln(border_distance) if year==2006

gen ny_dist_70=0
replace ny_dist_70=ln(ny_dist) if year==1970
gen ny_dist_80=0
replace ny_dist_80=ln(ny_dist) if year==1980
gen ny_dist_90=0
replace ny_dist_90=ln(ny_dist) if year==1990
gen ny_dist_00=0
replace ny_dist_00=ln(ny_dist) if year==2000
gen ny_dist_06=0
replace ny_dist_06=ln(ny_dist) if year==2006

gen miami_dist_70=0
replace miami_dist_70=ln(miami_dist) if year==1970
gen miami_dist_80=0
replace miami_dist_80=ln(miami_dist) if year==1980
gen miami_dist_90=0
replace miami_dist_90=ln(miami_dist) if year==1990
gen miami_dist_00=0
replace miami_dist_00=ln(miami_dist) if year==2000
gen miami_dist_06=0
replace miami_dist_06=ln(miami_dist) if year==2006


gen la_dist_70=0
replace la_dist_70=ln(la_dist) if year==1970
gen la_dist_80=0
replace la_dist_80=ln(la_dist) if year==1980
gen la_dist_90=0
replace la_dist_90=ln(la_dist) if year==1990
gen la_dist_00=0
replace la_dist_00=ln(la_dist) if year==2000
gen la_dist_06=0
replace la_dist_06=ln(la_dist) if year==2006

sort year
by year: sum d_A d_beta d_phi d_h d_immi_empl


save "$wd/data/gsp_empl_replication", replace