# Changelog

## statswalesr 1.0.0

CRAN release: 2026-07-12

- Migrated to StatsWales API v2 (`https://api.stats.gov.wales/v2`)
- Added a `sort_by` argument to
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md),
  [`statswales_get_pivot()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_pivot.md),
  and
  [`statswales_get_topic()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_topic.md).
  Accepts either a `"column:direction"` string or a named vector like
  `c(Year = "desc")`
- [`statswales_get_filters()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_filters.md)
  now flattens hierarchical dimensions: the `values` data frame gains
  `parent` and `level` columns so nested values (e.g. Wales → local
  authorities → wards) are fully represented
- [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md)
  now uses a two-step POST + GET flow; filters use the new
  `list(list(ColumnName = c("ref1", "ref2")))` format and human-readable
  column names/values are returned by default
- [`statswales_search()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_search.md)
  restored with full-text search across dataset titles and summaries;
  supports `mode` argument (`basic`, `fts`, `fuzzy`, etc.)
- [`statswales_get_filters()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_filters.md)
  path updated to `/{id}/filters`
- [`statswales_download_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_download_dataset.md)
  now uses the POST + GET filter ID flow; `format` is a query parameter
  rather than a URL path segment
- New
  [`statswales_get_pivot()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_pivot.md)
  for cross-tabulated pivot views
- New
  [`statswales_create_query()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_create_query.md)
  to generate a reusable filter ID
- New
  [`statswales_get_query()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_query.md)
  to inspect a stored query configuration (total row count, column
  mappings, applied filters)
- [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md)
  results are now tidied for analysis by default: internal `*_sort`
  columns are dropped, whitespace padding is stripped, and
  numeric-looking columns (including data values) are converted to
  numeric. Set `tidy = FALSE` for the raw API response
- [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md)
  now returns the entire dataset by default (`all_pages = TRUE`); set
  `all_pages = FALSE` for single-page retrieval. The default `page_size`
  was also raised from 100 to 10000 (the API maximum), so most datasets
  arrive in a single request
- [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md)
  now fetches the full dataset catalogue automatically; the
  `page_number` and `page_size` arguments were removed
- Timestamp columns from
  [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md)
  and
  [`statswales_search()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_search.md)
  are now `POSIXct` (UTC) instead of character
- All API requests now retry transient failures (up to 3 attempts)

## statswalesr 0.4.0

- Complete rewrite for the new StatsWales public API
  (`https://api.stats.gov.wales/v1`)
- Dataset IDs are now UUIDs returned by the API; old alphanumeric codes
  no longer apply
- New functions:
  [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md),
  [`statswales_list_topics()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_topics.md),
  [`statswales_get_topic()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_topic.md),
  [`statswales_get_filters()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_filters.md),
  [`statswales_download_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_download_dataset.md)
- [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md)
  now calls the paginated view endpoint and returns a data frame; set
  `all_pages = TRUE` to auto-fetch all pages
- [`statswales_get_metadata()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_metadata.md)
  restored — returns full dataset metadata including revision history
- Removed all deprecated functions and their dependencies (`lifecycle`,
  `rlang`, `curl`, `readr`, `httr`)
- Replaced `httr` with `httr2`; added `jsonlite` as a dependency
- Requires R \>= 4.1.0

## statswalesr 0.3.0

- All functions deprecated except statswales_get_dataset() due to end of
  OData service
- ‘readr’ and ‘lifecycle’ added as dependencies

## statswalesr 0.2.0

CRAN release: 2022-04-03

- Welsh language options are now available across the three statswalesr
  functions

## statswalesr 0.1.4

CRAN release: 2021-07-14

- a couple of minor fixes have been made to the package’s unit tests

## statswalesr 0.1.3

CRAN release: 2021-05-12

- added better error handling when API does not respond

## statswalesr 0.1.2

CRAN release: 2021-01-23

- added more robust http error handling to statswales_get_metadata()

## statswalesr 0.1.1

CRAN release: 2020-11-29

- added more helpful error messages for http errors

## statswalesr 0.1.0

CRAN release: 2020-11-26

- fixed a bug that exported the pipe operator `%>%` with the package
