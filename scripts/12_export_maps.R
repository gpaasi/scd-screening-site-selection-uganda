
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")
source("R/plot_helpers.R")

adm0 <- vect(adm0_shp)

pf  <- rast(file.path(out_dir, "PfPR_mean_2015_2024_aligned.tif"))
hb5 <- rast(hb_path)
corisk <- rast(file.path(out_dir, "CoRisk_HbSxPfPR_5km.tif"))

plot_with_border(pf,  adm0, file.path("figures","map_PfPR.png"),  "PfPR mean 2015–2024 (5 km)")
plot_with_border(hb5, adm0, file.path("figures","map_HbS.png"),   "HbS prediction (native grid)")
plot_with_border(corisk, adm0, file.path("figures","map_CoRisk.png"), "Co-risk HbS × PfPR (5 km)")
