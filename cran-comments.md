# Submission Notes for v0.1.1

## Corrections made

* Functions now fail gracefully when the API cannot be accessed, the dataset id is invalid, or there is no internet connection. This should prevent the examples failing again if the 'StatsWales' API is unavailable. Apologies for not including this in first release.
* There was a NOTE regarding 'curl' package being import but not used in the CRAN package checks. I've tried check() without importing 'curl' but the API calls do not work without it. 

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs

## Test environments
* local Windows 10 environment, R 4.0.2
* AppVeyor & Travis CI



# Submission Notes for first release v0.1.0

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* Possible spelling errors for the words "OData" and "StatsWales"

## Test environments
* local Windows 10 environment, R 4.0.2
* AppVeyor & Travis CI
