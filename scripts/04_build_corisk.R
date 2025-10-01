
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")
source("R/utils_spatial.R")

adm0 <- vect(adm0_shp)
pf5  <- rast(file.path(out_dir, "PfPR_mean_2015_2024_aligned.tif"))

hb1k <- rast(hb_path)[[1]]
if (is.lonlat(hb1k)) hb1k <- project(hb1k, "EPSG:32636", method = "bilinear")

# aggregate HbS to PfPR 5 km grid
fac <- round(res(pf5)[1] / res(hb1k)[1])
hb5 <- aggregate(hb1k, fact = fac, fun = mean, na.rm = TRUE)
hb5 <- align_to(hb5, pf5, method="bilinear")

pf5 <- clamp01(mask_to(pf5, adm0))
hb5 <- clamp01(mask_to(hb5, adm0))

stopifnot(compareGeom(pf5, hb5, stopOnError = FALSE))

corisk <- hb5 * pf5
writeRaster(corisk, file.path(out_dir, "CoRisk_HbSxPfPR_5km.tif"),
            overwrite=TRUE, gdal=c("COMPRESS=LZW","TILED=YES"))
