# Diversity-profile crossings

Detects q values at which two diversity profiles D_a(q) and D_b(q)
change order — the central notion of "structural incomparability" in the
paper. Two detection strategies are available.

## Usage

``` r
crossings(
  x,
  y = NULL,
  q = seq(0, 5, by = 0.05),
  method = c("interp", "signchange"),
  tol = 1e-12
)
```

## Arguments

- x:

  one of:

  - a numeric vector (requires non-null `y`),

  - a numeric matrix with rows = systems,

  - a
    [diversity_profile](https://mneunhoe.github.io/partyscape/reference/diversity_profile.md)
    object.

- y:

  optional second composition or profile. If supplied and `x` is a
  single composition / profile, a single pair is scored. Ignored when
  `x` is itself multi-row.

- q:

  grid of q values at which to evaluate profiles (when `x`/`y` are
  compositions rather than profiles). Default `seq(0, 5, 0.05)`.

- method:

  one of `"interp"` or `"signchange"`.

- tol:

  numeric tolerance for equality to zero.

## Value

S3 `"crossings"` list with elements:

- `pairs` — data.frame with columns `i`, `j`, `id_i`, `id_j`,
  `n_crossings`, `first_q`.

- `locations` — named list of numeric q\* vectors, one per pair.

- `profiles` — the underlying
  [diversity_profile](https://mneunhoe.github.io/partyscape/reference/diversity_profile.md)
  (for plotting).

## Details

- `"interp"`: linear interpolation between grid points where
  `D_a(q) - D_b(q)` changes sign. Precise crossing location; sensitive
  to noise in the grid.

- `"signchange"`: count sign changes of the non-zero difference
  sequence. Cheap and robust; reports the first crossing's grid location
  rather than an interpolated value.

## Examples

``` r
# Two party systems with similar ENP but different profile shapes —
# party-labeled vectors, NOT sorted by size.
netherlands_1982 <- c(
  PvdA = 0.313, CDA = 0.300, VVD = 0.240, D66 = 0.040,
  PSP = 0.020, CPN = 0.020, SGP = 0.020, PPR  = 0.013,
  RPF = 0.013, GPV = 0.007, CP  = 0.007, DS70 = 0.007
)
sweden_2002 <- c(
  SAP = 0.415, Moderata = 0.156, Folkpartiet = 0.138,
  Kristdemokraterna = 0.096, Vansterpartiet = 0.086,
  Centerpartiet = 0.063, Miljopartiet = 0.046
)
crossings(netherlands_1982, sweden_2002)
#> <crossings: 1 pair, method = interp>
#>  i j id_i id_j n_crossings   first_q
#>  1 2    a    b           2 0.8768636
```
