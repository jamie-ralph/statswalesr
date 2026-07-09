# Submission Notes for v1.0.0

## Changes
* Complete rewrite for the new StatsWales public API v2
  (<https://api.stats.gov.wales/v2>); the OData service used by earlier
  versions has been retired
* Dataset IDs are now UUIDs returned by the API; old alphanumeric codes no
  longer apply
* New functions: statswales_list_datasets(), statswales_list_topics(),
  statswales_get_topic(), statswales_get_filters(), statswales_get_pivot(),
  statswales_create_query(), statswales_get_query(),
  statswales_download_dataset()
* statswales_get_dataset() and statswales_search() rewritten for the new API,
  with support for filtering, sorting, pagination, and Welsh language output
* Results are tidied for analysis by default (numeric conversion, internal
  columns dropped); set tidy = FALSE for the raw API response
* Replaced httr with httr2; removed lifecycle, rlang, curl, and readr
  dependencies; added jsonlite
* All API requests fail gracefully (returning NULL with a message) when the
  API is unavailable, and retry transient failures
* Requires R >= 4.1.0

## R CMD check results
0 errors | 0 warnings | 0 notes

## Test environments
* Local macOS (aarch64), R 4.6.0, R CMD check --as-cran
* GitHub Actions: windows-latest (R release), macos-latest (R release),
  ubuntu-latest (R devel, release, and oldrel-1)

## revdepcheck results
We checked 0 reverse dependencies, comparing R CMD check results across CRAN
and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

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
