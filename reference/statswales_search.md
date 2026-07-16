# Search published datasets

Full-text search across dataset titles and summaries. Returns results
ranked by relevance.

## Usage

``` r
statswales_search(
  keywords,
  lang = "en-gb",
  page_number = 1,
  page_size = 100,
  mode = "basic"
)
```

## Arguments

- keywords:

  Search query string.

- lang:

  Language for returned text. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

- page_number:

  Page number to return. Default `1`.

- page_size:

  Number of results per page. Default `100`.

- mode:

  Search algorithm. One of `"basic"` (default), `"basic_split"`,
  `"fts"`, `"fts_simple"`, or `"fuzzy"`. The `fts` and `fts_simple`
  modes return highlighted matches in `match_title` and `match_summary`
  columns.

## Value

A data frame with columns `id`, `title`, `summary`,
`first_published_at`, `last_updated_at`, and `archived_at`. Timestamp
columns are `POSIXct` (UTC). The `fts` and `fts_simple` modes also
return `rank`, `match_title`, and `match_summary`. Returns `NULL` if the
request fails.

## Examples

``` r
if (FALSE) { # \dontrun{
results <- statswales_search("hospital")
results_cy <- statswales_search("ysbyty", lang = "cy-gb")
results_fuzzy <- statswales_search("transprt", mode = "fuzzy")
} # }
```
