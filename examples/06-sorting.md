# Sorting

## Sorting Dates Chronologically

Sorting documents matching "chicago" by last update time.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "lastUpdated"],
  "query": {
    "bool": {
      "must": [
        {"query_string": {"query": "chicago"}}
      ]
    }
  },
  "sort": ["lastUpdated"]
}
```
## Sorting Dates in Descending Order

Sort documents matching "chicago" by last updated time, most recent first.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "lastUpdated"],
  "query": {
    "bool": {
      "must": [{"query_string": {"query": "chicago"}}]
    }
  },
  "sort": [{"lastUpdated": "desc"}]
}
```

## Sorting by Distance

Find locations matching "chicago" sorted by distance from the Spantree offices.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "coordinates"],
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "chicago"
          }
        }
      ]
    }
  },
  "sort": [
    {
      "_geo_distance": {
        "coordinates": [-87.655979, 41.886732],
        "order": "asc",
        "unit": "mi"
      }
    }
  ],
  "size": 10
}
```

## Sorting Strings The Wrong Way

Sorting by strings is actually a bit trickier. In Lucene, sorts are based on individual terms in the inverted index. 
Because our name field is tokenized, the first alphabetical token in the field value determines a field's ranking.

`GET /wikipedia/locations/_search`

```json
{
  "fields": ["name"],
  "query": {
    "bool": {
      "must": [{
        "query_string": {"query": "academy"}
      }]
    }
  },
  "sort": ["name"]
}
```

## Configuring a Sortable String Analysis Chain

To resolve this issue, we recommend setting up an analyzer specifically for string sorting. We've preconfigured an 
'alpha_space_only' in the index which uses the 'keyword' tokenizer. This analyzer also lowercases and removes any 
non-alphanumeric characters so punctuation symbols don't get sorted.

`GET /wikipedia/_settings?name=*.sort*.*`

## Storing the Sortable String in a Multi-Field

For the name field, we want to do both full-text search and string sorting. So to make sure we can handle both, we 
configure name to be a multi-field.

`GET /wikipedia/locations/_mapping`

## Testing the Sortable String Analyzer

When creating new analyzers, we recommend testing them out using the Analyze API to make sure they work as expected.

`GET /wikipedia/_analyze?field=name.sortable&text=I wanna know what love is; I want you to show me!`

## Sorting Strings the Right Way

Now that we've done all that, we simply swap out the sort field from the previous query to use `name.sorted`.

`GET /wikipedia/locations/_search`

```json
{
  "fields": ["name"],
  "query": {
    "bool": {
      "must": [{
        "query_string": {"query": "academy"}
      }]
    }
  },
  "sort": ["name.sortable"]
}
```

