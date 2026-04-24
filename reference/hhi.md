# Herfindahl–Hirschman index

`hhi(p) = sum(p^2)`. Equals 1 when one party takes everything and `1/k`
for k equal shares. Complement of
[`rae()`](https://mneunhoe.github.io/partyscape/reference/rae.md).

## Usage

``` r
hhi(p)
```

## Arguments

- p:

  numeric vector / matrix / data.frame of shares.

## Value

numeric scalar or vector (one value per row).
