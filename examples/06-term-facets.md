# Term Facets

lorem ipsum

`GET /wikipedia_term_facets/locations/_search`

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
  "sort": [{"name_not_analyzed": "asc"}]
}
```