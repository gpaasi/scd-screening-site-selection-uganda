
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")

adm2 <- vect(adm2_shp)
B0_path <- if (file.exists(file.path(out_dir,"CoRisk_unserved_5km.tif"))) {
  file.path(out_dir,"CoRisk_unserved_5km.tif")
} else file.path(out_dir,"CoRisk_HbSxPfPR_5km.tif")
B0 <- rast(B0_path)
resid <- rast(file.path(out_dir, sprintf("CoRisk_residual_after_%d_sites.tif", K_sites)))

cap <- B0 - resid
z <- zonal(cap, adm2, fun="sum", na.rm=TRUE)
z <- z[order(z$sum, decreasing=TRUE), ]
z$cum_share_districts <- (seq_len(nrow(z)))/nrow(z)
z$cum_share_capture   <- cumsum(z$sum)/sum(z$sum, na.rm=TRUE)

# Gini: 1 - 2 * area under Lorenz
auc <- sum( (head(z$cum_share_capture,-1) + tail(z$cum_share_capture,-1)) *
            diff(z$cum_share_districts) / 2 )
gini <- 1 - 2*auc

write.csv(z, file.path(out_dir, "captured_corisk_by_district_25km.csv"), row.names=FALSE)
write.csv(data.frame(gini=gini), file.path(out_dir, "gini_captured_corisk_25km.csv"), row.names=FALSE)
