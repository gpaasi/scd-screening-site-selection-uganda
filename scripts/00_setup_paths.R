
# Centralized paths and knobs. Edit to your machine if needed.
root    <- "C:/Users/Dr. Nancy/OneDrive/Documents"
adm_dir <- file.path(root, "geoBoundaries-UGA-ADM0-all")

pf_path <- file.path(root, "PfPR_mean_2015_2024.tif")
hb_path <- file.path(root, "EBK_HbS3_UGA.tif")
adm0_shp <- file.path(adm_dir, "geoBoundaries-UGA-ADM0.shp")
adm2_shp <- file.path(root, "geoBoundaries-UGA-ADM2.shp")

catch_path <- file.path(root, "catchments", "catchments_traveltime_voronoi1_60min_clean4.shp")
fac_csv    <- file.path(root, "facilities_filtered_selected_types.csv")

out_dir <- file.path(root, "co_risk_sites_outputs_25km")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

service_radius_km <- 25
K_sites <- 50
set.seed(2025)
