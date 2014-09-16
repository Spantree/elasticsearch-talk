# Aggregations

## Get gender terms via aggregation

`GET /divvy/trip/_search?search_type=count`

```json
{
    "aggs" : {
        "genders" : {
            "terms" : { "field" : "gender" }
        }
    }
}
```

## Get stats for trip duration

`GET /divvy/trip/_search?search_type=count`

```json
{
    "aggs" : {
        "trip_duration_stats" : {
            "stats" : { "field" : "trip_duration" }
        }
    }
}
```

## Get extended stats for trip duration

`GET /divvy/trip/_search?search_type=count`

```json
{
    "aggs" : {
        "trip_duration_stats" : {
            "extended_stats" : { "field" : "trip_duration" }
        }
    }
}
```

## Get percentiles

`GET /divvy/trip/_search?search_type=count`

```json
{
    "aggs": {
        "trip_length": {
            "percentiles": {
                "field": "trip_duration",
                "percents": [25,50,75]
            }
        }
    }
}
```

## Get gender terms / stats via facet

`GET /divvy/trip/_search?search_type=count`

```json
{
  "query" : {
    "match_all" : {  }
  },
  "aggs" : {
    "gender" : {
      "terms" : {
        "field" : "gender",
        "size" : 10
      },
      "aggs": {
      "trip_duration_stats": {
        "stats": {
          "field": "trip_duration"
        }
      }
    }
  }
}
}
```



## Get buckets based on Spantree's office

`GET /divvy/station/_search?search_type=count`

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

## Get bike trip duration histogram
`GET /divvy/trip/_search?search_type=count`

```json
{
    "aggs" : {
        "trip_length" : {
            "histogram" : {
                "field" : "trip_duration",
                "interval" : 300,
                "min_doc_count" : 10
            }
        }
    }
}
```


## Get bike trips by week

`GET /divvy/trip/_search?search_type=count`
```json
{
    "aggs" : {
        "trips_over_time" : {
            "date_histogram" : {
                "field" : "start_time",
                "interval" : "week"
            }
        }

    }
}
```

## Get oldest movie by genre

`GET /freebase/film/_search?search_type=count`

```json
{
   "aggs":{
      "top_genres":{
         "terms":{
            "field":"genre",
            "size":10
         },
         "aggs":{
            "top_genre_hits":{
               "top_hits":{
                  "sort":[
                     {
                        "initial_release_date":{
                           "order":"asc"
                        }
                     }
                  ],
                  "_source":{
                     "include":[
                        "name",
                        "initial_release_date"
                     ]
                  },
                  "size":1
               }
            }
         }
      }
   }
}
```

## Get top 3 directors by genre

`GET /freebase/film/_search?search_type=count`

```json
{
   "aggs":{
      "top_genres":{
         "terms":{
            "field":"genre",
            "size":10
         },
         "aggs":{
            "top_directors":{
               "terms":{
                  "field":"directed_by.facet",
                  "size":3
               }
            }
         }
      }
   }
}
```