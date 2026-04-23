test_that("crossings(a, b) equals crossings(b, a) in count and first_q", {
  a <- c(0.55, 0.15, 0.10, 0.08, 0.05, 0.04, 0.03)
  b <- c(0.40, 0.30, 0.30)
  c1 <- crossings(a, b, q = seq(0, 5, 0.01))
  c2 <- crossings(b, a, q = seq(0, 5, 0.01))
  expect_equal(c1$pairs$n_crossings, c2$pairs$n_crossings)
  expect_equal(c1$pairs$first_q, c2$pairs$first_q, tolerance = 1e-6)
})

test_that("identical compositions produce zero crossings", {
  p <- c(0.4, 0.3, 0.2, 0.1)
  cr <- crossings(p, p)
  expect_equal(cr$pairs$n_crossings, 0L)
})

test_that("interp and signchange agree on n_crossings for a fine grid", {
  a <- c(0.55, 0.15, 0.10, 0.08, 0.05, 0.04, 0.03)
  b <- c(0.40, 0.30, 0.30)
  c_interp <- crossings(a, b, q = seq(0, 5, 0.002), method = "interp")
  c_sign   <- crossings(a, b, q = seq(0, 5, 0.002), method = "signchange")
  expect_equal(c_interp$pairs$n_crossings, c_sign$pairs$n_crossings)
})

test_that("matrix input gives all pairwise with canonical i < j", {
  m <- rbind(x = c(0.6, 0.2, 0.1, 0.1),
             y = c(0.5, 0.3, 0.2, 0),
             z = c(0.35, 0.35, 0.30, 0))
  cr <- crossings(m)
  expect_equal(nrow(cr$pairs), 3L)  # 3 choose 2
  expect_true(all(cr$pairs$i < cr$pairs$j))
})

test_that("crossings works when feeding a diversity_profile directly", {
  m <- rbind(a = c(0.5, 0.3, 0.2),
             b = c(0.4, 0.35, 0.25))
  dp <- diversity_profile(m)
  cr <- crossings(dp)
  expect_s3_class(cr, "crossings")
})
