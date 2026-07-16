# Get metadata for a dataset

Returns full metadata for a published dataset including revision
history, publication dates, and dimension information.

## Usage

``` r
statswales_get_metadata(dataset_id, lang = "en-gb")
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

A list containing dataset metadata. Returns `NULL` if the request fails
or the dataset is not found.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
meta <- statswales_get_metadata(datasets$id[1])
} # }
```
