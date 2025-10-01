
suppressPackageStartupMessages(library(terra))

align_to <- function(x, template, method = c("bilinear","near")[1]) {
  if (!same.crs(x, template)) x <- project(x, crs(template), method = method)
  resample(x, template, method = method)
}

mask_to <- function(r, poly) mask(crop(r, poly), poly)

clamp01 <- function(r) clamp(r, 0, 1, values = TRUE)

extent_ok <- function(a, b) !is.null(intersect(ext(a), ext(b)))
