
# Greedy placement on a continuous raster burden surface
suppressPackageStartupMessages(library(terra))

greedy_place <- function(burden, k = 50, radius_km = 25, boundary = NULL) {
  stopifnot(inherits(burden, "SpatRaster"))
  r_m <- radius_km * 1000
  cur <- burden
  pts <- list(); vals <- numeric(0)
  for (i in seq_len(k)) {
    v <- values(cur)
    if (all(is.na(v))) break
    vmax <- suppressWarnings(max(v, na.rm = TRUE))
    if (!is.finite(vmax) || vmax <= 0) break
    idx <- which.max(v)
    xy  <- xyFromCell(cur, idx)
    val <- v[idx]
    pts[[length(pts) + 1]] <- xy
    vals <- c(vals, val)
    pt  <- vect(matrix(xy, ncol = 2), crs = crs(cur))
    buf <- buffer(pt, width = r_m)
    if (!is.null(boundary)) buf <- intersect(buf, boundary)
    cur <- mask(cur, buf, inverse = TRUE)
  }
  if (!length(pts)) return(list(points = NULL, residual = cur))
  coords <- do.call(rbind, pts)
  out    <- vect(coords, crs = crs(burden))
  out$rank <- seq_len(nrow(coords))
  out$captured_at_pick <- vals
  list(points = out, residual = cur)
}
