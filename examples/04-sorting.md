# Sorting

## Sorting Dates

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
## Sorting Dates Descending

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
## Sorting Strings

Specify a search result start/from value

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "about", "coordinates"],
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

