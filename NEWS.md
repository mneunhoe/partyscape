# partyscape 0.1.0

First release. Implements the three analytical tools from the accompanying
paper:

- Diversity profiles via `diversity_profile()` / `evenness_profile()` /
  `hill_number()`.
- Profile crossings via `crossings()` (both linear-interpolation and
  sign-change detectors).
- Multiplicative beta diversity via `alpha_beta_gamma()` /
  `collapse_to_elections()`.

Also:

- Scalar summaries: `hhi()`, `rae()`, `enp()` (alias `effective_parties()`),
  `dominance_gap()`, `top_two()`.
- Null model: `taagepera_allik_shares()`.
- ParlGov accessors: `fetch_parlgov()`, `parlgov_seat_shares()`.
- `autoplot()` / `plot()` / `print()` methods for each S3 class.
