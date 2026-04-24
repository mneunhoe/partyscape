# Changelog

## partyscape 0.1.0

First release. Implements the three analytical tools from the
accompanying paper:

- Diversity profiles via
  [`diversity_profile()`](https://mneunhoe.github.io/partyscape/reference/diversity_profile.md)
  /
  [`evenness_profile()`](https://mneunhoe.github.io/partyscape/reference/evenness_profile.md)
  /
  [`hill_number()`](https://mneunhoe.github.io/partyscape/reference/hill_number.md).
- Profile crossings via
  [`crossings()`](https://mneunhoe.github.io/partyscape/reference/crossings.md)
  (both linear-interpolation and sign-change detectors).
- Multiplicative beta diversity via
  [`alpha_beta_gamma()`](https://mneunhoe.github.io/partyscape/reference/alpha_beta_gamma.md)
  /
  [`collapse_to_elections()`](https://mneunhoe.github.io/partyscape/reference/collapse_to_elections.md).

Also:

- Scalar summaries:
  [`hhi()`](https://mneunhoe.github.io/partyscape/reference/hhi.md),
  [`rae()`](https://mneunhoe.github.io/partyscape/reference/rae.md),
  [`enp()`](https://mneunhoe.github.io/partyscape/reference/enp.md)
  (alias
  [`effective_parties()`](https://mneunhoe.github.io/partyscape/reference/enp.md)),
  [`dominance_gap()`](https://mneunhoe.github.io/partyscape/reference/dominance_gap.md),
  [`top_two()`](https://mneunhoe.github.io/partyscape/reference/top_two.md).
- Null model:
  [`taagepera_allik_shares()`](https://mneunhoe.github.io/partyscape/reference/taagepera_allik_shares.md).
- ParlGov accessors:
  [`fetch_parlgov()`](https://mneunhoe.github.io/partyscape/reference/fetch_parlgov.md),
  [`parlgov_seat_shares()`](https://mneunhoe.github.io/partyscape/reference/parlgov_seat_shares.md).
- [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
  / [`plot()`](https://rdrr.io/r/graphics/plot.default.html) /
  [`print()`](https://rdrr.io/r/base/print.html) methods for each S3
  class.
