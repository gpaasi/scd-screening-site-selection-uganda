# Prioritizing Sickle Cell Newborn Screening Sites in Uganda using HbS and PfPR with Greedy Selection
<!-- Badges -->
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17241990.svg)](https://doi.org/10.5281/zenodo.17241990)
[![Release](https://img.shields.io/github/v/release/gpaasi/scd-screening-site-selection-uganda)](https://github.com/gpaasi/scd-screening-site-selection-uganda/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![R >= 4.3](https://img.shields.io/badge/R-%3E%3D%204.3-276DC3?logo=r)
![renv](https://img.shields.io/badge/reproducibility-renv-success)
[![Issues](https://img.shields.io/github/issues/gpaasi/scd-screening-site-selection-uganda)](https://github.com/gpaasi/scd-screening-site-selection-uganda/issues)
[![Pull requests](https://img.shields.io/github/issues-pr/gpaasi/scd-screening-site-selection-uganda)](https://github.com/gpaasi/scd-screening-site-selection-uganda/pulls)

## Summary
This repository implements a geospatial siting workflow for newborn screening and clinic placement in Uganda. The pipeline assembles HbS allele frequency and PfPR2–10 rasters, aligns them on a 5 km analysis grid, builds a co‑risk surface as HbS × PfPR, and selects a ranked list of proposed sites using a deterministic greedy algorithm with a 25 km service radius. It also produces coverage curves, district equity summaries, radius sensitivity, and collocation of proposed sites to health facilities using two‑step floating catchment area (2SFCA) polygons.

Key outputs are GeoTIFF rasters, a GeoPackage of proposed sites and buffers, district‑level equity tables, and figures ready for a manuscript.

## Folder layout
```
.
├─ config/                     # central parameters
├─ data/
│  ├─ raw/                    # place inputs here
│  └─ processed/              # all outputs land here
├─ R/
│  ├─ greedy.R                # greedy selection utilities
│  ├─ utils_spatial.R         # CRS, alignment, masks, stats
│  └─ plot_helpers.R          # map and chart helpers
├─ scripts/
│  ├─ install_pkgs.R
│  ├─ 00_setup_paths.R
│  ├─ 03_pfpr_stack_and_mean.R
│  ├─ 04_build_corisk.R
│  ├─ 05_mask_unserved_25km.R           # optional
│  ├─ 06_greedy_select_25km.R
│  ├─ 07_collocation_2sfca.R
│  ├─ 08_coverage_curves_and_milestones.R
│  ├─ 09_equity_lorenz_gini.R
│  ├─ 10_radius_sensitivity.R
│  └─ 12_export_maps.R
├─ figures/
├─ docs/
│  ├─ METHODS_methods_draft.md
│  ├─ RESULTS_outline.md
│  └─ SUPPLEMENT_methods.md
├─ tests/
│  └─ test_greedy.R
├─ CITATION.cff
├─ LICENSE
└─ README.md
```

## Required inputs
Place under `data/raw/` unless you edit paths in `config/parameters.yaml` or `scripts/00_setup_paths.R`.

Essential
- `EBK_HbS3_UGA.tif`          HbS allele frequency prediction, about 1 km, values 0 to 1
- `PfPR_mean_2015_2024.tif`   Ten‑year mean PfPR2–10 on the MAP 5 km grid, values 0 to 1
- `geoBoundaries-UGA-ADM0.shp` with sidecars   Uganda boundary for extent and mask
- `geoBoundaries-UGA-ADM2.shp` with sidecars   District boundaries for equity

Optional
- `catchments_traveltime_voronoi1_60min_clean4.shp`  2SFCA polygons for collocation
- `202001_Global_Motorized_Friction_Surface_UGA.tiff` friction surface for travel‑time sensitivity
- `u5_pop_utm.tif`   under‑five population counts, only for people‑weighted variants

## Software
- R 4.3 or newer, GDAL, GEOS, PROJ
- R packages: `terra`, `dplyr`, `readr`, `ggplot2`, `sf`, `scales`

Install packages one time:
```r
source("scripts/install_pkgs.R")
```

## Configure
Edit `config/parameters.yaml`:
```yaml
paths:
  raw_dir: "data/raw"
  processed_dir: "data/processed"
  figures_dir: "figures"

files:
  hbS_raster: "EBK_HbS3_UGA.tif"
  pfpr_mean: "PfPR_mean_2015_2024.tif"
  adm0: "geoBoundaries-UGA-ADM0.shp"
  adm2: "geoBoundaries-UGA-ADM2.shp"
  catchments_2sfca: "catchments_traveltime_voronoi1_60min_clean4.shp"
  friction: "202001_Global_Motorized_Friction_Surface_UGA.tiff"

analysis:
  crs_analysis: "EPSG:32636"
  service_radius_km: 25
  n_sites: 50
  greedy_seed: 2025
  write_lzw: true
```

## Run the pipeline
1. Setup and validate paths
```r
source("scripts/00_setup_paths.R")
```
2. Build PfPR decade mean and endemicity
```r
source("scripts/03_pfpr_stack_and_mean.R")
```
3. Construct co‑risk HbS × PfPR
```r
source("scripts/04_build_corisk.R")
```
4. Greedy selection, 25 km radius, 50 sites
```r
source("scripts/06_greedy_select_25km.R")
```
5. Coverage curves, milestones, and equity
```r
source("scripts/08_coverage_curves_and_milestones.R")
source("scripts/09_equity_lorenz_gini.R")
```
6. Collocation to facilities using 2SFCA polygons
```r
source("scripts/07_collocation_2sfca.R")
```
7. Optional radius sensitivity
```r
source("scripts/10_radius_sensitivity.R")
```

## Key outputs
- `data/processed/CoRisk_HbSxPfPR_5km.tif`
- `data/processed/Proposed_sites_HbSxPfPR_25km_50.gpkg`   layers `proposed_sites_wgs84`, `proposed_buffers_analysis_crs`
- `data/processed/coverage_curve_corisk_25km.csv`, `coverage_milestones_25km.csv`
- `data/processed/captured_corisk_by_district_25km.csv`
- `figures/` maps and charts, including
  - `map_HbS.png`, `map_PfPR.png`, `map_PfPR_endemicity.png`, `map_CoRisk.png`
  - `Proposed_sites_map_25km.png`
  - `coverage_curve_corisk_25km.png`, `coverage_curves_by_radius.png`
  - `lorenz_captured_corisk_by_district.png`

## Troubleshooting
- Path or file errors: verify `config/parameters.yaml` and shapefile sidecars
- CRS mismatch: confirm all layers project to EPSG 32636 before resampling
- Flat or identical coverage curves: check that the baseline co‑risk raster has non‑zero values and that masking is applied as intended
- Collocation misses: confirm polygons are valid without gaps and share CRS with points

## Citing
Please cite this repository using `CITATION.cff` and the following methodological sources:
- Empirical Bayesian Kriging: Krivoruchko K. Esri Press, 2012
- Malaria Atlas Project PfPR surfaces: Weiss DJ et al., The Lancet 2019; Bhatt S et al., Nature 2015
- Greedy maximization and submodularity: Nemhauser GL et al., Mathematical Programming 1978
- Two‑step floating catchment area: Luo W, Wang F., Environment and Planning B 2003; Luo W, Qi Y., Health & Place 2009
- Lorenz and Gini: Gastwirth JL., Review of Economics and Statistics 1972
- R spatial stack: Hijmans RJ., `terra` package

## License
See LICENSE for a dual license: text and data under Creative Commons Attribution 4.0 International, code under MIT.
