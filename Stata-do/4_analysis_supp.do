*************************************************************************************************
* ARE OLDER PARENTS AND ADULT CHILDREN LIVING FARTHER APART?
* Decomposing trends in intergenerational distance and co-residence in FInland (1998-2017)
* Social Forces. https://doi.org/10.1093/sf/soag043*
*
* Sanny D. Afable
* Max Planck Institute for Demographic Research &
* University of St Andrews
*
* File purpose:		Codes for Supplementary Analyses
*
* Files required   	- parchdyad15
*           
* Note: 			- Paths point to Statistics Finland's secure desktop environment (FIONA)
*					- shnro refers to old IDs still used in some files; hid_e refers to new IDs
*					- vuosi = year

************************************************************************************************

	cd "W:\Afable\3 - Proximity paper"
	use "W:\Afable\1 - Formatted Data\parchdyad15.dta", clear
	
	log using analysis_supp, replace
	
*===============================================================================
* 0. Contents
*===============================================================================

	*	1.		Delimit sample
	*	2.		Define additional variables
	*	3.		Supplementary files

*===============================================================================
* 1. Delimit the sample
*===============================================================================
	
	keep if par_age >= 60 & par_age < 70
	drop if vuosi < 2003 & vuosi > 2023
	
*===============================================================================
* 2. Variables specific for supplementary analysis, including alternative distances
*===============================================================================
	
	{
	
	/// Minimum distance to any child

		egen mingdist = rowmin(gdist1-gdist9)
		replace mingdist = mingdist/1000
		lab var mingdist "Minimum geodesic distance (km)"
		
		egen minodist = rowmin(odist1-odist9)
		replace minodist = minodist/1000
		lab var minodist "Minimum OSM distance (km)"		
		
		egen minodur = rowmin(odur1-odur9)
		replace minodur = minodur/60
		lab var minodur "Minimum OSM distance (mins)"				
		
	// Outcome: distances to nearest son (m) and daughter (f), including co-resident children
	
		gen gdist_cnm = .
		gen gdist_cnf = .
		forvalues i = 1/16 {
			replace gdist_cnm = gdist`i' if chsex`i' == 1 & gdist`i' <= gdist_cnm
			replace gdist_cnf = gdist`i' if chsex`i' == 2 & gdist`i' <= gdist_cnf			
		}
		replace gdist_cnm = gdist_cnm/1000
		replace gdist_cnf = gdist_cnf/1000	
		lab var gdist_cnm "Geodesic dist (km) to nearest son (inc. cores)"
		lab var gdist_cnf "Geodesic dist (km) to nearest dau (inc. cores)"		
		summ gdist_cnm gdist_cnf
	
		gen odist_cnm = .
		gen odist_cnf = .
		forvalues i = 1/16 {
			replace odist_cnm = odist`i' if chsex`i' == 1 & odist`i' <= odist_cnm
			replace odist_cnf = odist`i' if chsex`i' == 2 & odist`i' <= odist_cnf			
		}
		replace odist_cnm = odist_cnm/1000
		replace odist_cnf = odist_cnf/1000	
		lab var odist_cnm "OSM dist (km) to nearest son (inc. cores)"
		lab var odist_cnf "OSM dist (km) to nearest dau (inc. cores)"		
		summ odist_cnm odist_cnf	
			
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

		gen gdist_nm = .
		gen gdist_nf = .
		forvalues i = 1/16 {
			replace gdist_nm = gdist`i' if chsex`i' == 1 & ch_coreside`i' != 1 & gdist`i' <= gdist_nm
			replace gdist_nf = gdist`i' if chsex`i' == 2 & ch_coreside`i' != 1 & gdist`i' <= gdist_nf			
		}
		lab var gdist_nm "Geodesic dist (km) to nearest son (exc. cores)"
		lab var gdist_nf "Geodesic dist (km) to nearest dau (exc. cores)"		
		summ gdist_nm gdist_nf
		
		gen odist_nm = .
		gen odist_nf = .
		forvalues i = 1/16 {
			replace odist_nm = odist`i' if chsex`i' == 1 & ch_coreside`i' != 1 & odist`i' <= odist_nm
			replace odist_nf = odist`i' if chsex`i' == 2 & ch_coreside`i' != 1 & odist`i' <= odist_nf			
		}
		replace odist_nm = odist_nm/1000
		replace odist_nf = odist_nf/1000
		lab var odist_nm "OSM dist (km) to nearest son (exc. cores)"
		lab var odist_nf "OSM dist (km) to nearest dau (exc. cores)"		
		summ odist_nm dist_cnf			
	
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
		
	// Percent distribution
	
		lab define mindurgrp -1 "Co-residing" 0 "[0,5)" 5 "[5,10)" 10 "[10,15)" 15 "[15,30)" 30 "[30,60)" ///
			60 "[60,120)" 120 "[120,240]" 240 "[240,480)" 480 "480+"
			
		egen chm_grp = cut(dur_nm), at(0,5,10,15,30,60,120,240,480,2000)
		egen chf_grp = cut(dur_nf), at(0,5,10,15,30,60,120,240,480,2000)
		lab val chm_grp chf_grp mindurgrp
		
		tab vuosi chm_grp if par_sex == 1, row  nofreq
		tab vuosi chf_grp if par_sex == 1, row  nofreq
		tab vuosi chm_grp if par_sex == 2, row  nofreq
		tab vuosi chf_grp if par_sex == 2, row  nofreq	
		
	// Hospitalisation
	
		gen bin_hosp_inpt = (hosp_inpt > 0) & hosp_inpt != .
		replace bin_hosp_inpt = 0 if hosp_inpt == .
		
	}

