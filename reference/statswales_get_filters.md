# Get available filters for a dataset

Returns a list of filterable dimensions and their allowed values. Use
the output to build the `filter` argument for
[`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md),
[`statswales_download_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_download_dataset.md),
and
[`statswales_get_pivot()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_pivot.md).

## Usage

``` r
statswales_get_filters(dataset_id, lang = "en-gb")
```

## Arguments

- dataset_id:

  A dataset UUID string. Use
  [`statswales_list_datasets()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_datasets.md)
  to find dataset IDs.

- lang:

  Language for returned text. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

## Value

A list where each element corresponds to a filterable dimension and
contains:

- `factTableColumn`:

  Internal column name used in data queries.

- `columnName`:

  Human-readable dimension name — use this as the key in filter objects.

- `values`:

  A data frame of available filter values with columns `reference`,
  `description`, `parent`, and `level`. Hierarchical dimensions (e.g.
  Wales → local authorities → wards) are flattened into this data frame:
  `parent` holds the reference of the parent value (`NA` at the top
  level) and `level` is the 1-based depth. Any value's `reference` can
  be used in a filter.

Returns `NULL` if the request fails.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
filters <- statswales_get_filters(datasets$id[1])

# See available values for the first dimension
filters[[1]]$columnName
filters[[1]]$values

# Use a filter value in a data query
df <- statswales_get_dataset(
  datasets$id[1],
  filter = list(list(
    Year = filters[[1]]$values$reference[1:2]
  ))
)
} # }
```
