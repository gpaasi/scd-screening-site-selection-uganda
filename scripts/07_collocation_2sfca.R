
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")

gpkg <- file.path(out_dir, sprintf("Proposed_sites_HbSxPfPR_%dkm_%d.gpkg", service_radius_km, K_sites))
stopifnot(file.exists(gpkg))

props   <- vect(gpkg, layer = "proposed_sites_wgs84")
catches <- vect(catch_path)
if (is.lonlat(catches)) catches <- project(catches, "EPSG:32636")
props36 <- project(props, "EPSG:32636")

hit <- intersect(props36, catches)  # points carry polygon attrs
hit_wgs <- project(hit, "EPSG:4326")

# write matched points
writeVector(hit_wgs, file.path(out_dir,"proposed_matched_to_catchments.gpkg"),
            layer="props_in_catchments", overwrite=TRUE, filetype="GPKG")

# CSV table
xy <- crds(hit_wgs)
df <- cbind(as.data.frame(hit_wgs, geom=FALSE), data.frame(lon=xy[,1], lat=xy[,2]))
write.csv(df, file.path(out_dir,"proposed_matched_to_catchments.csv"), row.names=FALSE)