*===============================================================================
* 3. Supplementary analyses
*===============================================================================

** Table S1.OLS (2019-2023)

	{
	eststo reg_prox_p2_1: reg dur_nm $parcontrol1 $chcontrol1 if par_sex == 1 & period == 2
	eststo reg_prox_p2_2: reg dur_nf $parcontrol1 $chcontrol1 if par_sex == 1 & period == 2
	eststo reg_prox_p2_3: reg dur_nm $parcontrol1 $chcontrol1 if par_sex == 2 & period == 2
	eststo reg_prox_p2_4: reg dur_nf $parcontrol1 $chcontrol1 if par_sex == 2 & period == 2

	esttab reg_prox_p2_1 reg_prox_p2_2 reg_prox_p2_3 reg_prox_p2_4 using reg_prox.xls, ///
	nogaps label b(1) se(1) star(+ .10 * .05 ** .01 *** .001) delim(;) nolabel replace
	}

** Table S2. Linear prob. model (2019-2023)

	{
	eststo reg_cor_p2_1: reg chcor_m $parcontrol1 $chcontrol1 if par_sex == 1 & period == 1
	eststo reg_cor_p2_2: reg chcor_f $parcontrol1 $chcontrol1 if par_sex == 1 & period == 1
	eststo reg_cor_p2_3: reg chcor_m $parcontrol1 $chcontrol1 if par_sex == 2 & period == 1
	eststo reg_cor_p2_4: reg chcor_f $parcontrol1 $chcontrol1 if par_sex == 2 & period == 1

	esttab reg_cor_p2_1 reg_cor_p2_2 reg_cor_p2_3 reg_cor_p2_4 using reg_cor.xls, ///
	nogaps label b(3) se(3) star(+ .10 * .05 ** .01 *** .001) delim(;) nolabel replace
	}

** Table S3. Characteristics of parents aged 65-69

	preserve
	keep if par_age >= 65
	
	{
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

	}

	restore

** Table S4. Distance by children's median age

	{
	egen medchagegrp = cut(medchage), at(18,25,30,35,40,45,50,100)

		foreach dist in dur_cnm dur_cnf dur_nm dur_nf {
			qui qreg `dist' i.medchagegrp i.vuosi if par_sex == 1
			qui qreg `dist' i.medchagegrp i.vuosi if par_sex == 2
		}
	}

