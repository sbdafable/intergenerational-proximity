*************************************************************************************************
* PROXIMITY AND HEALTH PROJECT
*
* Sanny D. Afable
* Max Planck Institute for Demographic Research &
* University of St Andrews
*
* File purpose:		Codes for variable coding
*	
* Files required   	- mgen* files
*           
* Note: 			- Paths point to Statistics Finland's secure desktop environment (FIONA)
*					- shnro refers to old IDs still used in some files; hid_e refers to new IDs
*					- vuosi = year

************************************************************************************************

	cd "W:\Afable\1 - Formatted Data"
	log using log_data_hosp, replace
	
*===============================================================================
* Variable recoding
*===============================================================================

	// VALUE LABELS
	lab define cohort     	1889 "Pre-1930" 1930 "1930-1939" 1940 "1940-1949" 1950 "1950+"
	lab define sex        	1 "Male" 2 "Female"
	lab define urban      	1 "Urban" 2 "Rural"
	lab define mstat      	1 "Unmarried" 2 "Married/registered/separated" 3 "Divorced" 4 "Widowed"
	lab define educ1      	1 "Basic/none" 2 "Secondary" 3 "Tertiary"
	lab define hhten      	1 "Owns house/share" 2 "Renting, others"
	lab define par_livarr 	1 "Community-dwelling, no child" 2 "Community-dwelling, with a child" ///
							3 "Institutionalized/collective"
	lab define finreg     	1 "Lapland" 2 "Oulu" 3 "Eastern Finland" ///
							4 "Western Finland" 5 "Southern Finland"  ///
							6 "Aland" 7 "Helsinki metropolitan cities"
	lab define nuts2      	1 "West Finland" 2 "Helsinki-Uusimaa" 3 "South Finland" ///
							4 "North & East Finland" 5 "Aland"

	foreach x in mgen9805 mgen0615 mgen1620 mgen2123 {

		use `x', clear

		order hid_e vuosi par_ika hid_e_ch1-gdist19, alphabetic

		// PARENTS' BACKGROUND CHARACTERISTICS

			gen par_age = par_ika
			lab var par_age "Parent's age"

			egen par_agegrp = cut(par_ika), at(50,55,60,65,70,75,80,85,120)
			lab var par_agegrp "Parent's age group"

			gen par_birth = par_syntyv

			egen par_cohort = cut(par_syntyv), at(1889,1930,1940,1950,1970)
			lab var par_cohort "Parent's birth cohort"
			lab val par_cohort cohort

			egen par_cohort2 = cut(par_syntyv), at(1889,1930,1940,2020)
			lab var par_cohort2 "Parent's birth cohort"
			lab val par_cohort2 cohort

			encode par_sukup, gen(par_sex)
			lab var par_sex "Parent's sex"
			lab val par_sex sex

			gen ch_no = 0
			forvalues i = 1/16 {
				replace ch_no = ch_no + 1 if hid_e_ch`i' != ""
			}
			lab var par_ch_no "Number of children"

			gen par_gc = 0
			forvalues i = 1/16 {
				replace par_gc = par_gc + 1 if ch_no`i' >= 1 & ch_no`i' != .
			}
			lab var par_gc "Number of grandchildren"

			gen chcount_f = 0
			forvalues i = 1/16 {
				replace chcount_f = chcount_f + 1 if sukup`i' == "2"
			}
			lab var chcount_f "Number of female children"

			gen chcount_m = 0
			forvalues i = 1/16 {
				replace chcount_m = chcount_m + 1 if sukup`i' == "1"
			}
			lab var chcount_m "Number of male children"

			gen par_urban = .
			replace par_urban = 1 if par_maka == "K1" | par_maka == "K2" | par_maka == "K3"
			replace par_urban = 2 if par_maka == "M4" | par_maka == "M5" | par_maka == "M6" | par_maka == "M7"
			lab var par_urban "Urban/rural"
			lab val par_urban urban

			encode par_sivs, gen(par_mstat)
			lab var par_mstat "Marital status"
			lab val par_mstat mstat

			gen par_educ = 1 if par_ututku_aste == ""
			replace par_educ = 2 if par_ututku_aste == "3" | par_ututku_aste == "4"
			replace par_educ = 3 if par_ututku_aste == "5" | par_ututku_aste == "6" | par_ututku_aste == "7" | par_ututku_aste == "8"
			lab var par_educ "Education"
			lab val par_educ educ1

			gen par_hhten = .
			replace par_hhten = 1 if par_hape == "1" | par_hape == "2"
			replace par_hhten = 2 if par_hape >= "3" & par_hape != ""
			lab var par_hhten "Tenure status of dwelling"
			lab val par_hhten hhten

			gen par_emp   = (par_amas1 != "")
			gen par_coll  = (par_educ == 3)
			gen par_rent  = (par_hhten == 2)
			gen par_rural = (par_urban == 2)

			tab par_agegrp, gen(pagegrp_)
			tab par_coll,   gen(peduc_)
			tab par_rent,   gen(prent_)
			tab par_rural,  gen(prural_)
			tab par_mstat,  gen(pmstat_)

			drop par_ika par_syntyv par_maka par_hape par_ututku_aste par_sivs

			** region of residence
			destring orig, gen(par_pc)

			gen     par_reg = 1 if par_mkunta == "19"
			replace par_reg = 2 if par_mkunta == "17" | par_mkunta == "18"
			replace par_reg = 3 if par_mkunta == "10" | par_mkunta == "11" | par_mkunta == "12"
			replace par_reg = 4 if par_mkunta == "13" | par_mkunta == "14" | par_mkunta == "15" | ///
							par_mkunta == "02" | par_mkunta == "04" | par_mkunta == "06" | par_mkunta == "16"
			replace par_reg = 5 if par_mkunta == "05" | par_mkunta == "07" | par_mkunta == "08" | ///
							par_mkunta == "09" | par_mkunta == "01"
			replace par_reg = 6 if par_mkunta == "21"
			replace par_reg = 7 if par_pc >= 100  & par_pc <= 1055  | ///
							par_pc >= 2002 & par_pc <= 2981  | ///
							par_pc >= 1490 & par_pc <= 1700  | ///
							par_pc == 2700 | par_pc == 2760
			// Helsinki capital region: Helsinki, Espoo, Vantaa, Kauniainen
			lab val par_reg finreg

			gen     par_reg_nuts2 = 1 if par_mkunta == "04" | par_mkunta == "06" | ///
										 par_mkunta == "13" | par_mkunta == "14" | par_mkunta == "15"
			replace par_reg_nuts2 = 2 if par_mkunta == "01"
			replace par_reg_nuts2 = 3 if par_mkunta == "02" | par_mkunta == "05" | par_mkunta == "07" | ///
										 par_mkunta == "08" | par_mkunta == "09" | par_mkunta == "10"
			replace par_reg_nuts2 = 4 if par_mkunta == "10" | par_mkunta == "11" | par_mkunta == "12" | ///
										 par_mkunta == "18" | par_mkunta == "16" | par_mkunta == "17" | par_mkunta == "19"
			replace par_reg_nuts2 = 5 if par_mkunta == "21"
			lab val par_reg_nuts2 nuts2

			
		// CHILDREN'S CHARACTERISTICS

			forvalues i = 1/16 {
				encode sukup`i', gen(chsex`i')
			}

			forvalues i = 1/16 {
				gen ch_educ`i' = 1 if ututku_aste`i' == ""
				replace ch_educ`i' = 2 if ututku_aste`i' == "3" | ututku_aste`i' == "4" | ututku_aste`i' == "5"
				replace ch_educ`i' = 3 if ututku_aste`i' == "6" | ututku_aste`i' == "7" | ututku_aste`i' == "8"
			}

			forvalues i = 1/16 {
				encode sivs`i', gen(chmstat`i')
				lab val chmstat`i' mstat
			}

			forvalues i = 1/16 {
				gen chemp`i' = 0 if hid_e_ch`i' != ""
				replace chemp`i' = 1 if amas1`i' == "1" | amas1`i' == "2"
			}

			drop sukup1-sukup9 ututku_aste1-ututku_aste9 sivs1-sivs9 amas11-amas16

			egen ch_he   = rowmax(ch_educ1-ch_educ16)
			gen  ch_coll = (ch_he == 3)
			tab  ch_coll, gen(cheduc_)

			egen medchage = rowmedian(ika1-ika9)

		// OUTCOMES: Co-residence

			rename par_ak_koodi hhcode_par			
			gen ch_coreside = 0
			forvalues i = 1/16 {
				gen ch_coreside`i' = (hhcode_par == hhcode_ch`i')
				replace ch_coreside = 1 if hhcode_par == hhcode_ch`i'
			}

		// DROP AND SAVE

			drop hid_e_ch1-hid_e_ch16
			keep hid_e vuosi orig par_age par_agegrp par_birth par_cohort     			///
				 par_cohort2 par_sex par_ch_no par_gc chcount_f chcount_m par_urban  	///
				 par_mstat par_educ par_hhten par_emp par_coll par_rent par_rural     	///
				 par_mkunta par_reg par_reg_nuts2 ch_he ch_coll medchage       	///
				 dest1-dest16 ch_coreside hhcode_par hhcode_ch1-hhcode_ch16         	///
				 chsex1-chsex16 ch_educ1-ch_educ16 odur1-odur16 odist1-odist16       	///
				 gdist1-gdist16 chemp1-chemp16 chmstat1-chmstat16 par_kuolv hosp_inpt

		compress
		
		tempfile `x'_1
		save ``x'_1', replace

	}

	
*===============================================================================
* Merge tempfiles; generate lagged variables
*===============================================================================	
	
	use `mgen9805_1', clear
	append using `mgen0615_1' `mgen1620_1' `mgen2123_1'

	egen caseid = group(hid_e)	
	xtset caseid vuosi
	
	// Divorce since t-1
	gen chdiv = 0
	forvalues i = 1/16 {
		bysort caseid (vuosi): replace chdiv = 1 if chmstat`i'[_n] == 3 & ///
			chmstat`i'[_n-1] != . & chmstat`i'[_n-1] != 4
	}

	// Unemployment since t-1
	gen chunemp = 0
	forvalues i = 1/16 {
		bysort caseid (vuosi): replace chunemp = 1 if chemp`i'[_n] == 0 & chemp`i'[_n-1] == 1
	}

	drop chemp1-chemp16 chmstat1-chmstat16

	compress
	save parchdyad15, replace
	
*===============================================================================
	log close
*===============================================================================	
	
