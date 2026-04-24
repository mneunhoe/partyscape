# Taagepera–Allik expected seat shares

Recursive closed-form mean shares under the Taagepera–Allik null model
for a system of `n0` parties. Used as a reference composition when
benchmarking empirical profiles.

## Usage

``` r
taagepera_allik_shares(n0)
```

## Arguments

- n0:

  integer, number of parties (must be \>= 1).

## Value

numeric vector of length `n0`, sums to 1.

## References

Taagepera, R., & Allik, M. (2006). Seat share distribution of parties:
Models and empirical patterns. *Electoral Studies*, 25(4), 696–713.

## Examples

``` r
taagepera_allik_shares(4)
#> [1] 0.50000000 0.28867513 0.14942925 0.06189562
```
