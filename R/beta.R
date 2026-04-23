#' Alpha, beta, and gamma diversity (Jost 2007)
#'
#' Multiplicative decomposition of Hill-number diversity across rows of a
#' composition matrix. Alpha is the generalized mean of order `(1 - q)` of
#' per-row Hill numbers (Jost 2007, Eqs. 11a–11b), gamma is the Hill number
#' of the (possibly weighted) pooled composition, and beta is `gamma / alpha`.
#' beta is bounded in \[1, T\] and reads as the "effective number of
#' structurally distinct compositions" across the T rows. Vectorized over
#' `q`: one call returns a full beta profile.
#'
#' When `years` are supplied (and `collapse = TRUE`), consecutive identical
#' rows are collapsed via [collapse_to_elections()] so each unique
#' composition is counted once; weights default to term lengths so
#' long-lived elections do not dominate.
#'
#' @param mat numeric matrix of non-negative shares (rows = time points /
#'   systems; cols = parties). Accepts anything [as_composition()] accepts.
#' @param q numeric vector of orders. Default `c(0, 1, 2, 5)`.
#' @param w optional weights (numeric, `length = T`, summing to 1). If `NULL`,
#'   equal weights are used — or term lengths when `collapse = TRUE` and
#'   `years` are supplied.
#' @param years optional integer vector of election years aligned with `mat`.
#'   Enables collapsing identical consecutive rows.
#' @param collapse logical; defaults to `!is.null(years)`.
#'
#' @return S3 `"beta_diversity"` object — data.frame with columns `q`,
#'   `alpha`, `beta`, `gamma`, `T`. Attributes carry weights and collapse info.
#' @export
#' @examples
#' m <- rbind(c(0.5, 0.3, 0.2),
#'            c(0.4, 0.3, 0.3),
#'            c(0.5, 0.3, 0.2))
#' alpha_beta_gamma(m, q = c(0, 1, 2))
alpha_beta_gamma <- function(mat,
                             q = c(0, 1, 2, 5),
                             w = NULL,
                             years = NULL,
                             collapse = !is.null(years)) {
  mat <- as_composition(mat)

  term_length <- NULL
  start_year  <- NULL
  if (isTRUE(collapse)) {
    if (is.null(years)) {
      stop("alpha_beta_gamma(): `collapse = TRUE` requires `years`.",
           call. = FALSE)
    }
    if (length(years) != nrow(mat)) {
      stop("alpha_beta_gamma(): `years` must have one entry per row of `mat`.",
           call. = FALSE)
    }
    coll <- collapse_to_elections(mat, years)
    mat <- coll$mat
    term_length <- coll$term_length
    start_year  <- coll$start_year
    if (is.null(w)) w <- term_length / sum(term_length)
  }

  Tn <- nrow(mat)
  if (Tn < 2L) {
    stop("alpha_beta_gamma(): need at least 2 rows (after collapse).",
         call. = FALSE)
  }
  if (is.null(w)) w <- rep(1 / Tn, Tn)
  if (length(w) != Tn || any(w < 0) || abs(sum(w) - 1) > 1e-8) {
    stop("alpha_beta_gamma(): `w` must be non-negative and sum to 1.",
         call. = FALSE)
  }

  out <- data.frame(q = q, alpha = NA_real_, beta = NA_real_,
                    gamma = NA_real_, T = Tn)
  for (k in seq_along(q)) {
    abg <- hill_alpha_beta_one(mat, q[k], w)
    out$alpha[k] <- abg$alpha
    out$beta[k]  <- abg$beta
    out$gamma[k] <- abg$gamma
  }

  structure(out,
    class = c("beta_diversity", "data.frame"),
    weights = w,
    term_length = term_length,
    start_year = start_year,
    T = Tn
  )
}

hill_alpha_beta_one <- function(mat, q, w) {
  pooled    <- as.vector(w %*% mat)
  gamma_div <- hill_number(pooled, q)
  qD_t      <- apply(mat, 1, hill_number, q = q)

  if (is.infinite(q)) {
    # Limit: alpha is the (1/p_(1))-weighted harmonic mean; use direct limit.
    alpha_div <- 1 / sum(w * (1 / qD_t))
  } else if (abs(q - 1) < 1e-10) {
    alpha_div <- exp(sum(w * log(qD_t)))
  } else if (q == 0) {
    alpha_div <- sum(w * qD_t)
  } else {
    alpha_div <- (sum(w * qD_t^(1 - q)))^(1 / (1 - q))
  }

  list(alpha = alpha_div,
       beta  = gamma_div / alpha_div,
       gamma = gamma_div)
}

#' Collapse consecutive identical compositions
#'
#' Between elections the seat-share vector repeats across country-years;
#' using annual rows would implicitly weight each election by its term
#' length. This helper keeps only rows that differ from the previous row,
#' and returns the term length (in years) of each unique election.
#'
#' @param mat numeric matrix of compositions.
#' @param years integer vector of years, aligned with rows of `mat`.
#'
#' @return A list with elements `mat` (collapsed matrix), `term_length`
#'   (years each kept row spans), and `start_year`.
#' @export
collapse_to_elections <- function(mat, years) {
  mat <- as_composition(mat)
  if (length(years) != nrow(mat)) {
    stop("collapse_to_elections(): `years` must have one entry per row of `mat`.",
         call. = FALSE)
  }
  ord   <- order(years)
  mat   <- mat[ord, , drop = FALSE]
  years <- years[ord]

  if (nrow(mat) == 1L) {
    return(list(mat = mat, term_length = 1L, start_year = years))
  }

  changes <- c(TRUE,
               rowSums(abs(mat[-1, , drop = FALSE] -
                           mat[-nrow(mat), , drop = FALSE])) > 1e-10)
  keep_rows   <- which(changes)
  next_change <- c(keep_rows[-1] - 1L, length(years))
  term_length <- years[next_change] - years[keep_rows] + 1L

  list(mat         = mat[keep_rows, , drop = FALSE],
       term_length = term_length,
       start_year  = years[keep_rows])
}

#' @export
as.data.frame.beta_diversity <- function(x, ...) {
  as.data.frame(unclass(x), stringsAsFactors = FALSE)
}
