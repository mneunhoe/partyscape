test_that("beta is bounded in [1, T] and alpha <= gamma", {
  set.seed(2)
  m <- t(replicate(5, {
    x <- rgamma(4, 1); x / sum(x)
  }))
  bd <- alpha_beta_gamma(m, q = c(0, 1, 2, 5))
  expect_true(all(bd$beta >= 1 - 1e-8))
  expect_true(all(bd$beta <= bd$T + 1e-8))
  expect_true(all(bd$alpha <= bd$gamma + 1e-8))
})

test_that("identical rows give beta = 1", {
  m <- rbind(c(0.4, 0.3, 0.3),
             c(0.4, 0.3, 0.3),
             c(0.4, 0.3, 0.3))
  bd <- alpha_beta_gamma(m, q = c(0, 1, 2))
  expect_equal(bd$beta, rep(1, 3), tolerance = 1e-10)
})

test_that("disjoint-support rows at q=0 give beta = T", {
  m <- rbind(c(1, 0, 0, 0),
             c(0, 1, 0, 0),
             c(0, 0, 1, 0),
             c(0, 0, 0, 1))
  bd <- alpha_beta_gamma(m, q = 0)
  expect_equal(bd$beta, 4)
})

test_that("equal weights match the w = NULL default", {
  set.seed(3)
  m <- t(replicate(4, {
    x <- rgamma(3, 1); x / sum(x)
  }))
  b1 <- alpha_beta_gamma(m, q = c(0, 1, 2))
  b2 <- alpha_beta_gamma(m, q = c(0, 1, 2), w = rep(1 / 4, 4))
  expect_equal(b1$beta, b2$beta)
})

test_that("collapse_to_elections drops repeated consecutive rows", {
  m <- rbind(c(0.5, 0.3, 0.2),  # 2000
             c(0.5, 0.3, 0.2),  # 2001 — same
             c(0.4, 0.3, 0.3),  # 2002 — new
             c(0.4, 0.3, 0.3))  # 2003 — same
  out <- collapse_to_elections(m, years = 2000:2003)
  expect_equal(nrow(out$mat), 2)
  expect_equal(out$term_length, c(2L, 2L))
  expect_equal(out$start_year, c(2000L, 2002L))
})

test_that("alpha_beta_gamma with years auto-collapses and weights by term length", {
  m <- rbind(c(0.5, 0.3, 0.2),
             c(0.5, 0.3, 0.2),
             c(0.4, 0.3, 0.3))
  bd <- alpha_beta_gamma(m, q = 2, years = c(2000, 2001, 2002))
  expect_equal(attr(bd, "T"), 2)
  expect_equal(sum(attr(bd, "weights")), 1)
})
