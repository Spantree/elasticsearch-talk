# Sorting Dates

Sorting documents matching "chicago" by last update time

`GET /wikipedia/locations/_search`

```
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
## Descending Sort

Sorting documents matching "chicago" by last updated time

`GET /wikipedia/locations/_search`

```
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
## Sorting Strings

Specify a search result start/form value

`GET /wikipedia/locations/_search`

```
{
  fields": ["name", "about", "coordinates"],
  "query": {
    "bool": {
      "must": [{
        "query_string": {"query": "chicago"}
      }]
    }
  },
  "sort": [{"name": "desc"}]
}
```

## Sorting by Distance

Find locations matching "chicago" sorted by distance from the Spantree offices.

`GET /wikipedia/locations/_search`

```
{
  "fields": ["name", "about", "coordinates"],
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
        "coordinates": [-87.647901, 41.884445],
        "order": "asc",
        "unit": "mi"
      }
    }
  ],
  "size": 10
}
```

