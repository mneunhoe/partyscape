# Alpha, beta, and gamma diversity (Jost 2007)

Multiplicative decomposition of Hill-number diversity across rows of a
composition matrix. Alpha is the generalized mean of order `(1 - q)` of
per-row Hill numbers (Jost 2007, Eqs. 11a–11b), gamma is the Hill number
of the (possibly weighted) pooled composition, and beta is
`gamma / alpha`. beta is bounded in \[1, T\] and reads as the "effective
number of structurally distinct compositions" across the T rows.
Vectorized over `q`: one call returns a full beta profile.

## Usage

``` r
alpha_beta_gamma(
  mat,
  q = c(0, 1, 2, 5),
  w = NULL,
  years = NULL,
  collapse = !is.null(years)
)
```

## Arguments

- mat:

  numeric matrix of non-negative shares (rows = time points / systems;
  cols = parties). Accepts anything
  [`as_composition()`](https://mneunhoe.github.io/partyscape/reference/as_composition.md)
  accepts.

- q:

  numeric vector of orders. Default `c(0, 1, 2, 5)`.

- w:

  optional weights (numeric, `length = T`, summing to 1). If `NULL`,
  equal weights are used — or term lengths when `collapse = TRUE` and
  `years` are supplied.

- years:

  optional integer vector of election years aligned with `mat`. Enables
  collapsing identical consecutive rows.

- collapse:

  logical; defaults to `!is.null(years)`.

## Value

S3 `"beta_diversity"` object — data.frame with columns `q`, `alpha`,
`beta`, `gamma`, `T`. Attributes carry weights and collapse info.

## Details

When `years` are supplied (and `collapse = TRUE`), consecutive identical
rows are collapsed via
[`collapse_to_elections()`](https://mneunhoe.github.io/partyscape/reference/collapse_to_elections.md)
so each unique composition is counted once; weights default to term
lengths so long-lived elections do not dominate.

## Examples

``` r
# Three German Bundestag elections. Columns are stable party slots;
# SPD and CDU/CSU swap positions as the largest party between 2002
# (SPD) and 2005/2009 (CDU/CSU). Sorting the rows would hide this
# identity shift — the whole point of party-labeled data.
germany <- rbind(
  `2002` = c(CDU = 0.315, CSU = 0.096, SPD = 0.416,
             FDP = 0.078, Gruene = 0.091, Linke = 0.003),
  `2005` = c(CDU = 0.293, CSU = 0.075, SPD = 0.362,
             FDP = 0.099, Gruene = 0.083, Linke = 0.088),
  `2009` = c(CDU = 0.312, CSU = 0.072, SPD = 0.235,
             FDP = 0.150, Gruene = 0.109, Linke = 0.122)
)
alpha_beta_gamma(germany, q = c(0, 1, 2, 5))
#> Warning: as_composition(): renormalizing rows so each sums to 1 (max deviation was 0.001).
#> <beta_diversity: T = 3 rows, 4 q points>
#>  q    alpha     beta    gamma T
#>  0 6.000000 1.000000 6.000000 3
#>  1 4.689208 1.040449 4.878880 3
#>  2 3.997689 1.039583 4.155931 3
#>  5 3.221741 1.067642 3.439665 3
```
