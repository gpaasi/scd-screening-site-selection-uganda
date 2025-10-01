
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")
source("R/greedy.R")

adm0 <- vect(adm0_shp)
B0_path <- if (file.exists(file.path(out_dir,"CoRisk_unserved_5km.tif"))) {
  file.path(out_dir,"CoRisk_unserved_5km.tif")
} else file.path(out_dir,"CoRisk_HbSxPfPR_5km.tif")

B0 <- rast(B0_path)
res <- greedy_place(B0, k=K_sites, radius_km = service_radius_km, boundary = adm0)
proposed <- res$points
residual <- res$residual

# Save vectors (WGS84 for points; analysis CRS buffers)
gpkg <- file.path(out_dir, sprintf("Proposed_sites_HbSxPfPR_%dkm_%d.gpkg", service_radius_km, K_sites))
if (file.exists(gpkg)) file.remove(gpkg)
props_wgs <- project(proposed, "EPSG:4326")
writeVector(props_wgs, gpkg, layer="proposed_sites_wgs84", overwrite=TRUE, filetype="GPKG")

bufs <- buffer(proposed, service_radius_km*1000) |> intersect(adm0)
writeVector(bufs, gpkg, layer="proposed_buffers_analysis_crs", overwrite=TRUE, filetype="GPKG")

# CSV with coordinates and capture
xy <- crds(props_wgs)
tab <- data.frame(
  rank = props_wgs$rank,
  lon = xy[,1], lat = xy[,2],
  captured_at_pick = proposed$captured_at_pick
)
tab$captured_cum <- cumsum(tab$captured_at_pick)
write.csv(tab, file.path(out_dir, sprintf("proposed_sites_HbSxPfPR_%dkm_%d.csv", service_radius_km, K_sites)), row.names=FALSE)

writeRaster(residual, file.path(out_dir, sprintf("CoRisk_residual_after_%d_sites.tif", K_sites)),
            overwrite=TRUE, gdal=c("COMPRESS=LZW","TILED=YES"))
