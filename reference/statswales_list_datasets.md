# List all published datasets

Returns a data frame of all published datasets available from the
[StatsWales public API](https://api.stats.gov.wales/v2). All pages are
fetched automatically, so the full catalogue is returned.

## Usage

``` r
statswales_list_datasets(lang = "en-gb")
```

## Arguments

- lang:

  Language for returned text. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

## Value

A data frame with columns `id`, `title`, `first_published_at`,
`last_updated_at`, and `archived_at`. Timestamp columns are `POSIXct`
(UTC). Returns `NULL` if the request fails.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
datasets_cy <- statswales_list_datasets(lang = "cy-gb")
} # }
```
