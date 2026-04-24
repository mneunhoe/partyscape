# Collapse consecutive identical compositions

Between elections the seat-share vector repeats across country-years;
using annual rows would implicitly weight each election by its term
length. This helper keeps only rows that differ from the previous row,
and returns the term length (in years) of each unique election.

## Usage

``` r
collapse_to_elections(mat, years)
```

## Arguments

- mat:

  numeric matrix of compositions.

- years:

  integer vector of years, aligned with rows of `mat`.

## Value

A list with elements `mat` (collapsed matrix), `term_length` (years each
kept row spans), and `start_year`.
