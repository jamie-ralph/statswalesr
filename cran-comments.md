# Submission Notes for v0.2.0
* Support has been added for Welsh language downloads, specified with the "language" parameter
* Continuous integration has been migrated to GitHub actions
* Each function checks that a JSON object has been returned from the API - if not, NULL is returned
* Tests added for Welsh language downloads

# Submission Notes for v0.1.4

## Corrections made
* Fixed a test that didn't account for when the StatsWales API is down.

# Submission Notes for v0.1.3

## Corrections made
* Removed LazyData argument from description file
* Added timeout to all GET requests. If a response is not returned within 10 seconds the function exits gracefully. This accounts for occasions when the API is down or performing very slowly. This should also prevent examples failing if the API is down. 

## R CMD check results
* No errors, warnings, or notes

# Submission Notes for v0.1.2

## Corrections made

* Made graceful failure for metadata function more robust. 

# Submission Notes for v0.1.1

## Corrections made

* Functions now fail gracefully when the API cannot be accessed, the dataset id is invalid, or there is no internet connection. Requests are initially made with httr package and then checked before parsing with jsonlite. Apologies for not including this in first release.
* Example code in statswales_get_dataset() set to "dontrun" - the query took >5s which might have caused CRAN checks to fail.
* There was a NOTE regarding 'curl' package being imported, but not used, in the CRAN package checks. curl is now called to check for an internet connection which should fix this.
* httr package is now imported - makes API requests and checks for http errors.
* error messages for non-string type dataset id's are now consistent between functions.
* User agent now added to all GET requests - this is the GitHub page for statswalesr as recommended [here.](https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html)

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
