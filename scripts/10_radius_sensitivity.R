
suppressPackageStartupMessages(library(terra))
source("scripts/00_setup_paths.R")
source("R/greedy.R")

adm0 <- vect(adm0_shp)
B0 <- rast(file.path(out_dir, "CoRisk_HbSxPfPR_5km.tif"))

radii <- c(20,25,30,40,50)
curves <- list()
milestones <- data.frame()

baseline_sum <- sum(values(B0), na.rm=TRUE)

for (r in radii) {
  res <- greedy_place(B0, k=K_sites, radius_km = r, boundary = adm0)
  tab <- data.frame(rank = res$points$rank,
                    captured_increment = res$points$captured_at_pick)
  tab$captured_cum <- cumsum(tab$captured_increment)
  tab$captured_pct <- 100 * tab$captured_cum / baseline_sum
  tab$radius_km <- r
  curves[[as.character(r)]] <- tab
  # milestone site counts to reach 60/70/80%
  for (t in c(60,70,80)) {
    idx <- which(tab$captured_pct >= t)[1]
    milestones <- rbind(milestones, data.frame(radius_km=r, target_pct=t, sites_needed= ifelse(is.finite(idx), idx, NA)))
  }
}

curves_df <- do.call(rbind, curves)
write.csv(curves_df, file.path(out_dir, "coverage_curves_by_radius.csv"), row.names=FALSE)
write.csv(milestones, file.path(out_dir, "radius_sensitivity_milestones.csv"), row.names=FALSE)
