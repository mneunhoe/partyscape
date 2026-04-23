## Internal helpers. Not exported.

# Fast sanity test for numeric vectors.
is_numeric_vec <- function(x) is.numeric(x) && !is.matrix(x) && !is.data.frame(x)

# Format a row label for a single composition. If id is NULL and x has a
# name attribute, use that; otherwise fall back to the supplied default.
resolve_id <- function(x, id, default = "composition") {
  if (!is.null(id)) return(as.character(id))
  nm <- names(x)
  if (!is.null(nm) && length(nm) == 1L && nzchar(nm)) return(nm)
  default
}

# Row-wise apply with a fixed-type output matrix. Used for profile matrices.
row_apply_matrix <- function(mat, fun, ncols, ...) {
  out <- matrix(NA_real_, nrow = nrow(mat), ncol = ncols)
  for (i in seq_len(nrow(mat))) out[i, ] <- fun(mat[i, ], ...)
  out
}
