
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")
adm0 <- vect(adm0_shp)
pf   <- rast(pf_path)[[1]]
if (is.lonlat(pf)) pf <- project(pf, "EPSG:32636", method="bilinear")
pf   <- clamp(mask(crop(pf, adm0), adm0), 0, 1, values = TRUE)
writeRaster(pf, file.path(out_dir, "PfPR_mean_2015_2024_aligned.tif"),
            overwrite=TRUE, gdal=c("COMPRESS=LZW","TILED=YES"))
