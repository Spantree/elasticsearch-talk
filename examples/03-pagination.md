# Pagination

## Setting the Page Size

Specify a search result page size.

`GET /wikipedia/locations/_search`

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
  "size": 20
}
```

## Specifying Ranges

Specify a search result start/from value

```json
{
  "fields": ["name", "coordinates"],
  "query": {
    "bool": {
      "must": [
        {"query_string": {"query": "chicago"}}
      ]
    }
  },
  "size": 10,
  "from": 10
}
```