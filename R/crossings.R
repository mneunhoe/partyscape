#' Diversity-profile crossings
#'
#' Detects q values at which two diversity profiles D_a(q) and D_b(q) change
#' order — the central notion of "structural incomparability" in the paper.
#' Two detection strategies are available.
#'
#' - `"interp"`: linear interpolation between grid points where
#'   `D_a(q) - D_b(q)` changes sign. Precise crossing location; sensitive to
#'   noise in the grid.
#' - `"signchange"`: count sign changes of the non-zero difference sequence.
#'   Cheap and robust; reports the first crossing's grid location rather than
#'   an interpolated value.
#'
#' @param x one of:
#'   - a numeric vector (requires non-null `y`),
#'   - a numeric matrix with rows = systems,
#'   - a [diversity_profile] object.
#' @param y optional second composition or profile. If supplied and `x` is a
#'   single composition / profile, a single pair is scored. Ignored when
#'   `x` is itself multi-row.
#' @param q grid of q values at which to evaluate profiles (when `x`/`y` are
#'   compositions rather than profiles). Default `seq(0, 5, 0.05)`.
#' @param method one of `"interp"` or `"signchange"`.
#' @param tol numeric tolerance for equality to zero.
#'
#' @return S3 `"crossings"` list with elements:
#'   - `pairs` — data.frame with columns `i`, `j`, `id_i`, `id_j`,
#'     `n_crossings`, `first_q`.
#'   - `locations` — named list of numeric q* vectors, one per pair.
#'   - `profiles` — the underlying [diversity_profile] (for plotting).
#' @export
#' @examples
#' a <- c(0.45, 0.30, 0.15, 0.10)
#' b <- c(0.40, 0.35, 0.15, 0.10)
#' crossings(a, b)
#'
#' mat <- rbind(a = a, b = b, c = c(0.7, 0.2, 0.1, 0))
#' crossings(mat)
crossings <- function(x, y = NULL,
                      q = seq(0, 5, by = 0.05),
                      method = c("interp", "signchange"),
                      tol = 1e-12) {
  method <- match.arg(method)

  # Normalize inputs to a diversity_profile ------------------------------------
  prof <- crossings_profile(x, y, q = q)
  q_vec <- attr(prof, "q")
  wide  <- attr(prof, "wide")
  ids   <- attr(prof, "ids")
  n     <- nrow(wide)

  if (n < 2L) {
    stop("crossings(): need at least two compositions to compare.",
         call. = FALSE)
  }

  pairs_df <- data.frame(i = integer(), j = integer(),
                         id_i = character(), id_j = character(),
                         n_crossings = integer(),
                         first_q = numeric(),
                         stringsAsFactors = FALSE)
  locs <- list()

  detector <- if (method == "interp") find_crossings_interp else find_crossings_signchange

  for (i in seq_len(n - 1L)) {
    for (j in (i + 1L):n) {
      cr <- detector(wide[i, ], wide[j, ], q_vec, tol = tol)
      key <- paste(ids[i], ids[j], sep = " vs ")
      locs[[key]] <- cr
      pairs_df <- rbind(pairs_df, data.frame(
        i = i, j = j,
        id_i = ids[i], id_j = ids[j],
        n_crossings = length(cr),
        first_q = if (length(cr)) cr[1] else NA_real_,
        stringsAsFactors = FALSE
      ))
    }
  }

  structure(
    list(pairs = pairs_df, locations = locs, profiles = prof),
    class = "crossings",
    method = method,
    q = q_vec
  )
}

# Normalize heterogeneous input to a diversity_profile. ------------------------
crossings_profile <- function(x, y, q) {
  if (inherits(x, "diversity_profile")) {
    if (!is.null(y)) {
      y_prof <- if (inherits(y, "diversity_profile")) y else
        diversity_profile(y, q = attr(x, "q"))
      return(stack_profiles(x, y_prof))
    }
    return(x)
  }

  if (is.null(y)) {
    # x alone: must be matrix/data.frame with >= 2 rows.
    return(diversity_profile(x, q = q))
  }

  # Two inputs, assumed compositions.
  a <- as_composition(x)
  b <- as_composition(y)
  if (is.null(rownames(a)) || identical(rownames(a), as.character(seq_len(nrow(a))))) {
    rownames(a) <- paste0("a", if (nrow(a) == 1L) "" else seq_len(nrow(a)))
  }
  if (is.null(rownames(b)) || identical(rownames(b), as.character(seq_len(nrow(b))))) {
    rownames(b) <- paste0("b", if (nrow(b) == 1L) "" else seq_len(nrow(b)))
  }
  # Zero-pad to common width.
  k <- max(ncol(a), ncol(b))
  a <- pad_zeros(a, k)
  b <- pad_zeros(b, k)
  diversity_profile(rbind(a, b), q = q)
}

pad_zeros <- function(mat, k) {
  if (ncol(mat) == k) return(mat)
  out <- cbind(mat, matrix(0, nrow(mat), k - ncol(mat)))
  rownames(out) <- rownames(mat)
  out
}

stack_profiles <- function(a, b) {
  if (!isTRUE(all.equal(attr(a, "q"), attr(b, "q")))) {
    stop("stack_profiles(): `x` and `y` profiles use different q grids.",
         call. = FALSE)
  }
  wide <- rbind(attr(a, "wide"), attr(b, "wide"))
  ids  <- c(attr(a, "ids"), attr(b, "ids"))
  long <- data.frame(
    id = rep(ids, each = length(attr(a, "q"))),
    q  = rep(attr(a, "q"), times = length(ids)),
    D  = as.numeric(t(wide)),
    stringsAsFactors = FALSE
  )
  structure(long,
    class = c("diversity_profile", "data.frame"),
    q = attr(a, "q"),
    anchors = attr(a, "anchors"),
    ids = ids,
    n_parties = c(attr(a, "n_parties"), attr(b, "n_parties")),
    wide = wide
  )
}

# Detectors --------------------------------------------------------------------

find_crossings_interp <- function(pa, pb, q_vec, tol = 1e-12) {
  d <- pa - pb
  # Treat tiny magnitudes as zero to avoid phantom crossings.
  d[abs(d) < tol] <- 0
  out <- numeric(0)
  for (k in seq_len(length(d) - 1L)) {
    if (d[k] * d[k + 1L] < 0) {
      frac <- abs(d[k]) / (abs(d[k]) + abs(d[k + 1L]))
      out <- c(out, q_vec[k] + frac * (q_vec[k + 1L] - q_vec[k]))
    } else if (d[k] == 0 && d[k + 1L] != 0 && k > 1L && d[k - 1L] != 0 &&
               sign(d[k - 1L]) != sign(d[k + 1L])) {
      out <- c(out, q_vec[k])
    }
  }
  out
}

find_crossings_signchange <- function(pa, pb, q_vec, tol = 1e-12) {
  d <- pa - pb
  nz <- abs(d) > tol
  if (sum(nz) < 2L) return(numeric(0))
  s <- sign(d[nz])
  q_nz <- q_vec[nz]
  changes <- which(diff(s) != 0)
  if (!length(changes)) return(numeric(0))
  # Report midpoints of the adjacent non-zero q's: conservative without interp.
  (q_nz[changes] + q_nz[changes + 1L]) / 2
}

#' @export
as.data.frame.crossings <- function(x, ...) x$pairs
