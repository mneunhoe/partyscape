test_that("parlgov_seat_shares reshapes a tiny in-memory long table", {
  long <- data.frame(
    country = rep(c("Atlantis", "Ruritania"), each = 3),
    date    = c("2000-06-01", "2000-06-01", "2000-06-01",
                "2004-10-01", "2004-10-01", "2004-10-01"),
    type    = rep("parliament", 6),
    party   = c("A", "B", "C", "X", "Y", "Z"),
    seats   = c(50, 30, 20, 40, 35, 25),
    votes   = c(1000, 600, 400, 900, 700, 500)
  )
  out <- parlgov_seat_shares(long)
  expect_equal(dim(out), c(2, 6))  # 6 parties total (disjoint sets)
  expect_equal(rowSums(out), c(Atlantis_2000 = 1, Ruritania_2004 = 1))
})

test_that("fetch_parlgov is available (not called) with network skip", {
  skip_on_cran()
  skip_if_offline <- function() {
    if (identical(Sys.getenv("partyscape_ONLINE"), "TRUE")) return(invisible())
    skip("set partyscape_ONLINE=TRUE to run this test")
  }
  skip_if_offline()
  skip_if_not_installed("curl")
  df <- fetch_parlgov()
  expect_true(is.data.frame(df))
  expect_true(all(c("country", "date", "party") %in% names(df)))
})
