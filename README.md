# statswalesr <a href='https://jamie-ralph.github.io/statswalesr/'><img src="man/figures/statswalesr.png" align="right" width="200"/></a>

<!-- badges: start -->

![version](https://img.shields.io/badge/version-0.3.0-orange)
[![R-CMD-check](https://github.com/jamie-ralph/statswalesr/workflows/R-CMD-check/badge.svg)](https://github.com/jamie-ralph/statswalesr/actions)
[![R-CMD-check](https://github.com/jamie-ralph/statswalesr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jamie-ralph/statswalesr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

statswalesr is a package for downloading datasets from StatsWales.

In August 2024 the Welsh Government ended the OData service which
statswalesr used under the hood to retrieve and search for data - you
can read more
[here](https://digitalanddata.blog.gov.wales/2024/08/19/further-update-for-statswales-odata-users/).
In response, I’ve decided to deprecate all functions except
**statswales_get_dataset()** which will use the Welsh Government’s
temporary workaround to get data.

A documentation site generated by **pkgdown** can be found [at this
link](https://jamie-ralph.github.io/statswalesr/).

## Installation

You can install the latest version of statswalesr from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("jamie-ralph/statswalesr")
```

**Please note**: The current version of this package (0.2.0) on CRAN
still relies on the old OData service and will not work.

## Getting data from StatsWales

The code below extracts data about [revenue outturn
expenditure](https://statswales.gov.wales/Catalogue/Local-Government/Finance/Revenue/Outturn/revenueoutturnexpenditure-by-authority).

``` r
library(statswalesr)

df <- statswales_get_dataset("LGFS0023")
```

------------------------------------------------------------------------

*Hex sticker by Lew Furber.*
