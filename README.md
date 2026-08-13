# Are Aging Parents and Adult Children Living Farther Apart?

**Decomposing trends in intergenerational proximity and coresidence among Finnish parents aged 60–69 (2003–2023)**

| | |
|---|---|
| **Journal** | Social Forces |
| **DOI** | [10.1093/sf/soag043](https://doi.org/10.1093/sf/soag043) |
| **Authors** | Sanny D Afable, Megan Evans, Kaarina Korhonen, Yana Vierboom, Pekka Martikainen, Mikko Myrskylä, Hill Kulu |
| **Contact** | [sba4@st-andrews.ac.uk](mailto:sba4@st-andrews.ac.uk) |

## Overview

This folder contains replication code in Stata and R for the publication above.

The underlying register data are managed by Statistics Finland and are not publicly available. Researchers wishing to access the data may apply through Statistics Finland's remote access system ([FIONA](https://stat.fi/tup/mikroaineistot/fiona_en.html)).

## Repository Structure

```
.
├── stata-do/       # All Stata do-files for data management and analysis
├── graphs/         # Main and supplementary plots
│   └── r-codes/    # R code used to generate the plots
└── postcodes/      # Postcode centroid generation, geodesic distances, and mapping
```

### `stata-do/`

Contains all Stata do-files for data management and analysis (see [Description of Stata Do Files](#description-of-stata-do-files) below).

### `graphs/`

Contains all main and supplementary plots. The R code used to generate them is available in `graphs/r-codes/`.

### `postcodes/`

Contains the R file `flcentroids`, used for generating postcode centroids, geodesic distances, and a map of Finnish postcodes. Also includes a copy of the `osrmtime` command by Christoph Rust: [github.com/christophrust/osrmtime](https://github.com/christophrust/osrmtime).

## Description of Stata Do Files

Do-files should be run in the order listed below.

| Order | File | Description |
|---|---|---|
| 1 | `1_distancecalc.do` | Calculates road distances between postcode centroids in Finland using OpenStreetMap via OSRM. Produces the distance key file `osrm_dur.dta`. |
| 1 | `1_hosp.do` | Aggregates hospital records (Care Register for Healthcare) into annual person-level data. |
| 2 | `2_data_merge.do` | Builds the parent-child dataset and merges with relevant register data sources. |
| 3 | `3_data_variables.do` | Prepares and codes all analysis variables. |
| 4 | `4_analysis_main.do` | Main analysis, including descriptive statistics and regression models. |
| 5 | `5_analysis_supp.do` | Supplementary analyses. |

> **Note:** `1_distancecalc.do` and `1_hosp.do` are both labeled step 1 and can be run independently of one another, but both must be completed before proceeding to step 2.

## Notes

- Paths in the Stata do-files point to the FIONA environment and will need to be updated to match the user's local directory structure.
- Due to large file sizes, origin-destination data for postcode centroids and the OSM-based distances are excluded from this replication folder but are available upon request.
