
<!-- README.md is generated from README.Rmd. Please edit that file. -->

# partyscape <img src="man/figures/logo.png" align="right" height="138" alt="partyscape hex logo" />

Diversity profiles, profile crossings, and beta diversity for
party-system research. Implements the three analytical tools proposed in
“Diversity Profiles for Party Systems” (Neunhoeffer, Under Review).

## Installation

``` r
# install.packages("remotes")
remotes::install_github("mneunhoe/partyscape")
```

## A 20-line tour

All examples below work on **party-labeled** compositions — columns
carry party identity, never rank. The paper’s central point is that
sorting shares by size (so “column 1 = largest party that year”)
discards the information `alpha_beta_gamma()` is designed to detect, so
the package encourages you to keep party identity intact.

``` r
library(partyscape)

# Germany 2009 Bundestag — columns named by party, not sorted by size.
germany_2009 <- c(
  CDU   = 0.312, CSU   = 0.072, SPD   = 0.235,
  FDP   = 0.150, Gruene = 0.109, Linke = 0.122
)

# UK 1997 Commons — a different party set, also named (not sorted).
uk_1997 <- c(
  Labour       = 0.634, Conservative = 0.250, LibDem   = 0.070,
  UUP          = 0.015, SNP          = 0.009, PlaidCymru = 0.006,
  SDLP         = 0.005, DUP          = 0.003, SinnFein = 0.003,
  Independent  = 0.005
)

# 1. Diversity profile: a steep UK curve vs. a flat German one.
diversity_profile(uk_1997)
#> <diversity_profile: 1 composition over q grid [0, 5], 101 points>
#>   D(0)  D(1)  D(2)  D(5)
#> 1   10 2.845 2.129 1.763
diversity_profile(germany_2009)
#> <diversity_profile: 1 composition over q grid [0, 5], 101 points>
#>   D(0)  D(1) D(2)  D(5)
#> 1    6 5.344 4.83 4.029

# 2. Profile crossings across two systems.
crossings(uk_1997, germany_2009, q = seq(0, 5, 0.01))
#> <crossings: 1 pair, method = interp>
#>  i j id_i id_j n_crossings   first_q
#>  1 2    a    b           1 0.3178071

# 3. Beta diversity across Germany's 2002-2005-2009 trajectory. Columns
# share the same party slots across rows so CDU/SPD swapping as the
# largest party between 2002 and 2005 is visible to the decomposition.
germany <- rbind(
  `2002` = c(CDU = 0.315, CSU = 0.096, SPD = 0.416,
             FDP = 0.078, Gruene = 0.091, Linke = 0.003),
  `2005` = c(CDU = 0.293, CSU = 0.075, SPD = 0.362,
             FDP = 0.099, Gruene = 0.083, Linke = 0.088),
  `2009` = c(CDU = 0.312, CSU = 0.072, SPD = 0.235,
             FDP = 0.150, Gruene = 0.109, Linke = 0.122)
)
alpha_beta_gamma(germany, q = c(0, 1, 2, 5),
                 years = c(2002, 2005, 2009))
#> Warning: as_composition(): renormalizing rows so each sums to 1 (max deviation
#> was 0.001).
#> <beta_diversity: T = 3 rows, 4 q points>
#>  q    alpha     beta    gamma T
#>  0 6.000000 1.000000 6.000000 3
#>  1 4.689208 1.040449 4.878880 3
#>  2 3.997689 1.039583 4.155931 3
#>  5 3.221741 1.067642 3.439665 3
```
