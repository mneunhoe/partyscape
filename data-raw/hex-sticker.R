# ------------------------------------------------------------------
# partyscape hex sticker  (v5 — larger, better-centered text)
# ------------------------------------------------------------------

# install.packages("ggplot2")
library(ggplot2)

# ---- palette ------------------------------------------------------
sky        <- "#f4d5b0"
cream      <- "#f4d5b0"
ridge      <- "#7a9c95"
ridge_back <- "#a0b8b1"
ground     <- "#1a4550"
border     <- "#081820"
teal       <- "#2c5f6b"
red        <- "#a84848"
gold       <- "#c89248"
grn        <- "#4a7858"
pur        <- "#6d4a78"

flip <- function(y) 600 - y

# ---- hex outline --------------------------------------------------
hex_df <- data.frame(
  x = c(260, 509, 509, 260,  11,  11),
  y = flip(c(12, 156, 444, 588, 444, 156))
)
hex_border_df <- rbind(hex_df, hex_df[1, ])

# ---- hemicycle sun ------------------------------------------------
shares <- c(0.35, 0.25, 0.18, 0.12, 0.10)
cols   <- c(teal, red, gold, grn, pur)
starts <- pi - c(0, cumsum(head(shares, -1))) * pi
ends   <- pi - cumsum(shares) * pi

make_wedge <- function(x0, y0, r, start, end, fill, id, n = 40) {
  theta <- seq(start, end, length.out = n)
  data.frame(
    x    = c(x0, x0 + r * cos(theta)),
    y    = c(y0, y0 + r * sin(theta)),
    fill = fill, id = id
  )
}
wedges <- do.call(rbind, Map(make_wedge,
                             x0 = 380, y0 = flip(200), r = 40,
                             start = starts, end = ends, fill = cols, id = seq_along(cols)
))

# ---- Bezier helper ------------------------------------------------
bez <- function(t, p)
  (1 - t)^3 * p[1] + 3 * (1 - t)^2 * t * p[2] +
  3 * (1 - t) * t^2 * p[3] + t^3 * p[4]
tt <- seq(0, 1, length.out = 200)

# ---- back and front ridges ----------------------------------------
back_ridge_poly <- data.frame(
  x = c(bez(tt, c(11,  60, 220, 509)), 509, 11),
  y = c(flip(bez(tt, c(180, 300, 420, 425))), flip(440), flip(440))
)
front_ridge_poly <- data.frame(
  x = c(bez(tt, c(11, 135, 327, 509)), 509, 11),
  y = c(flip(bez(tt, c(290, 370, 420, 430))), flip(440), flip(440))
)

# ---- ground polygon following hex bottom outline -----------------
ground_poly <- data.frame(
  x = c( 11, 509, 509, 260,  11),
  y = flip(c(440, 440, 444, 588, 444))
)

# ---- buildings ----------------------------------------------------
buildings <- data.frame(
  xmin    = c( 65, 150, 235, 320, 405),
  xmax    = c(115, 200, 285, 370, 455),
  top_svg = c(389, 347, 260, 311, 378),
  fill    = c(pur, gold, teal, red, grn)
)
buildings$ymin <- flip(440)
buildings$ymax <- flip(buildings$top_svg)

# ---- windows ------------------------------------------------------
make_windows <- function(xmin, xmax, top_svg,
                         inset = 10, win_w = 5, win_h = 7,
                         top_m = 9, bot_m = 15, spacing = 20) {
  rows_y <- seq(top_svg + top_m, 440 - bot_m, by = spacing)
  cols_x <- c(xmin + inset, xmax - inset - win_w)
  g <- expand.grid(x = cols_x, y = rows_y)
  data.frame(
    xmin = g$x, xmax = g$x + win_w,
    ymin = flip(g$y + win_h), ymax = flip(g$y)
  )
}
wins <- do.call(rbind, lapply(seq_len(nrow(buildings)), function(i)
  make_windows(buildings$xmin[i], buildings$xmax[i], buildings$top_svg[i])
))

# ---- dome ---------------------------------------------------------
th   <- seq(0, pi, length.out = 60)
dome <- data.frame(
  x = 260 + 25 * cos(th),
  y = flip(260 - 25 * sin(th))
)

# ---- package-name position & size ---------------------------------
# The dark ground is a pentagon: a thin rectangular band from SVG y=440
# to y=444, then tapering to a point at (260, 588). Its visual centroid
# sits around SVG y=495 — slightly higher than the geometric center
# (y=514) because the polygon is wider at the top than at the bottom.
name_x    <- 260    # hex horizontal center
name_y    <- 495    # visual centroid of dark region (SVG coords)
name_size <- 22     # ggplot "mm" units; raise for more prominence

# ---- assemble the plot --------------------------------------------
p <- ggplot() +
  geom_polygon(data = hex_df, aes(x, y), fill = sky, color = NA) +
  geom_polygon(data = wedges,
               aes(x = x, y = y, group = id, fill = fill), color = NA) +
  geom_polygon(data = back_ridge_poly,  aes(x, y), fill = ridge_back) +
  geom_polygon(data = front_ridge_poly, aes(x, y), fill = ridge) +
  geom_polygon(data = ground_poly, aes(x, y), fill = ground) +
  geom_rect(data = buildings,
            aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax,
                fill = fill),
            color = NA) +
  geom_polygon(data = dome, aes(x, y), fill = teal) +
  geom_rect(data = wins,
            aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            fill = cream) +
  annotate("text",
           x = name_x, y = flip(name_y),
           label = "partyscape",
           color = cream, size = name_size,
           family = "sans", fontface = "plain",
           hjust = 0.5, vjust = 0.5) +
  geom_path(data = hex_border_df, aes(x, y),
            color = border, linewidth = 1.6,
            lineend = "round", linejoin = "round") +
  scale_fill_identity() +
  coord_fixed(xlim = c(0, 520), ylim = c(0, 600), expand = FALSE) +
  theme_void() +
  theme(panel.background = element_rect(fill = "transparent", color = NA),
        plot.background  = element_rect(fill = "transparent", color = NA),
        plot.margin      = margin(0, 0, 0, 0))

# ---- save as transparent PNG --------------------------------------
ggsave("logo.png", p,
       width = 43.9, height = 50.8, units = "mm",
       dpi = 600, bg = "transparent")