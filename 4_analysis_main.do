*************************************************************************************************
* ARE OLDER PARENTS AND ADULT CHILDREN LIVING FARTHER APART?
* Decomposing trends in intergenerational distance and co-residence in FInland (1998-2017)
* Social Forces. https://doi.org/10.1093/sf/soag043*
*
* Sanny D. Afable
* Max Planck Institute for Demographic Research &
* University of St Andrews
*
* File purpose:		Codes for data analysis
*
* Files required   	parchdyad15
*         
* Note: 			- Paths point to Statistics Finland's secure desktop environment (FIONA)
*					- shnro refers to old IDs still used in some files; hid_e refers to new IDs
*					- vuosi = year

************************************************************************************************

	cd "W:\Afable\3 - Proximity paper"
	use "W:\Afable\1 - Formatted Data\parchdyad15.dta", clear
	ssc install estout, replace

	log using analysis_prox, replace
	
*===============================================================================
* 0. Contents
*===============================================================================

	*	1.		Delimit sample
	*	2.		Define additional variables
	*	3.		Distance Trends
	*	4.		Characteristics of parents and children
	*	5.		OLS and linear probability models
	*	6.		Oaxaca-Blinder decomposition

*===============================================================================
* 1. Delimit the sample
*===============================================================================
	
	keep if par_age >= 60 & par_age < 70
	drop if vuosi < 2003 & vuosi > 2023
	
*===============================================================================
* 2. Variables specific for analysis
*===============================================================================
			
	// Outcome: distances to nearest son (m) and daughter (f), including co-resident children
	
		gen dur_cnm = .
		gen dur_cnf = .
		forvalues i = 1/16 {
			replace dur_cnm = odur`i' if chsex`i' == 1 & odur`i' <= dur_cnm
			replace dur_cnf = odur`i' if chsex`i' == 2 & odur`i' <= dur_cnf			
		}
		replace dur_cnm = dur_cnm/60
		replace dur_cnf = dur_cnf/60
		lab var dur_cnm "OSM dist (hr) to nearest son (inc. cores)"
		lab var dur_cnf "OSM dist (hr) to nearest dau (inc. cores)"		
		summ dur_cnm dur_cnf			

	// Outcome: distances to nearest, non-coresident son (m) and daughter (f)

		gen dur_nm = .
		gen dur_nf = .
		forvalues i = 1/16 {
			replace dur_nm = odur`i' if chsex`i' == 1 & ch_coreside`i' != 1 & odur`i' <= dur_nm
			replace dur_nf = odur`i' if chsex`i' == 2 & ch_coreside`i' != 1 & odur`i' <= dur_nf			
		}
		replace dur_nm = dur_nm/60
		replace dur_nf = dur_nf/60
		lab var dur_nm "OSM dist (hr) to nearest son (exc. cores)"
		lab var dur_nf "OSM dist (hr) to nearest dau (exc. cores)"		
		summ dur_nm dur_nf	
		
	// Outcome: co-residence with a son and daughter
	
		gen wson = 0		
		gen wdau = 0		
		forvalues i = 1/16 {
			replace wson = 1 if chsex`i' == 1 & wson == 0 
			replace wdau = 1 if chsex`i' == 2 & wdau == 0 
		}
		
		gen chcor_m = 0 if wson == 1
		gen chcor_f = 0	if wdau == 1
		lab var chcor_m "Coresiding with a son"
		lab var chcor_f "Coresiding with a daughter"
		forvalues i = 1/16 {
			replace chcor_m = ch_coreside`i' if chsex`i' == 1 & chcor_m == 0
			replace chcor_f = ch_coreside`i' if chsex`i' == 2 & chcor_f == 0
		}
		
	// Set up comparison years
	
		gen 	period = 1 		if vuosi >= 2003 & vuosi <= 2007
		replace period = 2 		if vuosi >= 2019 & vuosi <= 2023
	
		gen decomp_yr = period
		recode decomp_yr (1=2) (2=1)

