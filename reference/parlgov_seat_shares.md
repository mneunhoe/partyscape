# Reshape ParlGov output to a seat-share matrix

Takes the long ParlGov `view_election` output and pivots it to a wide
matrix (one row per country-year election, one column per party) of seat
shares in \[0, 1\]. Handy as direct input to
[`diversity_profile()`](https://mneunhoe.github.io/partyscape/reference/diversity_profile.md)
or
[`alpha_beta_gamma()`](https://mneunhoe.github.io/partyscape/reference/alpha_beta_gamma.md).

## Usage

``` r
parlgov_seat_shares(
  parlgov,
  countries = NULL,
  years = NULL,
  type = "parliament",
  min_share = 0
)
```

## Arguments

- parlgov:

  data.frame returned by
  [`fetch_parlgov()`](https://mneunhoe.github.io/partyscape/reference/fetch_parlgov.md).

- countries:

  optional character vector of country names to keep.

- years:

  optional integer vector; if supplied, only elections whose year lies
  in the vector are kept.

- type:

  election type to keep. Default `"parliament"`.

- min_share:

  drop parties whose share is below this threshold (keeps a sensible
  column count). Default `0` (keep all).

## Value

A numeric matrix (rows = `country_year`, cols = party names). Attributes
`country` and `year` are attached for convenience.
