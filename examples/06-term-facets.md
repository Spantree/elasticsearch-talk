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

Get min / max / avg trip duration. As a note, 85117 seconds is roughly 23.6 hours.

`GET /divvy/trip/_search`

```json
{
    "aggs" : {
        "min_trip" : {
            "min" : { "field" : "trip_duration" }
        },
        "max_trip" : {
            "max" : { "field" : "trip_duration" }
        },
        "avg_trip" : {
            "avg" : { "field" : "trip_duration" }
        }
    }
}
```

Get all stats

`GET /divvy/trip/_search`

```json
{
    "aggs" : {
        "trip_duration_stats" : {
            "stats" : { "field" : "trip_duration" }
        }
    }
}
```


Get buckets based on Spantree's office

`GET /divvy/station/_search`

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

Get bike trips by quarter

`GET /divvy/trip/_search`
```json
{
    "aggs" : {
        "trips_over_time" : {
            "date_histogram" : {
                "field" : "start_time",
                "interval" : "quarter"
            }
        }

    }
}
```