*===============================================================================
* 3. Distance trends
*===============================================================================
	
	// Trends in median distance to child

		foreach dist in dur_cnm dur_cnf dur_nm dur_nf {

			// Unadjusted
			qui qreg `dist' i.vuosi if par_sex == 1
			margins vuosi
			qui qreg `dist' i.vuosi if par_sex == 2
			margins vuosi

			// Age-adjusted
			qui qreg `dist' i.vuosi i.par_agegrp if par_sex == 1
			margins vuosi
			qui qreg `dist' i.vuosi i.par_agegrp if par_sex == 2
			margins vuosi

		}

		// Coresidence trends
		foreach cor in chcor_m chcor_f {

			// Unadjusted
			tab vuosi `cor' if par_sex == 1, row nofreq
			tab vuosi `cor' if par_sex == 2, row nofreq

			// Age-adjusted
			qui logit `cor' i.par_agegrp i.vuosi if par_sex == 1
			margins vuosi
			qui logit `cor' i.par_agegrp i.vuosi if par_sex == 2
			margins vuosi

		}

		// Ns
		
		tab vuosi par_sex if dur_cnm != .
		tab vuosi par_sex if dur_cnf != .
		tab vuosi par_sex if dur_nm != .
		tab vuosi par_sex if dur_nf != .	
		tab vuosi par_sex if chcor_m != .
		tab vuosi par_sex if chcor_f != .				

*===============================================================================
* 4. Characteristics of parents and children (Table 1)
*===============================================================================
	
	// Fathers
		
		tab 	par_agegrp 			period 	if par_sex == 1, col nofreq
		tab 	par_coll 			period 	if par_sex == 1, col nofreq
		tab 	par_mstat 			period 	if par_sex == 1, col nofreq
		tab 	par_rent 			period 	if par_sex == 1, col nofreq
		tab 	par_rural 			period 	if par_sex == 1, col nofreq
		tab		par_reg_nuts2		period 	if par_sex == 1, col nofreq
		tab		par_emp				period 	if par_sex == 1, col nofreq
		tab		bin_hosp_inpt		period 	if par_sex == 1, col nofreq
				
		mean par_ch_no if par_sex == 1, over(period)
		estat sd
		
		mean medchage if par_sex == 1, over(period)
		estat sd
		
		mean par_gc if par_sex == 1, over(period)
		estat sd
		
		tab ch_coll period if par_sex == 1, col
		tab chdiv period if par_sex == 1, col
		tab chunemp period if par_sex == 1, col
				
	// Mothers
	
		tab 	par_agegrp 			period 	if par_sex == 2, col nofreq
		tab 	par_coll 			period 	if par_sex == 2, col nofreq		
		tab 	par_mstat 			period 	if par_sex == 2, col nofreq
		tab 	par_rent 			period 	if par_sex == 2, col nofreq
		tab 	par_rural 			period 	if par_sex == 2, col nofreq
		tab		par_reg_nuts2		period 	if par_sex == 2, col nofreq
		tab		par_emp				period 	if par_sex == 2, col nofreq
		tab		bin_hosp_inpt		period 	if par_sex == 2, col nofreq		
		
		mean par_ch_no if par_sex == 2, over(period)
		estat sd
		
		mean medchage if par_sex == 2, over(period)
		estat sd		
		
		mean par_gc if par_sex == 2, over(period)
		estat sd		
		
		tab ch_coll period if par_sex == 2, col
		tab chdiv period if par_sex == 2, col
		tab chunemp period if par_sex == 2, col
			
			
*===============================================================================
* 5. OLS models and linear probability models
*===============================================================================
		
		global parcontrol1 par_age i.par_coll ib2.par_mstat i.par_rent i.par_rural ib2.par_reg_nuts2 i.par_emp
		global chcontrol1 par_ch_no medchage i.ch_coll i.chdiv i.chunemp par_gc
								
	// Table 2. OLS regression of residential proximity to non-coresident children
	
		eststo reg_prox_p1_1: reg dur_nm $parcontrol1 $chcontrol1 if par_sex == 1 & period == 1
		eststo reg_prox_p1_2: reg dur_nf $parcontrol1 $chcontrol1 if par_sex == 1 & period == 1
		eststo reg_prox_p1_3: reg dur_nm $parcontrol1 $chcontrol1 if par_sex == 2 & period == 1
		eststo reg_prox_p1_4: reg dur_nf $parcontrol1 $chcontrol1 if par_sex == 2 & period == 1	
		
		esttab reg_prox_p1_1 reg_prox_p1_2 reg_prox_p1_3 reg_prox_p1_4 using reg_prox.xls, ///
		nogaps label b(1) se(1) star(+ .10 * .05 ** .01 *** .001) delim(;) nolabel replace
						
	// Table 3. Linear probability model of co-residence with children

		eststo reg_cor_p1_1: reg chcor_m $parcontrol1 $chcontrol1 if par_sex == 1 & decomp_yr == 1
		eststo reg_cor_p1_2: reg chcor_f $parcontrol1 $chcontrol1 if par_sex == 1 & decomp_yr == 1
		eststo reg_cor_p1_3: reg chcor_m $parcontrol1 $chcontrol1 if par_sex == 2 & decomp_yr == 1
		eststo reg_cor_p1_4: reg chcor_f $parcontrol1 $chcontrol1 if par_sex == 2 & decomp_yr == 1	
		
		esttab reg_cor_p1_1 reg_cor_p1_2 reg_cor_p1_3 reg_cor_p1_4 using reg_cor.xls, ///
		nogaps label b(3) se(3) star(+ .10 * .05 ** .01 *** .001) delim(;) nolabel replace
		
		
