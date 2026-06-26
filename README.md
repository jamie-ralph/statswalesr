# statswalesr <a href='https://jamie-ralph.github.io/statswalesr/'><img src="man/figures/statswalesr.png" align="right" width="200"/></a>

<!-- badges: start -->

![version](https://img.shields.io/badge/version-0.4.0-orange)
[![R-CMD-check](https://github.com/jamie-ralph/statswalesr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jamie-ralph/statswalesr/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

statswalesr is an R package for accessing data from the [StatsWales public API](https://api.stats.gov.wales/v1).

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
head(datasets)

# Browse by topic
topics <- statswales_list_topics()
topic_content <- statswales_get_topic(topics$id[1])
```

### Retrieve data

Dataset IDs are UUIDs returned by `statswales_list_datasets()`.

``` r
id <- datasets$id[1]

# First page of data
df <- statswales_get_dataset(id)

# All pages
df_full <- statswales_get_dataset(id, all_pages = TRUE)

# Welsh language
df_cy <- statswales_get_dataset(id, lang = "cy-gb")
```

### Filter data

``` r
# See what filters are available
filters <- statswales_get_filters(id)
filters[[1]]$values

# Apply a filter
df_filtered <- statswales_get_dataset(
  id,
  filter = list(list(
    factTableColumn = filters[[1]]$factTableColumn,
    values = list(filters[[1]]$values$reference[1])
  ))
)
```

### Dataset metadata

``` r
meta <- statswales_get_metadata(id)
```

### Download a file

``` r
# Download as CSV (returns the file path)
path <- statswales_download_dataset(id, format = "csv")
df <- read.csv(path)

# Download as Excel
statswales_download_dataset(id, format = "xlsx", path = "my_dataset.xlsx")
```

## Functions

| Function | Description |
|---|---|
| `statswales_list_datasets()` | List all published datasets |
| `statswales_list_topics()` | List top-level topic categories |
| `statswales_get_topic()` | Get sub-topics or datasets within a topic |
| `statswales_get_metadata()` | Get full metadata for a dataset |
| `statswales_get_dataset()` | Retrieve dataset data as a data frame |
| `statswales_get_filters()` | List available filters for a dataset |
| `statswales_download_dataset()` | Download a dataset as CSV, JSON, or Excel |

All functions accept a `lang` parameter: `"en-gb"` (default), `"en"`, `"cy-gb"`, or `"cy"`.

---

*Hex sticker by Lew Furber.*
