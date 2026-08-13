*************************************************************************************************
* CODES FOR CALCULATING SHORTEST-TRAVEL TIME DISTANCE BETWEEN 
* ANY TWO POSTCODE CENTROIDS IN FINLANDUSING OPENSTREET MAP

* Sanny D. Afable
* Max Planck Institute for Demographic Research &
* University of St Andrews

************************************************************************************************

* 	Important preliminaries

	/// Install Visual C++ Redistributable for Visual Studio 2015:
	/// https://www.microsoft.com/en-gb/download/details.aspx?id=48145
	
	/// Requires installing the osrmtime package
	/// More details: https://journals.sagepub.com/doi/pdf/10.1177/1536867X1601600209

	/// Known bug: it is necessary to provide a path without spaces, e.g., Downloads
	
	/// Move all contents of osrm_win_v5.14 into osrmtime_v1.3.6
	
*	Install osrmtime

	net describe osrmtime, from("D:\Downloads\osrmtime_v1.3.6")

	net install osrmtime
	net get osrmtime

*	Import Finland's OpenStreetMap (OSM), which may be downloaded from https://download.openstreetmap.fr/extracts/europe/

	osrmprepare, mapfile("D:\Downloads\finland.osm.pbf") profile(car) osrmdir("D:\Downloads\osrmtime_v1.3.6") 

*	Import geo-coded centroids of postcodes in Finland
	
	use "D:\OneDrive - University of St Andrews\PhD Paper 2\Codes\postcodes\pcpairmat.dta"
	osrmtime orig_lat orig_long dest_lat dest_long, mapfile("D:\Downloads\finland.osrm") profile(car) ///
	osrmdir("D:\Downloads\osrmtime_v1.3.6") 