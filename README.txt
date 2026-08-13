================================================================================
README 
================================================================================

Project   : 	Are aging parents and adult children living farther apart? 
		Decomposing trends in intergenerational proximity and 
		coresidence among Finnish parents aged 60–69 (2003–2023)
Journal   : 	Social Forces
DOI       : 	https://doi.org/10.1093/sf/soag043
Authors   : 	Sanny D Afable, Megan Evans, Kaarina Korhonen, Yana Vierboom , 
		Pekka Martikainen, Mikko Myrskylä, Hill Kulu
Contact   : 	sba4@st-andrews.ac.uk

--------------------------------------------------------------------------------
OVERVIEW
--------------------------------------------------------------------------------

Folder contains replication codes in Stata and R for the above publication.
The underlying register data are managed by Statistics Finland and are not
publicly available. Researchers wishing to access the data may apply through
Statistics Finland's remote access system (FIONA).

--------------------------------------------------------------------------------
SUB-FOLDERS
--------------------------------------------------------------------------------

  stata-do\		Contains all Stata do-files for data management and
			analysis

  graphs\		Contains all main and supplementary plots;
			R codes to generate them are available in graphs\r-codes

  postcodes\		Contains R file 'flcentroids' for generating postcode 
			centroids, geodesic distances, and a map of FL postcodes;
			it also contains a copy of the osrmtime command from 
			Christoph Rust: https://github.com/christophrust/osrmtime

--------------------------------------------------------------------------------
DESCRIPTION OF STATA DO FILES
--------------------------------------------------------------------------------

Stata do-files should be run in the order listed below.

  1_distancecalc.do	Calculates road distances between postcode centroids
                        in Finland using OpenStreetMap via OSRM. Produces the
                        distance key file osrm_dur.dta

  1_hosp.do             Aggregates hospital records (Care Register for Healthcare) 
			into annual person-level data

  2_data_merge.do       Builds the parent-child dataset and merges with
                        relevant register data sources

  3_data_variables.do   Prepares and codes all analysis variables

  4_analysis_main.do    Main analysis, including descriptive statistics
                        and regression models

  5_analysis_supp.do    Supplementary analyses

--------------------------------------------------------------------------------
NOTES
--------------------------------------------------------------------------------

    - Paths in the Stata do-files point to the FIONA environment and will need to
    be updated to match the user's local directory structure.

    - Due to large file sizes, origin-destination data for postcode centroids and the
    OSM-based distances are excluded from this replication folder but are available
    upon request.

================================================================================