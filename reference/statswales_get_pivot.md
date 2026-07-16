# Retrieve a pivot table for a dataset

Returns a cross-tabulated view of dataset data. Choose one dimension for
the columns (`x`) and one for the rows (`y`). The API stores the pivot
configuration as a reusable query.

## Usage

``` r
statswales_get_pivot(
  dataset_id,
  x,
  y,
  lang = "en-gb",
  page_number = 1,
  page_size = 100,
  filter = NULL,
  options = list(use_raw_column_names = FALSE, use_reference_values = FALSE,
    data_value_type = "formatted"),
  sort_by = NULL
)
```

## Arguments

- dataset_id:

  A dataset UUID string. Use
  [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md)
  to find dataset IDs.

- x:

  Column name for the horizontal axis (column headers).

- y:

  Column name for the vertical axis (row labels).

- lang:

  Language for returned text. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

- page_number:

  Page number to return. Default `1`.

- page_size:

  Rows per page. Default `100`.

- filter:

  Filter criteria in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

- options:

  Display options in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

- sort_by:

  Optional sort order, in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

## Value

A list containing the paginated pivot view returned by the API, or
`NULL` if the request fails.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
id <- datasets$id[1]
filters <- statswales_get_filters(id)

pivot <- statswales_get_pivot(
  id,
  x = filters[[1]]$columnName,
  y = filters[[2]]$columnName
)
} # }
```
