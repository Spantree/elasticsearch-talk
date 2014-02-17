# Term Facets And Aggregations

Get gender terms via aggregation
`GET /divvy/trips/_search`

```json
{
    "aggs" : {
        "genders" : {
            "terms" : { "field" : "gender" }
        }
    }
}
```

Get gender terms via facet
`GET /divvy/trips/_search`

```json
{
  "query" : {
    "match_all" : {  }
  },
  "facets" : {
    "gender" : {
      "terms" : {
        "field" : "gender",
        "size" : 10
      }
    }
  }
}
```

Get min / max / avg trip duration

```json
{
    "aggs" : {
        "min_trip" : {
            "min" : { "field" : "trip_duration" }
        },
        "max_trip" : {
            "max" : { "field" : "trip_duration" }
        }
        "avg_trip" : {
            "avg" : { "field" : "trip_duration" }
        }
    }
}
```

Get buckets based on Spantree's office

```json
{
    "aggs" : {
        "rings_around_spantree" : {
            "geo_distance" : {
                "field" : "location",
                "origin" : "41.886732, -87.655979",
                "unit" : "yd"
                "ranges" : [
                    { "to" : 100 },
                    { "from" : 100, "to" : 300 },
                    { "from" : 300, "to" : 500 },
                    { "from" : 500, "to" : 1000 },
                    { "from" : 1000},
                ]
            }
        }
    }
}
```