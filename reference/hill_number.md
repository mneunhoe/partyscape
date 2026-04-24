# Hill number of order q

Computes the Hill number (true diversity) of order `q` for a single
composition vector. Handles the limiting cases `q = 0` (richness),
`q = 1` (exponential of Shannon entropy), and `q = Inf` (`1 / max(p)`)
explicitly. Vectorized over `q`: pass a vector and get back a vector.

## Usage

``` r
hill_number(p, q)
```

## Arguments

- p:

  numeric vector of non-negative weights summing to (roughly) 1. Zeros
  are allowed and ignored.

- q:

  non-negative numeric scalar or vector, the order. `q = Inf` is
  allowed.

## Value

Numeric scalar (if `length(q) == 1`) or numeric vector with `length(q)`
entries.

## See also

[`diversity_profile()`](https://mneunhoe.github.io/partyscape/reference/diversity_profile.md),
[`enp()`](https://mneunhoe.github.io/partyscape/reference/enp.md),
[`hhi()`](https://mneunhoe.github.io/partyscape/reference/hhi.md).

## Examples

``` r
# Party-labeled composition — column order carries party identity,
# NOT rank. The largest party is whichever entry is largest.
germany_2009 <- c(CDU = 0.312, CSU = 0.072, SPD = 0.235,
                  FDP = 0.150, Gruene = 0.109, Linke = 0.122)
hill_number(germany_2009, 0)      # 6 nonzero parties
#> [1] 6
hill_number(germany_2009, 1)      # exp(Shannon)
#> [1] 5.343992
hill_number(germany_2009, 2)      # ENP = 1 / sum(p^2)
#> [1] 4.830498
hill_number(germany_2009, Inf)    # 1 / max(p)
#> [1] 3.205128
hill_number(germany_2009, c(0, 1, 2, Inf))
#> [1] 6.000000 5.343992 4.830498 3.205128
```
