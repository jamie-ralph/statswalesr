# Create a stored query and return its filter ID

Submits a set of filters and display options to the API and returns the
resulting filter ID. The same inputs always produce the same ID, so this
is useful for building shareable, reproducible data requests.

## Usage

``` r
statswales_create_query(
  dataset_id,
  filter = NULL,
  options = list(use_raw_column_names = FALSE, use_reference_values = FALSE,
    data_value_type = "formatted")
)
```

## Arguments

- dataset_id:

  A dataset UUID string. Use
  [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md)
  to find dataset IDs.

- filter:

  Filter criteria in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

- options:

  Display options in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

## Value

A character string containing the 12-character filter ID, or `NULL` if
the request fails.

## Details

Pass the returned `filter_id` to
[`statswales_get_query()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_query.md)
to inspect the query configuration, or use it directly in
[`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md)
/
[`statswales_download_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_download_dataset.md)
workflows.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
id <- datasets$id[1]

fid <- statswales_create_query(id)
statswales_get_query(id, fid)
} # }
```
