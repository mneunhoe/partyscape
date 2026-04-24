# Evenness profile

Evenness E(q) = D(q) / D(0), the diversity profile rescaled to lie on
\[0, 1\]. At q = 0 evenness equals 1 by construction; it decreases
(weakly) in q for any non-uniform composition.

## Usage

``` r
evenness_profile(
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

An S3 `"evenness_profile"` object (data.frame with columns `id`, `q`,
`E`).
