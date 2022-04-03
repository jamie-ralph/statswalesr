# statswalesr

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/statswalesr)](https://cran.r-project.org/package=statswalesr)
[![R-CMD-check](https://github.com/jamie-ralph/statswalesr/workflows/R-CMD-check/badge.svg)](https://github.com/jamie-ralph/statswalesr/actions)
<!-- badges: end -->

statswalesr is a package for downloading datasets and their associated
metadata from StatsWales. This functionality is limited to datasets that
are available through the OData feed. You can check this by navigating
to your desired dataset, scrolling to the bottom, and checking that the
“Dataset” link is available under the Open Data tab.

## Installation

statswalesr is now on CRAN. To install:

``` r
install.packages("statswalesr")
```

You can install the development version of statswalesr from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("jamie-ralph/statswalesr")
```

## Usage

The code below extracts data about [aircraft movement at Cardiff
airport](https://statswales.gov.wales/Catalogue/Transport/Air/aircraftmovementsatcardiffairport-by-movementtype-year)
and the associated metadata.

``` r
library(statswalesr)
library(dplyr)

metadata <- statswales_get_metadata("tran0003")

df <- statswales_get_dataset("tran0003")
```

You can also search for datasets based on key terms. For example, to
search for datasets related to farming and agriculture:

``` r
farming_datasets <- statswales_search(c("farm*", "agri*"))

glimpse(farming_datasets)
```

## Welsh language

All statswalesr functions support Welsh language downloads using the
**language** argument:

``` r
welsh_df <- statswales_get_dataset("tran0003", language = "welsh")
```
