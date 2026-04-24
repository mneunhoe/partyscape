# Package index

## Diversity profiles

Hill numbers and full profiles D(q) / E(q) over a q grid.

- [`hill_number()`](https://mneunhoe.github.io/partyscape/reference/hill_number.md)
  : Hill number of order q
- [`diversity_profile()`](https://mneunhoe.github.io/partyscape/reference/diversity_profile.md)
  : Diversity profile
- [`evenness_profile()`](https://mneunhoe.github.io/partyscape/reference/evenness_profile.md)
  : Evenness profile
- [`` `[`( ``*`<diversity_profile>`*`)`](https://mneunhoe.github.io/partyscape/reference/sub-.diversity_profile.md)
  : Subset a diversity profile by id

## Profile crossings

Detect q values where two profiles change order.

- [`crossings()`](https://mneunhoe.github.io/partyscape/reference/crossings.md)
  : Diversity-profile crossings

## Alpha-beta-gamma decomposition

Multiplicative diversity decomposition (Jost 2007) over time.

- [`alpha_beta_gamma()`](https://mneunhoe.github.io/partyscape/reference/alpha_beta_gamma.md)
  : Alpha, beta, and gamma diversity (Jost 2007)
- [`collapse_to_elections()`](https://mneunhoe.github.io/partyscape/reference/collapse_to_elections.md)
  : Collapse consecutive identical compositions

## Scalar summaries

Classic concentration and fractionalization indices.

- [`enp()`](https://mneunhoe.github.io/partyscape/reference/enp.md)
  [`effective_parties()`](https://mneunhoe.github.io/partyscape/reference/enp.md)
  : Effective number of parties (Laakso–Taagepera)
- [`hhi()`](https://mneunhoe.github.io/partyscape/reference/hhi.md) :
  Herfindahl–Hirschman index
- [`rae()`](https://mneunhoe.github.io/partyscape/reference/rae.md) :
  Rae's fractionalization
- [`dominance_gap()`](https://mneunhoe.github.io/partyscape/reference/dominance_gap.md)
  : Dominance gap
- [`top_two()`](https://mneunhoe.github.io/partyscape/reference/top_two.md)
  : Top-two share

## Input coercion and reshaping

Get arbitrary inputs into a normalized composition matrix.

- [`as_composition()`](https://mneunhoe.github.io/partyscape/reference/as_composition.md)
  : Coerce input to a composition matrix
- [`pivot_to_wide()`](https://mneunhoe.github.io/partyscape/reference/pivot_to_wide.md)
  : Pivot long-format shares to a wide composition matrix
- [`taagepera_allik_shares()`](https://mneunhoe.github.io/partyscape/reference/taagepera_allik_shares.md)
  : Taagepera–Allik expected seat shares

## ParlGov data access

Fetch and reshape ParlGov election results.

- [`fetch_parlgov()`](https://mneunhoe.github.io/partyscape/reference/fetch_parlgov.md)
  : Fetch ParlGov election-results view
- [`parlgov_seat_shares()`](https://mneunhoe.github.io/partyscape/reference/parlgov_seat_shares.md)
  : Reshape ParlGov output to a seat-share matrix

## Plotting helpers

Palette and S3 autoplot/plot methods used to visualise results.

- [`partyscape_palette()`](https://mneunhoe.github.io/partyscape/reference/partyscape_palette.md)
  : partyscape palette
- [`autoplot(`*`<diversity_profile>`*`)`](https://mneunhoe.github.io/partyscape/reference/partyscape-autoplot.md)
  [`autoplot(`*`<evenness_profile>`*`)`](https://mneunhoe.github.io/partyscape/reference/partyscape-autoplot.md)
  [`autoplot(`*`<crossings>`*`)`](https://mneunhoe.github.io/partyscape/reference/partyscape-autoplot.md)
  [`autoplot(`*`<beta_diversity>`*`)`](https://mneunhoe.github.io/partyscape/reference/partyscape-autoplot.md)
  : ggplot2 autoplot methods for partyscape S3 classes
- [`plot(`*`<diversity_profile>`*`)`](https://mneunhoe.github.io/partyscape/reference/plot.diversity_profile.md)
  : Plot a diversity_profile
- [`plot(`*`<evenness_profile>`*`)`](https://mneunhoe.github.io/partyscape/reference/plot.evenness_profile.md)
  : Plot an evenness_profile
- [`plot(`*`<crossings>`*`)`](https://mneunhoe.github.io/partyscape/reference/plot.crossings.md)
  : Plot a crossings object
- [`plot(`*`<beta_diversity>`*`)`](https://mneunhoe.github.io/partyscape/reference/plot.beta_diversity.md)
  : Plot a beta_diversity object
