#' ggplot2 autoplot methods for partyscape S3 classes
#'
#' Each returns a `ggplot` object the caller can extend. Thin `plot.*`
#' wrappers print the result.
#'
#' @name partyscape-autoplot
NULL

#' partyscape palette
#'
#' A small qualitative palette used by the autoplot methods.
#' @param n number of colours to return (recycled if n > length of palette).
#' @return character vector of hex codes.
#' @export
partyscape_palette <- function(n = 8L) {
  pal <- c("#1b9e77", "#d95f02", "#7570b3", "#e7298a",
           "#66a61e", "#e6ab02", "#a6761d", "#666666")
  rep_len(pal, n)
}

# Internal: common theme + anchor styling for profile-style plots.
gg_profile_base <- function() {
  ggplot2::theme_bw(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      legend.position  = "right"
    )
}

#' @rdname partyscape-autoplot
#' @param object a [diversity_profile] object.
#' @param show_anchors logical; mark anchor-q points with filled dots.
#' @param ... ignored.
#' @export
#' @importFrom ggplot2 autoplot
autoplot.diversity_profile <- function(object, show_anchors = TRUE, ...) {
  q_vec <- attr(object, "q")
  has_inf <- any(is.infinite(q_vec))
  df <- as.data.frame(unclass(object), stringsAsFactors = FALSE)
  # Replace q = Inf with a finite stand-in for plotting; annotate below.
  q_max_fin <- if (has_inf) max(q_vec[is.finite(q_vec)]) * 1.1 else NA_real_
  if (has_inf) df$q[is.infinite(df$q)] <- q_max_fin

  p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$q, y = .data$D,
                                        colour = .data$id, group = .data$id)) +
    ggplot2::geom_line(linewidth = 0.7) +
    ggplot2::scale_colour_manual(values = partyscape_palette(
      length(unique(df$id)))) +
    ggplot2::labs(x = "order q", y = "D(q): Hill number",
                  colour = NULL) +
    gg_profile_base()

  if (show_anchors) {
    anchors <- attr(object, "anchors")
    anchors_finite <- anchors[is.finite(anchors)]
    anchor_df <- df[df$q %in% anchors_finite, , drop = FALSE]
    if (has_inf && Inf %in% anchors) {
      anchor_df <- rbind(
        anchor_df,
        df[df$q == q_max_fin, , drop = FALSE]
      )
    }
    if (nrow(anchor_df)) {
      p <- p + ggplot2::geom_point(data = anchor_df, size = 1.8)
    }
  }

  if (has_inf) {
    p <- p + ggplot2::annotate(
      "text", x = q_max_fin, y = Inf, vjust = 1.4, hjust = 1,
      label = "q = Inf", size = 3, colour = "grey40"
    )
  }
  p
}

#' @rdname partyscape-autoplot
#' @param object an [evenness_profile] object.
#' @export
autoplot.evenness_profile <- function(object, ...) {
  df <- as.data.frame(unclass(object), stringsAsFactors = FALSE)
  ggplot2::ggplot(df, ggplot2::aes(x = .data$q, y = .data$E,
                                   colour = .data$id, group = .data$id)) +
    ggplot2::geom_line(linewidth = 0.7) +
    ggplot2::scale_colour_manual(values = partyscape_palette(
      length(unique(df$id)))) +
    ggplot2::labs(x = "order q", y = "E(q) = D(q) / D(0)",
                  colour = NULL) +
    gg_profile_base()
}

#' @rdname partyscape-autoplot
#' @param object a [crossings] object.
#' @param pair optional integer or character key; when supplied, restricts
#'   the plot to a single pair (otherwise all pairs' profiles are drawn).
#' @export
autoplot.crossings <- function(object, pair = NULL, ...) {
  prof <- object$profiles
  p <- autoplot(prof, show_anchors = FALSE)

  # Vertical rules at each q*.
  locs <- object$locations
  if (!is.null(pair)) {
    key <- if (is.numeric(pair)) names(locs)[pair] else pair
    locs <- locs[key]
  }
  all_q <- unlist(locs, use.names = FALSE)
  if (length(all_q)) {
    p <- p + ggplot2::geom_vline(xintercept = all_q,
                                 linetype = "dashed", colour = "grey40",
                                 linewidth = 0.3)
  }
  p + ggplot2::labs(subtitle = sprintf(
    "%d pair%s, %d crossing%s",
    nrow(object$pairs),
    if (nrow(object$pairs) == 1L) "" else "s",
    sum(object$pairs$n_crossings),
    if (sum(object$pairs$n_crossings) == 1L) "" else "s"
  ))
}

#' @rdname partyscape-autoplot
#' @param object a `beta_diversity` object (see [alpha_beta_gamma()]).
#' @export
autoplot.beta_diversity <- function(object, ...) {
  df <- as.data.frame(unclass(object), stringsAsFactors = FALSE)
  use_line <- nrow(df) > 6L

  base <- ggplot2::ggplot(df, ggplot2::aes(x = .data$q, y = .data$beta))
  geom <- if (use_line) {
    ggplot2::geom_line(linewidth = 0.7, colour = partyscape_palette(1))
  } else {
    ggplot2::geom_col(fill = partyscape_palette(1), width = 0.6)
  }

  base + geom +
    ggplot2::geom_hline(yintercept = 1, linetype = "dashed",
                        colour = "grey40") +
    ggplot2::labs(x = "order q",
                  y = expression(beta[q] == gamma[q] / alpha[q])) +
    gg_profile_base()
}
