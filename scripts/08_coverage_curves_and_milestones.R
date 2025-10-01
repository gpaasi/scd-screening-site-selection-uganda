
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")

B0_path <- if (file.exists(file.path(out_dir,"CoRisk_unserved_5km.tif"))) {
  file.path(out_dir,"CoRisk_unserved_5km.tif")
} else file.path(out_dir,"CoRisk_HbSxPfPR_5km.tif")
B0 <- rast(B0_path)

prop_csv <- file.path(out_dir, sprintf("proposed_sites_HbSxPfPR_%dkm_%d.csv", service_radius_km, K_sites))
stopifnot(file.exists(prop_csv))

tab <- read.csv(prop_csv)
cov <- data.frame(rank = tab$rank,
                  captured_increment = tab$captured_at_pick,
                  captured_cum = tab$captured_cum)
cov$captured_pct <- 100 * cov$captured_cum / sum(values(B0), na.rm=TRUE)
write.csv(cov, file.path(out_dir,"coverage_curve_corisk_25km.csv"), row.names=FALSE)

# milestones
ranks <- c(10,20,30,40,50)
mil <- cov[cov$rank %in% ranks, c("rank","captured_pct")]
write.csv(mil, file.path(out_dir,"coverage_milestones_25km.csv"), row.names=FALSE)
