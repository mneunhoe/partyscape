test_that("taagepera_allik_shares sums to 1 and is decreasing", {
  for (n0 in 1:8) {
    s <- taagepera_allik_shares(n0)
    expect_length(s, n0)
    expect_equal(sum(s), 1, tolerance = 1e-10)
    if (n0 >= 2) expect_true(all(diff(s) <= 1e-10))
  }
})

test_that("taagepera_allik_shares rejects invalid n0", {
  expect_error(taagepera_allik_shares(0))
  expect_error(taagepera_allik_shares(-1))
})
