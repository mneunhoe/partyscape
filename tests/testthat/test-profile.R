# Tiny helper for a non-trivial composition; avoids depending on MCMCpack.
rdirichlet_fixed <- function(k) {
  x <- rgamma(k, shape = 1)
  x / sum(x)
}

test_that("diversity_profile is non-increasing in q", {
  set.seed(1)
  p <- as.numeric(rdirichlet_fixed(6))
  dp <- diversity_profile(p, q = seq(0, 5, 0.05))
  wide <- attr(dp, "wide")
  expect_true(all(diff(as.numeric(wide)) <= 1e-10))
})

test_that("evenness_profile at q=0 equals 1", {
  p <- c(0.5, 0.3, 0.2)
  ep <- evenness_profile(p, q = seq(0, 5, 0.1))
  wide <- attr(ep, "wide")
  expect_equal(wide[, 1], 1, ignore_attr = TRUE)
})

test_that("diversity_profile handles matrix input with row labels", {
  m <- rbind(a = c(0.4, 0.3, 0.3),
             b = c(0.7, 0.2, 0.1))
  dp <- diversity_profile(m, q = c(0, 1, 2))
  expect_setequal(unique(dp$id), c("a", "b"))
})

test_that("diversity_profile Inf anchor appears in grid when requested", {
  dp <- diversity_profile(c(0.6, 0.3, 0.1),
                          q = c(0, 1, 2, Inf))
  expect_true(any(is.infinite(attr(dp, "q"))))
})

test_that("subset [ by id returns a valid diversity_profile", {
  m <- rbind(a = c(0.4, 0.3, 0.3),
             b = c(0.7, 0.2, 0.1),
             c = c(0.5, 0.3, 0.2))
  dp <- diversity_profile(m, q = c(0, 1, 2))
  sub <- dp["b"]
  expect_s3_class(sub, "diversity_profile")
  expect_equal(attr(sub, "ids"), "b")
})
