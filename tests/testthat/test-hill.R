test_that("Hill q=0 equals count of nonzero entries", {
  p <- c(0.4, 0.3, 0.2, 0.1, 0)
  expect_equal(hill_number(p, 0), 4)
  expect_equal(hill_number(c(0, 0, 1), 0), 1)
})

test_that("Hill q=2 equals 1 / HHI", {
  p <- c(0.4, 0.3, 0.2, 0.1)
  expect_equal(hill_number(p, 2), 1 / sum(p^2))
})

test_that("Hill q=Inf equals 1 / max(p)", {
  p <- c(0.4, 0.3, 0.2, 0.1)
  expect_equal(hill_number(p, Inf), 1 / max(p))
})

test_that("Hill q=1 equals exp(Shannon) and matches limit", {
  p <- c(0.4, 0.3, 0.2, 0.1)
  expect_equal(hill_number(p, 1), exp(-sum(p * log(p))))
  # Limit: q near 1 should approach q = 1.
  near <- hill_number(p, 1 + 1e-6)
  expect_equal(near, hill_number(p, 1), tolerance = 1e-4)
})

test_that("Uniform simplex gives D(q) = k for all q", {
  k <- 7
  p <- rep(1 / k, k)
  for (q in c(0, 0.5, 1, 2, 5, Inf)) {
    expect_equal(hill_number(p, q), k, tolerance = 1e-9)
  }
})

test_that("Hill is vectorized over q", {
  p <- c(0.4, 0.3, 0.2, 0.1)
  qs <- c(0, 1, 2, Inf)
  out <- hill_number(p, qs)
  expect_equal(length(out), length(qs))
  expect_equal(out[1], 4)
  expect_equal(out[4], 1 / 0.4)
})

test_that("hill_number rejects negative q", {
  expect_error(hill_number(c(0.5, 0.5), -1))
})

test_that("hill_number on empty / zero input returns zeros", {
  expect_equal(hill_number(c(0, 0, 0), 2), 0)
})
