#' Coerce input to a composition matrix
#'
#' Internal helper that normalizes the three supported input shapes into a
#' numeric matrix of compositions (rows = systems, cols = parties), each row
#' summing to 1. Exported for power users who want the same validation
#' elsewhere in their own pipelines.
#'
#' - `numeric` vector: a single composition. Returned as a 1-row matrix.
#' - `matrix`: rows are systems, columns are parties. Rownames preserved as
#'   ids when available.
#' - `data.frame`: numeric columns are used; non-numeric columns are dropped
#'   with a message the first time. The `id` argument overrides rownames for
#'   row labels.
#'
#' Rows are rescaled to sum to 1 with a `warning()` when the original sum
#' deviates from 1 by more than `tol`. Rows that sum to zero or contain
#' negative entries raise an error (they are not compositions).
#'
#' @param x numeric vector, matrix, or data.frame of non-negative values.
#' @param id optional character vector of length `nrow` (after coercion) to
#'   label rows. If `NULL`, rownames / names on `x` are used.
#' @param tol tolerance for "already normalized". Default `1e-8`.
#'
#' @return A numeric matrix with `nrow(x)` rows and `ncol(x)` columns, each
#'   row summing to 1. `rownames()` carry the row labels.
#'
#' @export
as_composition <- function(x, id = NULL, tol = 1e-8) {
  if (is.data.frame(x)) {
    num <- vapply(x, is.numeric, logical(1))
    if (!any(num)) {
      stop("as_composition(): data.frame `x` has no numeric columns.",
           call. = FALSE)
    }
    if (!all(num)) {
      message("as_composition(): dropping non-numeric columns: ",
              paste(names(x)[!num], collapse = ", "))
    }
    row_ids <- if (!is.null(id)) id else rownames(x)
    x <- as.matrix(x[, num, drop = FALSE])
    if (!is.null(row_ids)) rownames(x) <- row_ids
  } else if (is.numeric(x) && !is.matrix(x)) {
    nm <- names(x)
    x <- matrix(x, nrow = 1L, dimnames = list(NULL, nm))
    if (!is.null(id)) rownames(x) <- as.character(id)
  } else if (is.matrix(x)) {
    if (!is.numeric(x)) {
      stop("as_composition(): matrix `x` must be numeric.", call. = FALSE)
    }
    if (!is.null(id)) rownames(x) <- as.character(id)
  } else {
    stop("as_composition(): `x` must be a numeric vector, matrix, or data.frame.",
         call. = FALSE)
  }

  if (any(!is.finite(x))) {
    stop("as_composition(): `x` contains NA/NaN/Inf values.", call. = FALSE)
  }
  if (any(x < 0)) {
    stop("as_composition(): `x` has negative entries; ",
         "compositions must be non-negative.", call. = FALSE)
  }

  row_sums <- rowSums(x)
  if (any(row_sums <= 0)) {
    bad <- which(row_sums <= 0)
    stop("as_composition(): row(s) ", paste(bad, collapse = ", "),
         " sum to zero; cannot normalize.", call. = FALSE)
  }
  if (any(abs(row_sums - 1) > tol)) {
    warning("as_composition(): renormalizing rows so each sums to 1 ",
            "(max deviation was ", signif(max(abs(row_sums - 1)), 3), ").",
            call. = FALSE)
    x <- x / row_sums
  }

  if (is.null(rownames(x))) {
    rownames(x) <- as.character(seq_len(nrow(x)))
  }
  x
}

#' Pivot long-format shares to a wide composition matrix
#'
#' Convenience reshape for long tables such as those produced by ParlGov.
#' Rows are identified by `id`, columns by `party`, values by `share`. Missing
#' `(id, party)` pairs become zero.
#'
#' @param data data.frame in long form.
#' @param id name of the column that identifies the system (country-year etc.).
#' @param party name of the party/column factor.
#' @param share name of the numeric share column.
#' @param fill value used for missing pairs. Default `0`.
#'
#' @return A wide numeric matrix (`id` in rows, `party` in columns).
#'
#' @export
pivot_to_wide <- function(data, id, party, share, fill = 0) {
  stopifnot(is.data.frame(data))
  for (col in c(id, party, share)) {
    if (!col %in% names(data)) {
      stop("pivot_to_wide(): column ", shQuote(col), " not found in `data`.",
           call. = FALSE)
    }
  }
  ids   <- as.character(data[[id]])
  parts <- as.character(data[[party]])
  vals  <- as.numeric(data[[share]])

  row_levels <- unique(ids)
  col_levels <- unique(parts)

  out <- matrix(fill, nrow = length(row_levels), ncol = length(col_levels),
                dimnames = list(row_levels, col_levels))
  out[cbind(match(ids, row_levels), match(parts, col_levels))] <- vals
  out
}