*===============================================================================
* 6. Oaxaca-Blinder decomposition
*===============================================================================		
		
	// 	Normalize categorical variables

		tab par_reg_nuts2, gen(preg_)
		tab par_emp, gen(pemp_)
		tab bin_hosp_inpt, gen(phosp_)
		tab chdiv, gen(chdiv_)
		tab chunemp, gen(chunemp_)
		gen par_gchild = (par_gc >= 1)
		tab par_gchild, gen(par_gchild_)
	
		global parcontrol2 	stdage ///
							normalize(peduc_1-peduc_2) ///
							normalize(prent_1-prent_2) ///
							normalize(prural_1-prural_2) ///
							normalize(pmstat_1-pmstat_4) ///
							normalize(preg_1-preg_5) ///
							normalize(pemp_1-pemp_2)
							
		global chcontrol2 	par_ch_no stdchage ///
							normalize(cheduc_1-cheduc_2) ///
							normalize(chdiv_1-chdiv_2) ///
							normalize(chunemp_1-chunemp_2) ///
							par_gc
		
	// Decomposition of trend in residential proximity to non-coresident children

		eststo decomp_prox_1: oaxaca dur_nm $parcontrol $chcontrol if par_sex == 1, by(decomp_yr)
		eststo decomp_prox_2: oaxaca dur_nf $parcontrol $chcontrol if par_sex == 1, by(decomp_yr)
		eststo decomp_prox_3: oaxaca dur_nm $parcontrol $chcontrol if par_sex == 2, by(decomp_yr)
		eststo decomp_prox_4: oaxaca dur_nf $parcontrol $chcontrol if par_sex == 2, by(decomp_yr)
		
		esttab decomp_prox_1 decomp_prox_2 decomp_prox_3 decomp_prox_4 using decomp_prox_wide.xls, ///
		wide compress plain b ci nostar delim(;) replace 
		
		esttab decomp_prox_1 decomp_prox_2 decomp_prox_3 decomp_prox_4 using decomp_prox_long.xls, ///
		nogaps label b(3) se(3) star(+ .10 * .05 ** .01 *** .001) delim(;) nolabel replace
	
	// Decomposition of trend in coresidence
	
		eststo decomp_cor_1: oaxaca chcor_m $parcontrol $chcontrol if par_sex == 1, by(decomp_yr)
		eststo decomp_cor_2: oaxaca chcor_f $parcontrol $chcontrol if par_sex == 1, by(decomp_yr) 
		eststo decomp_cor_3: oaxaca chcor_m $parcontrol $chcontrol if par_sex == 2, by(decomp_yr) 
		eststo decomp_cor_4: oaxaca chcor_f $parcontrol $chcontrol if par_sex == 2, by(decomp_yr)
		
		esttab decomp_cor_1 decomp_cor_2 decomp_cor_3 decomp_cor_4 using decomp_cor_wide.xls, ///
		wide compress plain b ci nostar delim(;) replace 
		
		esttab decomp_cor_1 decomp_cor_2 decomp_cor_3 decomp_cor_4 using decomp_cor_long.xls, ///
		nogaps label b(3) se(3) star(+ .10 * .05 ** .01 *** .001) delim(;) nolabel replace


		
*===============================================================================
	log close
*===============================================================================	
	