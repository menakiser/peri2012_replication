/* Create for OLS table 1 creation from Peri (2012)
*/

clear
clear matrix
set mem 100m
set matsize 110

global wd "/Users/jimenakiser/liegroup Dropbox/Jimena Villanueva Kiser/peri2012_replication/"
global rd "/Users/jimenakiser/liegroup Dropbox/raw_backup/immigration_productivity/2025_10_10/data/"

program main
    use "$wd/data/gsp_empl_replication", clear 

    ************************************************
    *Store regressions
    ************************************************
    cap mat drop c1
    cap mat drop c2
    cap mat drop c3
    cap mat drop c4
    cap mat drop c5

    *** table 1, row 1, OLS effect of immigration on total employment (N hat)
    xi: reg d_empl d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_empl d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_empl d_immi_empl i.year i.statefip[aw=empl] if year>1960 & year<2006, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_empl d_empl_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_empl (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c5)

    ** Table 1 row 2, GSP per worker and immigrants (y hat)
    xi: reg d_gsp_worker d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c1
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_gsp_worker d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c2
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_gsp_worker d_immi_empl i.year  i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip) //c3
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_gsp_worker d_gsp_worker_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c4
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_gsp_worker (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c5
    store_result, indvar(d_immi_empl) mname(c5)


    ***Table 1, row 3, (components of y hat)
    xi: reg d_k_y_ratio_corrected d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c1
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_k_y_ratio_corrected d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c2
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_k_y_ratio_corrected d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip) //c3
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_k_y_ratio_corrected d_k_y_ratio_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c4
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_k_y_ratio_corrected (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c5
    store_result, indvar(d_immi_empl) mname(c5)

    ** Table 1 row 4, effect on A
    xi: reg d_A d_immi_empl i.year i.statefip  [aw=empl] if year>1960, robust cluster(statefip) //c1
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_A d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c2
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_A d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip) //c3
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_A d_A_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c4
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_A (d_immi_empl=d_immi_pop) i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c5
    store_result, indvar(d_immi_empl) mname(c5)


    *** table 1 row 5, effects on hours per worker (x hat)
    xi: reg d_hours_perworker d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_hours_perworker d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_hours_perworker d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_hours_perworker d_hours_perworker_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_hours_perworker (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c5)


    ** Table 1 row 6, effect on phi
    xi: reg d_phi d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c1
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_phi d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c2
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_phi d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip) //c3
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_phi d_phi_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c4
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_phi (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c5
    store_result, indvar(d_immi_empl) mname(c5)


    *** Table 1 row 7, effects on share of hours worked by high skilled
    xi: reg d_h d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_h d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_h d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_h d_h_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_h (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
    store_result, indvar(d_immi_empl) mname(c5)

    ** Table 1 row 8, effect on beta
    xi: reg d_beta d_immi_empl i.year i.statefip[aw=empl] if year>1960, robust cluster(statefip) //c1
    store_result, indvar(d_immi_empl) mname(c1)
    xi: reg d_beta d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c2
    store_result, indvar(d_immi_empl) mname(c2)
    xi: reg d_beta d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip) //c3
    store_result, indvar(d_immi_empl) mname(c3)
    xi: reg d_beta d_beta_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip) //c4
    store_result, indvar(d_immi_empl) mname(c4)
    xi: ivreg d_beta (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip) //c5
    store_result, indvar(d_immi_empl) mname(c5)

    ************************************************
    *Create Overleaf table
    ************************************************

    global depvarnames `" "\hat{N}" "\hat{y}" "Components of \hat{y}" "\hat{A}" "\hat{x}" "\hat{\phi}" "\hat{h}" "\hat{\beta}" "'

    cap file close sumstat
	file open sumstat using "$wd/output/t1_ols.tex", write replace
	file write sumstat "\begin{tabular}{lccccc}" _n
	file write sumstat "\toprule" _n
	file write sumstat "\toprule" _n
    file write sumstat "& (1) & (2) & (3) & (4) & (5) \\" _n
    file write sumstat " & &  & Including & 2SLS Estimates \\" _n
    file write sumstat " & &  & Lagged & Population \\" _n
	file write sumstat "Dependent & Basic & 1970-- & 1960-- & Dependent & Change as \\" _n
	file write sumstat "Variable & OLS & 2006 & 2000 & Variable & Instrument \\" _n
	file write sumstat "\midrule " _n

    forval i = 1/8 {
        di "Writing row `i'"
        local lab: word `i' of $depvarnames
        if "`lab' " =="\hat{\phi}" {
            file write sumstat "Components of \hat{\phi} & & & & & \\" _n  
        }
        file write sumstat "`lab' " 
        forval j = 1/5{
           di "Writing coefficients in column `j'"
            store_coeff_latex, mname(c`j') row(`i')
        }
        file write sumstat " \\" _n

        forval j = 1/5{
           di "Writing standard errors column `j'"
            store_se_latex, mname(c`j') row(`i')
        }
        file write sumstat " \\" _n

    }
    file write sumstat "Observations "
    forval i = 1/5 {
        local obs = string(c`i'[1,4], "%6.1fc")
        file write sumstat " & `obs' "
    }
    file write sumstat " \\" _n
     
    file write sumstat "\bottomrule" _n
	file write sumstat "\bottomrule" _n
	file write sumstat "\end{tabular}"
	file close sumstat

end 

capture program drop store_result
program store_result
    syntax, indvar(str) mname(str)
    local b_   = _b[`indvar']
    local se_  = _se[`indvar']
    local p_   = 2 * ttail(e(df_r), abs(_b[`indvar'] / _se[`indvar']))
    local N_ = e(N)
    mat `mname' = nullmat(`mname') \ (`b_', `se_', `p_', `N_' )
end 


capture program drop store_coeff_latex
program define store_coeff_latex
    syntax , mname(str)  row(int) 
    * Extract values from matrix
    local b_abs    = string(`mname'[`row',1], "%6.2fc")
    local p_abs    = `mname'[`row',3]
    
    * Stars for significance
    local stars_abs = cond(`p_abs' < 0.01, "***", cond(`p_abs' < 0.05, "**", cond(`p_abs' < 0.1, "*", "")))

    * Store LaTeX rows
    file write sumstat " & `b_abs'`stars_abs' " 
end

capture program drop store_se_latex
program define store_se_latex
    syntax , mname(str)  row(int) 
    * Extract values from matrix
    local se_abs   = string(`mname'[`row',2], "%6.2fc")
        
    * Store LaTeX rows
    file write sumstat " & (`se_abs')  " 
end


