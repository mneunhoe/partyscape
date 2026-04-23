#' @export
print.diversity_profile <- function(x, ...) {
  ids <- attr(x, "ids")
  q   <- attr(x, "q")
  cat(sprintf("<diversity_profile: %d composition%s over q grid [%g, %g], %d points>\n",
              length(ids), if (length(ids) == 1L) "" else "s",
              min(q), max(q[is.finite(q)], na.rm = TRUE), length(q)))
  wide <- attr(x, "wide")
  # Summarize at anchor q's present in the grid.
  anchors <- attr(x, "anchors")
  in_grid <- anchors[anchors %in% q |
                     (is.infinite(anchors) & any(is.infinite(q)))]
  if (length(in_grid)) {
    show <- wide[, match(in_grid, q), drop = FALSE]
    colnames(show) <- paste0("D(", format(in_grid), ")")
    print(round(show, 3))
  }
  invisible(x)
}

#' @export
print.evenness_profile <- function(x, ...) {
  ids <- attr(x, "ids")
  q   <- attr(x, "q")
  cat(sprintf("<evenness_profile: %d composition%s, %d q points>\n",
              length(ids), if (length(ids) == 1L) "" else "s", length(q)))
  wide <- attr(x, "wide")
  anchors <- attr(x, "anchors")
  in_grid <- anchors[anchors %in% q |
                     (is.infinite(anchors) & any(is.infinite(q)))]
  if (length(in_grid)) {
    show <- wide[, match(in_grid, q), drop = FALSE]
    colnames(show) <- paste0("E(", format(in_grid), ")")
    print(round(show, 3))
  }
  invisible(x)
}

#' @export
print.crossings <- function(x, ...) {
  method <- attr(x, "method")
  cat(sprintf("<crossings: %d pair%s, method = %s>\n",
              nrow(x$pairs),
              if (nrow(x$pairs) == 1L) "" else "s",
              method))
  print(x$pairs, row.names = FALSE)
  invisible(x)
}

#' @export
print.beta_diversity <- function(x, ...) {
  Tn <- attr(x, "T")
  cat(sprintf("<beta_diversity: T = %d rows, %d q points>\n",
              Tn, nrow(x)))
  print(as.data.frame(unclass(x), stringsAsFactors = FALSE),
        row.names = FALSE)
  invisible(x)
}
