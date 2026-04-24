# Coerce input to a composition matrix

Internal helper that normalizes the three supported input shapes into a
numeric matrix of compositions (rows = systems, cols = parties), each
row summing to 1. Exported for power users who want the same validation
elsewhere in their own pipelines.

## Usage

``` r
as_composition(x, id = NULL, tol = 1e-08)
```

## Arguments

- x:

  numeric vector, matrix, or data.frame of non-negative values.

- id:

  optional character vector of length `nrow` (after coercion) to label
  rows. If `NULL`, rownames / names on `x` are used.

- tol:

  tolerance for "already normalized". Default `1e-8`.

## Value

A numeric matrix with `nrow(x)` rows and `ncol(x)` columns, each row
summing to 1. [`rownames()`](https://rdrr.io/r/base/colnames.html) carry
the row labels.

## Details

- `numeric` vector: a single composition. Returned as a 1-row matrix.

- `matrix`: rows are systems, columns are parties. Rownames preserved as
  ids when available.

- `data.frame`: numeric columns are used; non-numeric columns are
  dropped with a message the first time. The `id` argument overrides
  rownames for row labels.

Rows are rescaled to sum to 1 with a
[`warning()`](https://rdrr.io/r/base/warning.html) when the original sum
deviates from 1 by more than `tol`. Rows that sum to zero or contain
negative entries raise an error (they are not compositions).
