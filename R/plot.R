#' Plot a diversity_profile
#'
#' Thin wrapper around [autoplot.diversity_profile()] that prints the
#' resulting ggplot. Returns the ggplot invisibly for further composition.
#' @param x a `diversity_profile` object.
#' @param ... forwarded to [autoplot.diversity_profile()].
#' @export
plot.diversity_profile <- function(x, ...) {
  g <- autoplot(x, ...)
  print(g)
  invisible(g)
}

#' Plot an evenness_profile
#' @inheritParams plot.diversity_profile
#' @param x an `evenness_profile` object.
#' @export
plot.evenness_profile <- function(x, ...) {
  g <- autoplot(x, ...)
  print(g)
  invisible(g)
}

#' Plot a crossings object
#' @inheritParams plot.diversity_profile
#' @param x a `crossings` object.
#' @export
plot.crossings <- function(x, ...) {
  g <- autoplot(x, ...)
  print(g)
  invisible(g)
}

#' Plot a beta_diversity object
#' @inheritParams plot.diversity_profile
#' @param x a `beta_diversity` object.
#' @export
plot.beta_diversity <- function(x, ...) {
  g <- autoplot(x, ...)
  print(g)
  invisible(g)
}
