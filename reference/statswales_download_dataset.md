# Download a dataset file

Downloads a published dataset as a file. The `filter` and `options`
arguments work identically to
[`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

## Usage

``` r
statswales_download_dataset(
  dataset_id,
  format = "csv",
  lang = "en-gb",
  path = NULL,
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

- format:

  File format. One of `"csv"` (default) or `"xlsx"`.

- lang:

  Language for the downloaded file. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

- path:

  File path for saving the download. If `NULL` (default), a temporary
  file is created automatically.

- filter:

  Filter criteria in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

- options:

  Display options in the same format as
  [`statswales_get_dataset()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_get_dataset.md).

## Value

The path to the downloaded file, invisibly. Returns `NULL` if the
download fails.

## Examples

``` r
if (FALSE) { # \dontrun{
datasets <- statswales_list_datasets()
id <- datasets$id[1]

# Download full dataset as CSV
path <- statswales_download_dataset(id)
df <- read.csv(path)

# Download filtered data as Excel
statswales_download_dataset(
  id,
  format = "xlsx",
  filter = list(list(Year = c("2022", "2023"))),
  path = "my_data.xlsx"
)
} # }
```
