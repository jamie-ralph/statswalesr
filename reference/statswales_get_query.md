# Inspect a stored query configuration

Returns the full configuration of a stored query, including the applied
filters, total row count, column mappings, and the underlying SQL. The
`filter_id` is returned by any call to
[`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md)
(via the `POST /data` step) or
[`statswales_get_pivot()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_pivot.md).

## Usage

``` r
statswales_get_query(dataset_id, filter_id)
```

## Arguments

- dataset_id:

  A dataset UUID string.

- filter_id:

  A 12-character query identifier returned by the API.

## Value

A list containing the stored query details:

- `id`:

  The filter ID.

- `totalLines`:

  Total number of rows matching the query.

- `requestObject`:

  The filter and options that were submitted.

- `columnMapping`:

  Mapping between internal column names and display names, per language.

- `query`:

  A named list of SQL strings keyed by language code.

Returns `NULL` if the request fails.

## Details

To retrieve the `filter_id` directly, call
[`statswales_create_query()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_create_query.md).

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
id <- datasets$id[1]

fid <- statswales_create_query(id)
query_info <- statswales_get_query(id, fid)
query_info$totalLines
} # }
```
