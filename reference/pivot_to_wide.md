# Pivot long-format shares to a wide composition matrix

Convenience reshape for long tables such as those produced by ParlGov.
Rows are identified by `id`, columns by `party`, values by `share`.
Missing `(id, party)` pairs become zero.

## Usage

``` r
pivot_to_wide(data, id, party, share, fill = 0)
```

## Arguments

- data:

  data.frame in long form.

- id:

  name of the column that identifies the system (country-year etc.).

- party:

  name of the party/column factor.

- share:

  name of the numeric share column.

- fill:

  value used for missing pairs. Default `0`.

## Value

A wide numeric matrix (`id` in rows, `party` in columns).
