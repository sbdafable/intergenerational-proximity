*************************************************************************************************
* PROXIMITY AND HEALTH PROJECT
*
* Sanny D. Afable
* Max Planck Institute for Demographic Research &
* University of St Andrews
*
* File purpose:		Codes for sample derivation, variable construction, and merging of
* 					parent, child, distance, and hospitalization data sets
* 					(Statistics Finland register data, 1998–2023)
*	
* Files required   	- parent-child link table: 			"D:\g54\custom-made\d31_tiedostot_custom\biolog_vanh"
*					- new pseudonyms as of April 2026: 	"D:\keys\linkki_id_hide.dta"
*					- basic data:						"FOLK_PERUS_C\FOLK_PERUS_`y'_1"
*					- household data:					"FOLK_ASKUN_C\FOLK_ASKUN_`y'_1.dta"
*					- postcode data: 					"D:\ready-made\CONTINUOUS\INFRA_SIJAINTI_C\INFRA_SIJAINTI_`y'"
*					- sex:								"D:\ready-made\CONTINUOUS\FOLK_PERUS_C\FOLK_PERUS_SUKUP_1.dta"
*					- OSRM-based distance:				"W:\Afable\1 - Formatted Data\osrm_dur.dta"
*					- hospitalization:					"W:\Afable\1 - Formatted Data\hosp8720.dta"
*           
* Note: 			- Paths point to Statistics Finland's secure desktop environment (FIONA)
*					- shnro refers to old IDs still used in some files; hid_e refers to new IDs
*					- vuosi = year

************************************************************************************************

	cd    "W:\Afable\1 - Formatted Data"
	log using log_data_merge, replace

*-------------------------------------------------------------------------------
* 1. Identify parents and children; draw 15% sample of parents
*-------------------------------------------------------------------------------

	use "D:\g54\custom-made\d31_tiedostot_custom\biolog_vanh", clear	// parent–child link table
	
	drop if isa_aiti == "" // missing parent indicator
	duplicates drop id isa_aiti, force
	rename shnro shnro_ch
	rename shnro_vanh shnro
	
	* Attach new pseudonymised (hid_e) identifiers — parents
	merge m:1 shnro using "D:\keys\linkki_shnro_hide.dta"
	drop shnro

	* Attach new pseudonymised (hid_e) identifiers — parents
	rename shnro_ch shnro
	merge m:1 shnro using "D:\keys\linkki_shnro_hide.dta", nogen
	drop shnro
	rename hid_e hid_e_ch

	* Index children
	by hid_e, sort: gen ch = _n

	* Reshape, with parents as unit as analysis
	reshape wide hid_e_ch isa_aiti, i(hid_e) j(ch)

	* Draw 15% random sample
	set seed 3827
	sample 15

	compress
	save par15.dta, replace


