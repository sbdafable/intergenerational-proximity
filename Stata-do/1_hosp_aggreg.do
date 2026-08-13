*************************************************************************************************
* PROXIMITY AND HEALTH PROJECT
*
* Sanny D. Afable
* Max Planck Institute for Demographic Research &
* University of St Andrews
*
* File purpose:		Codes for aggregating hospital records into annual data (Care Register for Healthcare 1987-2020)
*	
* Files required   	- hosp 1987-1993, uses ICD9: 		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_1987_1993_s.dta",
*					- hosp 1994-1995, uses ICD9:		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_9495_s.dta"
*					- hosp 1996-2000, uses ICD10:		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_9600_s.dta"
*					- hosp 2001-2005, uses ICD10:		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_0105_s.dta"
*					- hosp 2006-2010, uses ICD10:		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_0610_s.dta"
*					- hosp 2011-2015, uses ICD10:		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_1115_s.dta"
*					- hosp 2016-2020, uses ICD10:		"D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_1620_s.dta"
*           
* Note: 			- Paths point to Statistics Finland's secure desktop environment (FIONA)
*					- shnro refers to old IDs still used in some files; hid_e refers to new IDs
*					- vuosi = year

************************************************************************************************

	log using log_data_hosp, replace

*-------------------------------------------------------------------------------
* 1987-1993: no record for in-patient stays
*-------------------------------------------------------------------------------
	
	use "D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_1987_1993_s.dta", clear
	
	gen double date_adm = dofc(clock(tupva, "DMYhm")) 	// date of admission
	gen double date_dis = dofc(clock(lpvm, "DMYhm"))	// date of discharge
	format date_adm date_dis %td
	gen year_adm  = yofd(date_adm)
	gen year_dis  = yofd(date_dis)
	gen vuosi     = year_dis
	gen double hosp_length = (date_dis - date_adm + 1)
	gen hosp_inpt          = yofd(date_dis)
	collapse (count) hosp_inpt (sum) hosp_length, by(shnro vuosi)
	tempfile hosp_all_8793
	save `hosp_all_8793'
	
*-------------------------------------------------------------------------------
* 1994-2020: in-patient stays and all hospital visits
*-------------------------------------------------------------------------------	

	* pala filter applied; 1620 uses string pala; some periods correct reversed dates
	* pala = 1: inpatient stay
	foreach f in 9495 9600 0105 0610 1115 1620 {

		use "D:\g54\external\u1259_al5_thl_aineisto_hilmot\u1259_hilmo_paa_`f'_s.dta", clear

		gen double date_adm = dofc(clock(tupva, "DMYhm"))
		gen double date_dis = dofc(clock(lpvm, "DMYhm"))
		format date_adm date_dis %td
		gen year_adm = yofd(date_adm)
		gen year_dis = yofd(date_dis)
		gen vuosi    = year_dis

		if "`f'" == "1620" {
			gen double hosp_length = (date_dis - date_adm + 1) if year_adm == year_dis & pala == "1"
			gen hosp_inpt          = 1                         if pala == "1"
		}
		
		else {
			gen double hosp_length = (date_dis - date_adm + 1) if year_adm == year_dis & pala == 1
			gen hosp_inpt          = 1                         if pala == 1
		}

		* Correct reversed admission/discharge dates (present in 9600, 1115, 1620)
		replace hosp_length = (date_adm - date_dis + 1) if date_adm > date_dis

		keep shnro vuosi hosp_length hosp_inpt
		collapse (sum) hosp_inpt (sum) hosp_length, by(shnro vuosi)
		tempfile hosp_all_`f'
		save `hosp_all_`f''
		
	}

	* Append all periods and save
	use `hosp_all_8793', clear
	foreach f in 9495 9600 0105 0610 1115 1620 {
		append using `hosp_all_`f''
	}

	* Selected hospital visits may be recorded in other years, so further collapse is needed
	collapse (sum) hosp_length (sum) hosp_inpt, by(shnro vuosi)
	compress
	
	// New pseudonym
	merge m:1 shnro using "D:\keys\linkki_shnro_hide", nogen
	drop shnro
	
	// Variable names
	lab var hosp_inpt "No. of in-patient hospitalisations"
	lab var hosp_length "Total hospital stays (in days)"
	
save "W:\Afable\1 - Formatted Data\hosp8720.dta", replace

*===============================================================================
	log close
*===============================================================================
