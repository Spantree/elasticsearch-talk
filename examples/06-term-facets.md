# Term Facets And Aggregations

Get gender terms via aggregation
`GET /divvy/trip/_search`

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
`GET /divvy/trip/_search`

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

`GET /divvy/trip/_search`

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

`GET /divvy/trip/_search`

```json
{
    "aggs" : {
        "spantree_dist" : {
            "geo_distance" : {
                "field" : "location",
                "origin" : {
                  "lat": 41.886732, 
                  "lon": -87.655979
                },
                "unit" : "yd", 
                "ranges" : [
                    { "to" : 300 },
                    { "from" : 300, "to" : 500 },
                    { "from" : 500, "to" : 1000 },
                    { "from" : 1000, "to" : 1500 },
                    { "from" : 1500, "to": 2000},
                    { "from" : 2000}
                ]
            }
        }
    }
}
```