*-------------------------------------------------------------------------------
* 2. Merge basic, household, and distance data sets (1998–2023)
*-------------------------------------------------------------------------------

	forvalues y = 1998(1)2023{

		// Merge parent's characteristics
		
		use "W:\ready-made\FOLK_PERUS_C\FOLK_PERUS_`y'_1.dta", clear
		keep vuosi hid_e syntyv kuolv svaltio_k syntyp2 ika mkunta kunta kuntaryhm kunta31_12 maka sivs ututku_aste ///
			suorv amas1 akoko_k hape peas lkm_k pekoko_k pety
		keep if ika >= 50 // limit to parents aged 50+
		keep if syntyv >= 1938 // limit to parents born 1938+ (see Einio et al., 2016)
		merge 1:1 hid_e using "W:\Afable\1 - Formatted Data\par15.dta", keep(match) nogen
		merge 1:1 hid_e using "W:\ready-made\FOLK_ASKUN_C\FOLK_ASKUN_`y'_1.dta", keep(match master) nogen keepusing(ak_koodi)
		merge 1:1 hid_e using "D:\ready-made\CONTINUOUS\INFRA_SIJAINTI_C\INFRA_SIJAINTI_`y'", keep(match master) nogen ///
			keepusing(euref_1000 posti_alue)
		merge 1:1 hid_e using "D:\ready-made\CONTINUOUS\FOLK_PERUS_C\FOLK_PERUS_SUKUP_1.dta", keep(match master) nogen
		foreach v of varlist ch_no syntyv-pety ak_koodi-sukup {
			rename `v' par_`v' 
		
		// Reshape from wide to long to enable merging of children's data
		
		reshape long hid_e_ch isa_aiti, i(hid_e vuosi) j(ch)
		drop if hid_e_ch == ""
		rename (hid_e hid_e_ch) (hid_e_par hid_e)
		
		// Merge children's characteristics

		merge m:1 hid_e vuosi using "W:\ready-made\FOLK_PERUS_C\FOLK_PERUS_`y'_1.dta", keepusing(syntyv kuolv ///
			svaltio_k syntyp2 ika mkunta kunta kuntaryhm kunta31_12 maka sivs ututku_aste suorv amas1 akoko_k ///
			hape peas lkm_k pekoko_k pety) keep(match master) nogen // Children can appear multiple times
		keep if ika >= 18
		merge m:1 hid_e using "W:\ready-made\FOLK_ASKUN_C\FOLK_ASKUN_`y'_1.dta", keep(match master) nogen keepusing(ak_koodi)
		merge m:1 hid_e using "D:\ready-made\CONTINUOUS\INFRA_SIJAINTI_C\INFRA_SIJAINTI_`y'", keep(match master) nogen ///
			keepusing(euref_1000 posti_alue)
		merge m:1 hid_e using "D:\ready-made\CONTINUOUS\FOLK_PERUS_C\FOLK_PERUS_SUKUP_1.dta", keep(match master) nogen 
		merge m:1 hid_e using "W:\Afable\1 - Formatted Data\parent.dta", keep(match master) keepusing(ch_no) nogen
		rename (hid_e hid_e_par) (hid_e_ch hid_e)
		
		// Merge orig-dest postcode data
		rename (par_posti_alue posti_alue) (orig dest)
		merge m:1 orig dest using "W:\Afable\1 - Formatted Data\osrm_dur.dta", ///
			keep(match master) keepusing(odist odur gdist) nogen
		
		* Reshape back into parents as the unit of analysis
		
		reshape wide isa_aiti hid_e_ch sukup syntyv kuolv svaltio_k syntyp2 ika mkunta kunta kuntaryhm kunta31_12 maka sivs ///
			ututku_aste suorv amas1 akoko_k hape peas lkm_k pekoko_k pety ak_koodi ///
			euref_1000 ch_no dest gdist odist odur, i(hid_e vuosi) j(ch)
			
		compress
		tempfile mgen`y'
		save mgen`y'
		
	}

*-------------------------------------------------------------------------------
* 3: Merge hospitalization data (1998–2020 only)
*-------------------------------------------------------------------------------

	forvalues i = 1998(1)2020 {
		use "W:\Afable\1 - Formatted Data\hosp9820.dta", clear
		keep if vuosi == `i'
		duplicates drop hid_e, force
		tempfile hosp`i'
		save `hosp`i''
	}
	
	forvalues y = 1998(1)2020 {
		use `mgen`y'', clear
		merge 1:1 hid_e using `hosp`y'', keep(match master) nogen
		
			foreach v of varlist hosp_length hosp_inpt {
				replace `v' = 0 if `v' == .
			}
			
			foreach v of varlist hosp_length hosp_inpt {
				gen bin_`v' = (`v' >= 1)
			}		
		
		save `mgen`y'', replace
	}

*-------------------------------------------------------------------------------
* 4: Append annual files into batches
*-------------------------------------------------------------------------------

use `mgen1998', clear
	append using `mgen1999' `mgen2000' `mgen2001' `mgen2002' ///
				 `mgen2003' `mgen2004' `mgen2005'
	save mgen9805, replace

	use `mgen2006', clear
	append using `mgen2007' `mgen2008' `mgen2009' `mgen2010' ///
				 `mgen2011' `mgen2012' `mgen2013' `mgen2014' `mgen2015'
	save mgen0615, replace

	use `mgen2016', clear
	append using `mgen2017' `mgen2018' `mgen2019' `mgen2020'
	save mgen1620, replace

	use `mgen2021', clear
	append using `mgen2022' `mgen2023'
	save mgen2123, replace
	
	
	
*===============================================================================
	log close
*===============================================================================
