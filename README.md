# statswalesr <a href='https://jamie-ralph.github.io/statswalesr/'><img src="man/figures/statswalesr.png" align="right" width="200"/></a>

<!-- badges: start -->

![version](https://img.shields.io/badge/version-0.5.0-orange)
[![R-CMD-check](https://github.com/jamie-ralph/statswalesr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jamie-ralph/statswalesr/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

statswalesr is an R package for accessing data from the [StatsWales public API v2](https://api.stats.gov.wales/v2).

## Installation

``` r
# install.packages("devtools")
devtools::install_github("jamie-ralph/statswalesr")
```

## Usage

### Discover datasets

``` r
library(statswalesr)

# List all published datasets
datasets <- statswales_list_datasets()

# Full-text search
results <- statswales_search("hospital")
results_fuzzy <- statswales_search("transprt", mode = "fuzzy")

# Browse by topic
topics <- statswales_list_topics()
topic_content <- statswales_get_topic(topics$id[1])
```

### Retrieve data

Dataset IDs are UUIDs returned by `statswales_list_datasets()` or
`statswales_search()`.

``` r
id <- datasets$id[1]

# First page, human-readable column names and values (default)
df <- statswales_get_dataset(id)

# All pages
df_full <- statswales_get_dataset(id, all_pages = TRUE)

# Welsh language
df_cy <- statswales_get_dataset(id, lang = "cy-gb")
```

### Filter data

The `filter` argument is a list of named lists. Multiple list elements use
**AND** logic; multiple values within one element use **OR** logic.

``` r
# See what dimensions can be filtered
filters <- statswales_get_filters(id)
filters[[1]]$columnName   # dimension name (use as the key)
filters[[1]]$values       # data frame of reference codes and labels

# Filter to specific values
df_filtered <- statswales_get_dataset(
  id,
  filter = list(
    list(Year = c("2022", "2023")),        # AND
    list(Area = c("W92000004"))             # AND
  )
)
```

### Display options

By default the package returns human-readable column names and values. Override
with the `options` argument:

``` r
df_raw <- statswales_get_dataset(
  id,
  options = list(
    use_raw_column_names = TRUE,   # internal fact-table column names
    use_reference_values = TRUE,   # reference codes instead of labels
    data_value_type = "raw"        # raw data values
  )
)
```

### Pivot tables

``` r
filters <- statswales_get_filters(id)
pivot <- statswales_get_pivot(
  id,
  x = filters[[1]]$columnName,
  y = filters[[2]]$columnName
)
```

### Dataset metadata

``` r
meta <- statswales_get_metadata(id)
meta$published_revision$metadata  # titles and summaries (both languages)
meta$published_revision$designation  # "official", "accredited", etc.
```

### Reusable query IDs

The API stores query configurations with a deterministic 12-character ID.
The same filter inputs always produce the same ID, making results shareable
and reproducible.

``` r
# Create a stored query and inspect it
fid <- statswales_create_query(id, filter = list(list(Year = c("2023"))))
query_info <- statswales_get_query(id, fid)
query_info$totalLines  # total rows matching the query
```

### Download a file

``` r
# Download as CSV
path <- statswales_download_dataset(id, format = "csv")
df <- read.csv(path)

# Download filtered data as Excel
statswales_download_dataset(
  id,
  format = "xlsx",
  filter = list(list(Year = c("2022", "2023"))),
  path = "my_data.xlsx"
)
```

## Function reference

| Function | Description |
|---|---|
| `statswales_list_datasets()` | List all published datasets |
| `statswales_search()` | Full-text search across dataset titles and summaries |
| `statswales_list_topics()` | List top-level topic categories |
| `statswales_get_topic()` | Get sub-topics or datasets within a topic |
| `statswales_get_metadata()` | Full metadata for a dataset |
| `statswales_get_filters()` | Available filter dimensions and values |
| `statswales_get_dataset()` | Dataset data as a data frame |
| `statswales_download_dataset()` | Download dataset as CSV or Excel |
| `statswales_get_pivot()` | Cross-tabulated pivot view |
| `statswales_create_query()` | Create a reusable stored query, return filter ID |
| `statswales_get_query()` | Inspect a stored query configuration |

All functions accept a `lang` parameter: `"en-gb"` (default), `"en"`,
`"cy-gb"`, or `"cy"`.

---

*Hex sticker by Lew Furber.*