** Figure S2. Contribution of hospitalisation

	{
	
	// Set up comparison years
	
		gen decomp_yr1 = 2 if vuosi >= 2003 & vuosi < 2008
		replace decomp_yr1 = 1 if vuosi >= 2016 & vuosi <= 2020
		
	// 	Controls
		
		global parcontrol 	stdage ///
							normalize(peduc_1-peduc_2) ///
							normalize(prent_1-prent_2) ///
							normalize(prural_1-prural_2) ///
							normalize(pmstat_1-pmstat_4) ///
							normalize(preg_1-preg_5) ///
							normalize(pemp_1-pemp_2) ///
							normalize(phosp_1-phosp_2)
							
		global chcontrol 	par_ch_no stdchage ///
							normalize(cheduc_1-cheduc_2) ///
							normalize(chdiv_1-chdiv_2) ///
							normalize(chunemp_1-chunemp_2) ///
							bin_hosp_inpt par_gc
		
	// Oaxaca decomposition of trend in residential proximity to non-coresident children

		eststo decomp_prox_1: oaxaca odist_nm $parcontrol $chcontrol if par_sex == 1, by(decomp_yr1)
		eststo decomp_prox_2: oaxaca odist_nf $parcontrol $chcontrol if par_sex == 1, by(decomp_yr1)
		eststo decomp_prox_3: oaxaca odist_nm $parcontrol $chcontrol if par_sex == 2, by(decomp_yr1)
		eststo decomp_prox_4: oaxaca odist_nf $parcontrol $chcontrol if par_sex == 2, by(decomp_yr1)
		
		esttab decomp_prox_1 decomp_prox_2 decomp_prox_3 decomp_prox_4 using s4_decomp_prox_wide.xls, ///
		wide compress plain b ci nostar delim(;) replace 
	
	// Oaxaca decomposition of trend in coresidence
	
		eststo decomp_cor_1: oaxaca chcor_m $parcontrol $chcontrol if par_sex == 1, by(decomp_yr1)
		eststo decomp_cor_2: oaxaca chcor_f $parcontrol $chcontrol if par_sex == 1, by(decomp_yr1) 
		eststo decomp_cor_3: oaxaca chcor_m $parcontrol $chcontrol if par_sex == 2, by(decomp_yr1) 
		eststo decomp_cor_4: oaxaca chcor_f $parcontrol $chcontrol if par_sex == 2, by(decomp_yr1)
		
		esttab decomp_cor_1 decomp_cor_2 decomp_cor_3 decomp_cor_4 using s4_decomp_cor_wide.xls, ///
		wide compress plain b ci nostar delim(;) replace 

	}
		
** Figure S3. Decomposition among parents aged 65-69

	preserve
	keep if par_age >= 65
	
	{
		global parcontrol 	stdage ///
							normalize(peduc_1-peduc_2) ///
							normalize(prent_1-prent_2) ///
							normalize(prural_1-prural_2) ///
							normalize(pmstat_1-pmstat_4) ///
							normalize(preg_1-preg_5) ///
							normalize(pemp_1-pemp_2)
							
		global chcontrol 	par_ch_no stdchage ///
							normalize(cheduc_1-cheduc_2) ///
							normalize(chdiv_1-chdiv_2) ///
							normalize(chunemp_1-chunemp_2) ///
							par_gc	
	
		// Oaxaca decomposition of trend in residential proximity to non-coresident children

		eststo decomp_prox_1: oaxaca dur_nm $parcontrol $chcontrol if par_sex == 1, by(decomp_yr)
		eststo decomp_prox_2: oaxaca dur_nf $parcontrol $chcontrol if par_sex == 1, by(decomp_yr)
		eststo decomp_prox_3: oaxaca dur_nm $parcontrol $chcontrol if par_sex == 2, by(decomp_yr)
		eststo decomp_prox_4: oaxaca dur_nf $parcontrol $chcontrol if par_sex == 2, by(decomp_yr)
		
		esttab decomp_prox_1 decomp_prox_2 decomp_prox_3 decomp_prox_4 using s5_decomp_prox_wide.xls, ///
		wide compress plain b ci nostar delim(;) replace 
	
	// Oaxaca decomposition of trend in coresidence
	
		eststo decomp_cor_1: oaxaca chcor_m $parcontrol $chcontrol if par_sex == 1, by(decomp_yr)
		eststo decomp_cor_2: oaxaca chcor_f $parcontrol $chcontrol if par_sex == 1, by(decomp_yr) 
		eststo decomp_cor_3: oaxaca chcor_m $parcontrol $chcontrol if par_sex == 2, by(decomp_yr) 
		eststo decomp_cor_4: oaxaca chcor_f $parcontrol $chcontrol if par_sex == 2, by(decomp_yr)
		
		esttab decomp_cor_1 decomp_cor_2 decomp_cor_3 decomp_cor_4 using s5_decomp_cor_wide.xls, ///
		wide compress plain b ci nostar delim(;) replace

	}
	
	restore
		
** Figure S4. OSM distance (in km)

	{

		foreach dist in odist_cnm odist_cnf odist_nm odist_nf {

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
	}

** Figure S5 (thesis). Geodesic distance (in km)

	{

		foreach dist in gdist_cnm gdist_cnf gdist_nm gdist_nf {

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

	}	
	

	
*===============================================================================
	log close
*===============================================================================	
	
		
