# Retrieve data for a dataset

Returns a data frame containing rows from a published dataset. Filters
and display options are submitted to the API as a stored query; the same
inputs always produce the same query ID so repeated calls are efficient.

## Usage

``` r
statswales_get_dataset(
  dataset_id,
  lang = "en-gb",
  page_number = 1,
  page_size = 10000,
  filter = NULL,
  options = list(use_raw_column_names = FALSE, use_reference_values = FALSE,
    data_value_type = "formatted"),
  sort_by = NULL,
  all_pages = TRUE,
  tidy = TRUE
)
```

## Arguments

- dataset_id:

  A dataset UUID string. Use
  [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md)
  to find dataset IDs.

- lang:

  Language for text values. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

- page_number:

  Page of results to return. Default `1`. Only used when
  `all_pages = FALSE`.

- page_size:

  Rows per page. Default `10000` (the API maximum).

- filter:

  A list of filter objects. Each element is a named list mapping a
  column name (from
  [`statswales_get_filters()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_filters.md))
  to a character vector of reference codes. Multiple list elements use
  AND logic; multiple codes within one element use OR logic. Example:
  `list(list(Year = c("2020", "2021")), list(Area = c("W92000004")))`.

- options:

  A named list of display options:

  `use_raw_column_names`

  :   `FALSE` (default) returns human-readable column names; `TRUE`
      returns internal fact-table names.

  `use_reference_values`

  :   `FALSE` (default) returns human-readable values; `TRUE` returns
      reference codes.

  `data_value_type`

  :   One of `"raw"`, `"raw_extended"`, `"formatted"` (default),
      `"formatted_extended"`, or `"with_note_codes"`.

  Note: as of July 2026 the StatsWales API ignores
  `use_raw_column_names` and `use_reference_values`, so output always
  uses human-readable column names and values regardless of these
  settings. Only `data_value_type` currently changes the output.

- sort_by:

  Optional sort order. Either a ready-made string in the API's
  `"column:direction"` format (e.g. `"Year:desc"`), or a named character
  vector such as `c(Year = "desc", Area = "asc")`. Directions are
  `"asc"` or `"desc"`.

- all_pages:

  If `TRUE` (default), automatically fetches and row-binds all pages so
  the entire dataset is returned. Set to `FALSE` to retrieve a single
  page controlled by `page_number` and `page_size`.

- tidy:

  If `TRUE` (default), the result is cleaned for analysis: the API's
  internal `*_sort` columns are dropped, whitespace padding is stripped,
  and numeric-looking columns (such as the data values) are converted to
  numeric. Set to `FALSE` to return the API response as-is.

## Value

A data frame of dataset rows, or `NULL` if the request fails.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
id <- datasets$id[1]

# Entire dataset, human-readable (default)
df <- statswales_get_dataset(id)

# A single page of 100 rows
df_page <- statswales_get_dataset(id, all_pages = FALSE, page_size = 100)

# Filtered to specific years
filters <- statswales_get_filters(id)
df_filtered <- statswales_get_dataset(
  id,
  filter = list(list(Year = c("2020", "2021")))
)
} # }
```
