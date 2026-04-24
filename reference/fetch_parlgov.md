# Fetch ParlGov election-results view

Downloads and caches the ParlGov `view_election` CSV. Subsequent calls
return the cached copy unless `refresh = TRUE`. Network access is
required on the first call; `curl` is a soft dependency.

## Usage

``` r
fetch_parlgov(
  refresh = FALSE,
  cache_dir = tools::R_user_dir("partyscape", "cache"),
  url = "https://parlgov.fly.dev/data-csv/view_election/"
)
```

## Arguments

- refresh:

  logical; if `TRUE`, re-downloads even when a cache exists.

- cache_dir:

  directory for the cached CSV. Defaults to
  `tools::R_user_dir("partyscape", "cache")`.

- url:

  source URL. Defaults to the live ParlGov endpoint.

## Value

A data.frame of ParlGov rows (country, date, type, party, seats,
vote_share, votes, election_id, party_id, ...).

## References

Döring, H., & Manow, P. (2024). *ParlGov: Parliaments and governments
database.* Harvard Dataverse. DOI:
[doi:10.7910/DVN/2VZ5ZC](https://doi.org/10.7910/DVN/2VZ5ZC) .
