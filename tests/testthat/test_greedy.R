
test_that("greedy_place returns expected components", {
  r <- rast(ncols=10, nrows=10, xmin=0, xmax=100, ymin=0, ymax=100, vals=runif(100))
  v <- greedy_place(r, k=5, radius_km=1)
  expect_true(all(c("points","residual") %in% names(v)))
})
