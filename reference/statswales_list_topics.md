# List top-level topics

Returns a data frame of all top-level topics that have at least one
published dataset tagged against them.

## Usage

``` r
statswales_list_topics(lang = "en-gb")
```

## Arguments

- lang:

  Language for returned text. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

## Value

A data frame with columns `id`, `path`, `name`, `name_en`, and
`name_cy`. Returns `NULL` if the request fails.

## Examples

``` r
if (FALSE) { # \dontrun{
topics <- statswales_list_topics()
} # }
```
