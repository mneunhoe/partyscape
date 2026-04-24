#' Hill number of order q
#'
#' Computes the Hill number (true diversity) of order `q` for a single
#' composition vector. Handles the limiting cases `q = 0` (richness),
#' `q = 1` (exponential of Shannon entropy), and `q = Inf` (`1 / max(p)`)
#' explicitly. Vectorized over `q`: pass a vector and get back a vector.
#'
#' @param p numeric vector of non-negative weights summing to (roughly) 1.
#'   Zeros are allowed and ignored.
#' @param q non-negative numeric scalar or vector, the order. `q = Inf` is
#'   allowed.
#'
#' @return Numeric scalar (if `length(q) == 1`) or numeric vector with
#'   `length(q)` entries.
#' @seealso [diversity_profile()], [enp()], [hhi()].
#' @export
#' @examples
#' # Party-labeled composition — column order carries party identity,
#' # NOT rank. The largest party is whichever entry is largest.
#' germany_2009 <- c(CDU = 0.312, CSU = 0.072, SPD = 0.235,
#'                   FDP = 0.150, Gruene = 0.109, Linke = 0.122)
#' hill_number(germany_2009, 0)      # 6 nonzero parties
#' hill_number(germany_2009, 1)      # exp(Shannon)
#' hill_number(germany_2009, 2)      # ENP = 1 / sum(p^2)
#' hill_number(germany_2009, Inf)    # 1 / max(p)
#' hill_number(germany_2009, c(0, 1, 2, Inf))
hill_number <- function(p, q) {
  p <- as.numeric(p)
  p <- p[p > 0]
  if (length(p) == 0L) return(rep(0, length(q)))
  if (any(!is.finite(q[is.finite(q)])) || any(q < 0)) {
    stop("hill_number(): `q` must be non-negative; `Inf` is allowed.",
         call. = FALSE)
  }
  vapply(q, function(qi) hill_one(p, qi), numeric(1))
}

# Core: a single q against a pre-stripped positive p.
hill_one <- function(p, q) {
  if (is.infinite(q)) return(1 / max(p))
  if (abs(q - 1) < 1e-10) return(exp(-sum(p * log(p))))
  if (q == 0) return(length(p))
  sum(p^q)^(1 / (1 - q))
}

#' Diversity profile
#'
#' Computes the full diversity profile D(q) over a grid of q values for one
#' or many compositions. Returns an S3 object suitable for [autoplot()],
#' [plot()], and subset extraction via `[`.
#'
#' @param x numeric vector, matrix, or data.frame of non-negative shares.
#'   Multiple rows compute one profile per row.
#' @param q numeric vector of orders at which to evaluate D(q). Default is
#'   a fine grid `seq(0, 5, 0.05)`. `Inf` is allowed.
#' @param anchors numeric vector of "highlight" q values to store as
#'   anchors (useful for plotting). Default `c(0, 1, 2, 5, Inf)`.
#' @param id optional character vector of row labels.
#'
#' @return An S3 `"diversity_profile"` object — a long data.frame with
#'   columns `id`, `q`, `D`, plus attributes `q` (grid), `anchors`,
#'   `n_parties`, and `wide` (the id-by-q matrix).
#' @export
#' @examples
#' # Party-labeled shares (order is party identity, not size).
#' germany_2009 <- c(CDU = 0.312, CSU = 0.072, SPD = 0.235,
#'                   FDP = 0.150, Gruene = 0.109, Linke = 0.122)
#' dp <- diversity_profile(germany_2009)
#' print(dp)
#' plot(dp)
diversity_profile <- function(x,
                              q = seq(0, 5, by = 0.05),
                              anchors = c(0, 1, 2, 5, Inf),
                              id = NULL) {
  mat <- as_composition(x, id = id)
  q <- sort(unique(as.numeric(q)))
  stopifnot(length(q) >= 1L)

  wide <- matrix(NA_real_, nrow = nrow(mat), ncol = length(q),
                 dimnames = list(rownames(mat), format(q)))
  for (i in seq_len(nrow(mat))) {
    wide[i, ] <- hill_number(mat[i, ], q)
  }

  long <- data.frame(
    id = rep(rownames(mat), each = length(q)),
    q  = rep(q, times = nrow(mat)),
    D  = as.numeric(t(wide)),
    stringsAsFactors = FALSE
  )

  structure(
    long,
    class = c("diversity_profile", "data.frame"),
    q = q,
    anchors = anchors,
    ids = rownames(mat),
    n_parties = rowSums(mat > 0),
    wide = wide
  )
}

#' Evenness profile
#'
#' Evenness E(q) = D(q) / D(0), the diversity profile rescaled to lie on
#' \[0, 1\]. At q = 0 evenness equals 1 by construction; it decreases
#' (weakly) in q for any non-uniform composition.
#'
#' @inheritParams diversity_profile
#' @return An S3 `"evenness_profile"` object (data.frame with columns
#'   `id`, `q`, `E`).
#' @export
evenness_profile <- function(x,
                             q = seq(0, 5, by = 0.05),
                             anchors = c(0, 1, 2, 5, Inf),
                             id = NULL) {
  prof <- diversity_profile(x, q = q, anchors = anchors, id = id)
  wide <- attr(prof, "wide")
  D0   <- wide[, 1L]  # q[1] is smallest; we sort q ascending so it's the min.
  # If caller skipped q = 0 we still anchor to D(0) via richness.
  if (!isTRUE(all.equal(attr(prof, "q")[1L], 0))) {
    n_parties <- attr(prof, "n_parties")
    D0 <- n_parties
  }
  E_wide <- sweep(wide, 1, D0, FUN = "/")

  long <- data.frame(
    id = rep(rownames(wide), each = ncol(wide)),
    q  = rep(attr(prof, "q"), times = nrow(wide)),
    E  = as.numeric(t(E_wide)),
    stringsAsFactors = FALSE
  )
  structure(
    long,
    class = c("evenness_profile", "data.frame"),
    q = attr(prof, "q"),
    anchors = anchors,
    ids = rownames(wide),
    n_parties = attr(prof, "n_parties"),
    wide = E_wide
  )
}

#' Subset a diversity profile by id
#' @param x a `diversity_profile` object.
#' @param i character or integer vector of ids to keep.
#' @param ... ignored.
#' @export
`[.diversity_profile` <- function(x, i, ...) {
  if (missing(i)) return(x)
  ids <- attr(x, "ids")
  if (is.character(i)) {
    keep <- ids %in% i
    keep_mat <- keep
  } else {
    keep <- rep(FALSE, length(ids))
    keep[i] <- TRUE
    keep_mat <- keep
  }
  wide <- attr(x, "wide")[keep_mat, , drop = FALSE]
  long <- as.data.frame(unclass(x))
  long <- long[long$id %in% ids[keep_mat], , drop = FALSE]
  rownames(long) <- NULL
  structure(
    long,
    class = c("diversity_profile", "data.frame"),
    q = attr(x, "q"),
    anchors = attr(x, "anchors"),
    ids = ids[keep_mat],
    n_parties = attr(x, "n_parties")[keep_mat],
    wide = wide
  )
}

#' @export
as.data.frame.diversity_profile <- function(x, ...) {
  as.data.frame(unclass(x), stringsAsFactors = FALSE)
}

#' @export
as.data.frame.evenness_profile <- function(x, ...) {
  as.data.frame(unclass(x), stringsAsFactors = FALSE)
}
