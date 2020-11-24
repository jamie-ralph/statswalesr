# statswalesr [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/jamie-ralph/statswalesr?branch=main&svg=true)](https://ci.appveyor.com/project/jamie-ralph/statswalesr) [![Travis build status](https://travis-ci.org/jamie-ralph/statswalesr.svg?branch=main)](https://travis-ci.org/jamie-ralph/statswalesr)

statswalesr is a package for downloading datasets and their associated
metadata from StatsWales. This functionality is limited to datasets that
are available through the OData feed. You can check this by navigating
to your desired dataset, scrolling to the bottom, and checking that the
“Dataset” link is available under the Open Data tab.

## Installation

**This package is still in development**. You can install the latest
version of statswalesr from GitHub with:

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

You can also search for datasets based on key terms. For example, if I
wanted data on farming or agriculture I could do the following:

``` r
library(dplyr)

farming_datasets <- statswales_search(c("farm*", "agri*"))
```

``` r
glimpse(farming_datasets)
```

    ## Observations: 29
    ## Variables: 2
    ## $ Description_ENG <chr> "Children's services: Welfare/health summary", "Chi...
    ## $ Dataset         <chr> "care0021", "care0022", "tran0169", "agri0200", "ag...
