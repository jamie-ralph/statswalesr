# statswalesr 0.4.0

* Complete rewrite for the new StatsWales public API (`https://api.stats.gov.wales/v1`)
* Dataset IDs are now UUIDs returned by the API; old alphanumeric codes no longer apply
* New functions: `statswales_list_datasets()`, `statswales_list_topics()`, `statswales_get_topic()`, `statswales_get_filters()`, `statswales_download_dataset()`
* `statswales_get_dataset()` now calls the paginated view endpoint and returns a data frame; set `all_pages = TRUE` to auto-fetch all pages
* `statswales_get_metadata()` restored — returns full dataset metadata including revision history
* Removed all deprecated functions and their dependencies (`lifecycle`, `rlang`, `curl`, `readr`, `httr`)
* Replaced `httr` with `httr2`; added `jsonlite` as a dependency
* Requires R >= 4.1.0

# statswalesr 0.3.0

* All functions deprecated except statswales_get_dataset() due to end
of OData service
* 'readr' and 'lifecycle' added as dependencies

# statswalesr 0.2.0

* Welsh language options are now available across the three statswalesr functions

# statswalesr 0.1.4

* a couple of minor fixes have been made to the package's unit tests

# statswalesr 0.1.3

* added better error handling when API does not respond 

# statswalesr 0.1.2

* added more robust http error handling to statswales_get_metadata()

# statswalesr 0.1.1

* added more helpful error messages for http errors 

# statswalesr 0.1.0

* fixed a bug that exported the pipe operator `%>%` with the package
