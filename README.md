# rstatswales

rstatswales is a package for downloading data from StatsWales to your R
environment. This functionality is limited to datasets that are
available through the OData feed. You can check this by navigating to
your desired dataset, scrolling to the bottom, and checking that the
“Dataset” link is available under the Open Data tab.

## Installation

**This package is still in development**. You can install the latest
version of rstatswales from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("jamie-ralph/rstatswales")
```

## Example

In the code below, I’m extracting data on [aircraft movement at Cardiff
airport](https://statswales.gov.wales/Catalogue/Transport/Air/aircraftmovementsatcardiffairport-by-movementtype-year).

``` r
library(rstatswales)

df <- rstatswales::get_dataset("tran0003")
```

``` r
str(df)
```

    ## 'data.frame':    169 obs. of  11 variables:
    ##  $ Data                      : chr  "0" "0" "0" "0" ...
    ##  $ MovementType_Code         : chr  "29" "29" "29" "29" ...
    ##  $ MovementType_ItemName_ENG : chr  "Business Aviation" "Business Aviation" "Business Aviation" "Business Aviation" ...
    ##  $ MovementType_SortOrder    : chr  "29" "29" "29" "29" ...
    ##  $ MovementType_Hierarchy    : chr  "11" "11" "11" "11" ...
    ##  $ MovementType_ItemNotes_ENG: chr  "" "" "" "" ...
    ##  $ Year_Code                 : chr  "2016" "2010" "2013" "2018" ...
    ##  $ Year_ItemName_ENG         : chr  "2016" "2010" "2013" "2018" ...
    ##  $ Year_SortOrder            : chr  "27" "21" "24" "29" ...
    ##  $ RowKey                    : chr  "0000000000000026" "0000000000000027" "0000000000000028" "0000000000000029" ...
    ##  $ PartitionKey              : chr  "0" "0" "0" "0" ...
