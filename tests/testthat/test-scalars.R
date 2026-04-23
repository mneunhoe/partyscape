test_that("hhi, rae, enp are internally consistent", {
  p <- c(0.4, 0.3, 0.2, 0.1)
  expect_equal(hhi(p), sum(p^2))
  expect_equal(rae(p), 1 - hhi(p))
  expect_equal(enp(p), 1 / hhi(p))
  expect_equal(effective_parties(p), enp(p))
})

test_that("enp equals hill_number at q = 2", {
  p <- c(0.5, 0.25, 0.25)
  expect_equal(enp(p), hill_number(p, 2))
})

test_that("dominance_gap and top_two", {
  p <- c(0.45, 0.30, 0.15, 0.10)
  expect_equal(dominance_gap(p), 0.15)
  expect_equal(top_two(p), 0.75)
})

test_that("matrix input returns one value per row", {
  m <- rbind(a = c(0.4, 0.3, 0.3),
             b = c(0.7, 0.2, 0.1))
  out <- enp(m)
  expect_length(out, 2)
  expect_equal(names(out), c("a", "b"))
})
