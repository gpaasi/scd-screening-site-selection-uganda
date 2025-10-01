
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")

corisk <- rast(file.path(out_dir, "CoRisk_HbSxPfPR_5km.tif"))
# Example "served" mask expected at out_dir; if not present, skip
served_mask <- file.path(out_dir, "served_mask_25km.tif")
if (file.exists(served_mask)) {
  served <- rast(served_mask)
  if (!same.crs(served, corisk)) served <- project(served, crs(corisk), method="near")
  served <- resample(served, corisk, method="near")
  unserved <- mask(corisk, served, inverse = TRUE)
  writeRaster(unserved, file.path(out_dir, "CoRisk_unserved_5km.tif"),
              overwrite=TRUE, gdal=c("COMPRESS=LZW","TILED=YES"))
} else {
  message("No served mask available; skipping unserved baseline.")
}
