test_that("autoplot methods return ggplot objects", {
  skip_if_not_installed("ggplot2")

  p  <- c(0.4, 0.3, 0.2, 0.1)
  dp <- diversity_profile(p)
  ep <- evenness_profile(p)

  expect_s3_class(autoplot(dp), "ggplot")
  expect_s3_class(autoplot(ep), "ggplot")

  cr <- crossings(c(0.55, 0.15, 0.10, 0.08, 0.05, 0.04, 0.03),
                  c(0.40, 0.30, 0.30),
                  q = seq(0, 5, 0.05))
  expect_s3_class(autoplot(cr), "ggplot")

  m  <- rbind(c(0.5, 0.3, 0.2),
              c(0.4, 0.3, 0.3),
              c(0.3, 0.4, 0.3))
  bd <- alpha_beta_gamma(m, q = c(0, 1, 2))
  expect_s3_class(autoplot(bd), "ggplot")
})
