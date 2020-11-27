# statswalesr

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/statswalesr)](https://cran.r-project.org/web/packages/statswalesr/index.html)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/jamie-ralph/statswalesr?branch=dev&svg=true)](https://ci.appveyor.com/project/jamie-ralph/statswalesr)
[![Travis build
status](https://travis-ci.org/jamie-ralph/statswalesr.svg?branch=dev)](https://travis-ci.org/jamie-ralph/statswalesr)

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

## Example

The code below extracts data about [aircraft movement at Cardiff
airport](https://statswales.gov.wales/Catalogue/Transport/Air/aircraftmovementsatcardiffairport-by-movementtype-year)
and the associated metadata.

``` r
library(statswalesr)

metadata <- statswalesr::statswales_get_metadata("tran0003")

df <- statswalesr::statswales_get_dataset("tran0003")
```

``` r
str(df)
```

    ## 'data.frame':    182 obs. of  10 variables:
    ##  $ Data                      : chr  "0" "0" "0" "0" ...
    ##  $ MovementType_Code         : chr  "29" "29" "29" "29" ...
    ##  $ MovementType_ItemName_ENG : chr  "Business Aviation" "Business Aviation" "Business Aviation" "Business Aviation" ...
    ##  $ MovementType_SortOrder    : chr  "29" "29" "29" "29" ...
    ##  $ MovementType_Hierarchy    : chr  "11" "11" "11" "11" ...
    ##  $ MovementType_ItemNotes_ENG: chr  "" "" "" "" ...
    ##  $ Year_Code                 : chr  "2015" "2010" "2011" "2016" ...
    ##  $ Year_ItemName_ENG         : chr  "2015" "2010" "2011" "2016" ...
    ##  $ Year_SortOrder            : chr  "26" "21" "22" "27" ...
    ##  $ PartitionKey              : chr  "0" "0" "0" "0" ...

You can also search for datasets based on key terms. For example, if I
wanted data on farming or agriculture I could do the following:

``` r
library(dplyr)

farming_datasets <- statswales_search(c("farm*", "agri*"))
```

``` r
glimpse(farming_datasets)
```

    ## Rows: 29
    ## Columns: 2
    ## $ Description_ENG <chr> "Children's services: Welfare/health summary", "Chi...
    ## $ Dataset         <chr> "care0021", "care0022", "agri0200", "agri0201", "ag...
