# Get the contents of a topic

Returns sub-topics or datasets tagged directly to a given topic. Use
[`statswales_list_topics()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_topics.md)
to discover topic IDs.

## Usage

``` r
statswales_get_topic(
  topic_id,
  lang = "en-gb",
  page_number = 1,
  page_size = 100,
  sort_by = NULL
)
```

## Arguments

- topic_id:

  A numeric topic ID. Use
  [`statswales_list_topics()`](https://jamie-ralph.github.io/statswalesr/reference/statswales_list_topics.md)
  to find IDs.

- lang:

  Language for returned text. One of `"en-gb"` (default), `"en"`,
  `"cy-gb"`, or `"cy"`.

- page_number:

  Page number to return. Default `1`.

- page_size:

  Number of results per page. Default `100`.

- sort_by:

  Optional sort order for datasets under a leaf topic. Either a string
  in `"column:direction"` format (e.g. `"title:asc"`) or a named
  character vector such as `c(title = "asc", last_updated_at = "desc")`.

## Value

A list with fields `selectedTopic`, `children`, `parents`, and
`datasets`. Returns `NULL` if the request fails.

## Details

The returned list has four fields:

- `selectedTopic`:

  Details of the requested topic.

- `children`:

  Sub-topics under this topic. Empty for leaf topics.

- `parents`:

  Ancestor topics from root to the selected topic.

- `datasets`:

  A list with `data` (dataset list items) and `count`. Only populated
  for leaf topics (those with no `children`).

## Examples

``` r
if (FALSE) { # \dontrun{
topics <- statswales_list_topics()
topic <- statswales_get_topic(topics$id[1])

# Sub-topics (non-leaf)
topic$children

# Datasets at a leaf topic
topic$datasets$data
topic$datasets$count
} # }
```
