#' Taagepera–Allik expected seat shares
#'
#' Recursive closed-form mean shares under the Taagepera–Allik null model
#' for a system of `n0` parties. Used as a reference composition when
#' benchmarking empirical profiles.
#'
#' @param n0 integer, number of parties (must be >= 1).
#' @return numeric vector of length `n0`, sums to 1.
#' @references Taagepera, R., & Allik, M. (2006). Seat share distribution of
#'   parties: Models and empirical patterns. *Electoral Studies*, 25(4),
#'   696–713.
#' @export
#' @examples
#' taagepera_allik_shares(4)
taagepera_allik_shares <- function(n0) {
  n0 <- as.integer(n0)
  if (length(n0) != 1L || is.na(n0) || n0 < 1L) {
    stop("taagepera_allik_shares(): `n0` must be a positive integer.",
         call. = FALSE)
  }
  s <- numeric(n0)
  s[1] <- 1 / sqrt(n0)
  if (n0 >= 2L) {
    for (i in 2:n0) {
      s[i] <- (1 - sum(s[1:(i - 1L)])) / sqrt(n0 - i + 1L)
    }
  }
  s / sum(s)
}
