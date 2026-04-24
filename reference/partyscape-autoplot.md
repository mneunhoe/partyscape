# ggplot2 autoplot methods for partyscape S3 classes

Each returns a `ggplot` object the caller can extend. Thin `plot.*`
wrappers print the result.

## Usage

``` r
# S3 method for class 'diversity_profile'
autoplot(object, show_anchors = TRUE, ...)

# S3 method for class 'evenness_profile'
autoplot(object, ...)

# S3 method for class 'crossings'
autoplot(object, pair = NULL, ...)

# S3 method for class 'beta_diversity'
autoplot(object, ...)
```

## Arguments

- object:

  a `beta_diversity` object (see
  [`alpha_beta_gamma()`](https://mneunhoe.github.io/partyscape/reference/alpha_beta_gamma.md)).

- show_anchors:

  logical; mark anchor-q points with filled dots.

- ...:

  ignored.

- pair:

  optional integer or character key; when supplied, restricts the plot
  to a single pair (otherwise all pairs' profiles are drawn).
