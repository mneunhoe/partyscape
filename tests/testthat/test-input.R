test_that("non-normalized input warns and normalizes", {
  seats <- c(100, 60, 40)
  expect_warning(m <- as_composition(seats))
  expect_equal(rowSums(m), 1, ignore_attr = TRUE)
})

test_that("negative entries error", {
  expect_error(as_composition(c(0.5, -0.1, 0.6)))
})

test_that("zero-sum row errors", {
  expect_error(as_composition(c(0, 0, 0)))
})

test_that("NA/NaN/Inf entries error", {
  expect_error(as_composition(c(0.5, NA, 0.5)))
  expect_error(as_composition(c(0.5, Inf, 0.5)))
})

test_that("data.frame input drops non-numeric columns", {
  df <- data.frame(label = c("a", "b"),
                   p1 = c(0.5, 0.4),
                   p2 = c(0.3, 0.35),
                   p3 = c(0.2, 0.25))
  expect_message(m <- as_composition(df))
  expect_equal(dim(m), c(2, 3))
})

test_that("pivot_to_wide round-trips to the same totals", {
  long <- data.frame(
    id    = c("A", "A", "A", "B", "B"),
    party = c("x", "y", "z", "x", "z"),
    share = c(0.5, 0.3, 0.2, 0.7, 0.3)
  )
  w <- pivot_to_wide(long, "id", "party", "share")
  expect_equal(dim(w), c(2, 3))
  expect_equal(rowSums(w), c(A = 1, B = 1))
})
