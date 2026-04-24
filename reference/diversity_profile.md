# Diversity profile

Computes the full diversity profile D(q) over a grid of q values for one
or many compositions. Returns an S3 object suitable for
[`ggplot2::autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html),
[`plot()`](https://rdrr.io/r/graphics/plot.default.html), and subset
extraction via `[`.

## Usage

``` r
diversity_profile(
  x,
  q = seq(0, 5, by = 0.05),
  anchors = c(0, 1, 2, 5, Inf),
  id = NULL
)
```

## Arguments

- x:

  numeric vector, matrix, or data.frame of non-negative shares. Multiple
  rows compute one profile per row.

- q:

  numeric vector of orders at which to evaluate D(q). Default is a fine
  grid `seq(0, 5, 0.05)`. `Inf` is allowed.

- anchors:

  numeric vector of "highlight" q values to store as anchors (useful for
  plotting). Default `c(0, 1, 2, 5, Inf)`.

- id:

  optional character vector of row labels.

## Value

An S3 `"diversity_profile"` object — a long data.frame with columns
`id`, `q`, `D`, plus attributes `q` (grid), `anchors`, `n_parties`, and
`wide` (the id-by-q matrix).

## Examples

``` r
# Party-labeled shares (order is party identity, not size).
germany_2009 <- c(CDU = 0.312, CSU = 0.072, SPD = 0.235,
                  FDP = 0.150, Gruene = 0.109, Linke = 0.122)
dp <- diversity_profile(germany_2009)
print(dp)
#> <diversity_profile: 1 composition over q grid [0, 5], 101 points>
#>   D(0)  D(1) D(2)  D(5)
#> 1    6 5.344 4.83 4.029
plot(dp)
```
