## Mapping a geopoint field

Elasticsearch supports 'geopoint' types for latitude and longitude values. After this, we should be able to run our distance query.

`PUT /wikipedia_mapping/locations/_mapping`



```json
{
  "location" : {
        "properties" : {
            "coordinates" : {"type" : "geo_point"}
        }
    }
}
```

## Mapping a multifield (RETITLE/NEW DESCRIPTION)

Elasticsearch provides a multi_field type, which allows you to map the same field value to several core types. In this case, we're mapping the name field to a tokenized value (for text searching), as well a not analyzed field (for faceting and sorting).

`PUT /wikipedia_multifield/locations/_mapping`



  ```json
  {
  "location" : {
        "properties" : {
            "keyword" : {"type":"string", "index":"not_analyzed"}
        }
    }
}
```

## Mapping a Multifield pt. 2
 Elasticsearch provides a multi_field type, which allows you to map the same field value to several core types. In this case, we're mapping the name field to a tokenized value (for text searching), as well a not analyzed field (for faceting and sorting).

```json
{
  "location" : {
        "properties" : {
            "name" : {
              "type" : "multi_field",
              "fields" : {
                "name":{"type":"string", "index":"analyzed"},
                "name_not_analyzed":{"type":"string", "index":"not_analyzed"}
              }
            }
        }
    }
}
```

##Sorting Multifield Strings

Sorting using our new unanalyzed field

`GET /wikipedia/locations/_search`

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

##Define all Mappings

 Now, let's define all the mappings we'll use for this demo

 `PUT /wikipedia_define_mappings/locations/_mapping`

```json
{
  "location" : {
        "properties" : {
            "coordinates" : {"type" : "geo_point"},
            "keyword" : {"type":"string", "index":"not_analyzed"},
            "name" : {
              "type" : "multi_field",
              "fields" : {
                "name":{"type":"string", "index":"analyzed"},
                "name_not_analyzed":{"type":"string", "index":"not_analyzed"}
              }
            }
        }
    }
}
```