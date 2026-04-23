## Scalar summaries of a composition. Each works on a numeric vector, and
## the `.matrix`/data.frame dispatch returns one value per row. No S3 class
## wrapper — these are one-line summaries meant for direct use.

#' Herfindahl–Hirschman index
#'
#' `hhi(p) = sum(p^2)`. Equals 1 when one party takes everything and
#' `1/k` for k equal shares. Complement of [rae()].
#' @param p numeric vector / matrix / data.frame of shares.
#' @return numeric scalar or vector (one value per row).
#' @export
hhi <- function(p) apply_share_stat(p, function(x) sum(x^2))

#' Rae's fractionalization
#'
#' `rae(p) = 1 - hhi(p)`. The probability that two randomly chosen parties
#' (with replacement, by share) come from different parties.
#' @inheritParams hhi
#' @export
rae <- function(p) apply_share_stat(p, function(x) 1 - sum(x^2))

#' Effective number of parties (Laakso–Taagepera)
#'
#' `enp(p) = 1 / hhi(p)`. Equal to [hill_number()] at q = 2.
#' `effective_parties()` is an alias.
#' @inheritParams hhi
#' @export
enp <- function(p) apply_share_stat(p, function(x) 1 / sum(x^2))

#' @rdname enp
#' @export
effective_parties <- function(p) enp(p)

#' Dominance gap
#'
#' Largest minus second-largest share. Highly sensitive to plurality
#' structure; used in the paper's crossing diagnostics.
#' @inheritParams hhi
#' @export
dominance_gap <- function(p) {
  apply_share_stat(p, function(x) {
    if (length(x) < 2L) return(if (length(x)) max(x) else NA_real_)
    s <- sort(x, decreasing = TRUE)
    s[1] - s[2]
  })
}

#' Top-two share
#'
#' Sum of the two largest shares. Reports the "two-big-parties" footprint.
#' @inheritParams hhi
#' @export
top_two <- function(p) {
  apply_share_stat(p, function(x) {
    if (length(x) < 2L) return(if (length(x)) max(x) else NA_real_)
    sum(sort(x, decreasing = TRUE)[1:2])
  })
}

# Dispatch helper: accepts numeric vector or matrix/data.frame. For matrices
# the statistic is evaluated row-wise and a named vector is returned.
apply_share_stat <- function(p, fn) {
  if (is.numeric(p) && !is.matrix(p) && !is.data.frame(p)) {
    p <- as_composition(p)
  } else {
    p <- as_composition(p)
  }
  if (nrow(p) == 1L) return(fn(p[1, ]))
  out <- apply(p, 1, fn)
  names(out) <- rownames(p)
  out
}
