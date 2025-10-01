
suppressPackageStartupMessages(library(terra))

plot_with_border <- function(r, border, fname, title_txt, width=1600, height=1200, res=180) {
  png(fname, width=width, height=height, res=res)
  plot(r, main=title_txt, axes=FALSE, box=FALSE, mar=c(2,2,2,2))
  lines(border, lwd=1.2)
  dev.off()
}
