# Mapping & Analysis

## Creating a new index with explicit mappings

`POST /wikipedia-mappings-simple/`

```json
{
  "mappings": {
    "locations": {
      "properties": {
        "name": {
          "type": "string"
        },
        "keywords": {
          "type": "string"
        },
        "wikipedia_numeric_id": {
          "type": "long"
        },
        "lastUpdated": {
          "type": "date"
        },
        "coordinates": {
          "type": "geo_point"
        }
      }
    }
  }
}
```

## Inserting a Few Documents

`POST /wikipedia-mappings-simple/_bulk`

```json
{"index":{"_id":"frontera_grill","_type": "locations"}}
{"name": "Frontera Grill","keywords": ["restaurants","chicago,illinois"],"about": "Frontera Grill is a Southwestern restaurant in Chicago, Illinois. It is owned by Rick Bayless. It opened in January 1987 and is located at 445 N. Clark Street in Chicago's River North neighborhood.","wikipedia_numeric_id": 7353370,"lastUpdated": "2012-04-30T02:14:41+0000","coordinates": [-87.630806,41.890575]}
{"index":{"_id":"allerton_hotel","_type": "locations"}}
{"name": "Allerton Hotel","keywords": ["hotels","chicago,illinois","landmarks","skyscrapers"],"geo_geometry_type": "Point","about": "The Allerton Hotel is a 25-story 360 foot (110 m) hotel skyscraper along the Magnificent Mile in the Near North Side community area of Chicago, Illinois.","wikipedia_numeric_id": 11221483,"coordinates": [-87.6238,41.8952]}
{"index":{"_id":"lane_technical_college_prep_high_school","_type": "locations"}}
{"name": "Lane Technical College Prep High School","keywords": ["chicago","public","schools","magnet","illinois","educational","institutions","established","in1908","chicago,illinois"],"about": "Albert G. Lane Technical College Preparatory High School (also known as Lane Tech), is a public, four-year, magnet high school located on the northwest side of Chicago.","wikipedia_numeric_id": 3616501,"lastUpdated": "2012-08-14T07:09:31+0000"}
```

## Reviewing the Mappings

`GET /wikipedia-mappings-simple/_mapping`

## Seeing How a Name Value Gets Analyzed

`GET /wikipedia-mappings-simple/_analyze?field=name&text=Lane Tech: College Prep High School`

## Updating the mappings

`PUT /wikipedia-mappings-simple/locations/_mapping`

```json
{
  "locations": {
    "properties": {
      "phone_number": {
        "type": "string"
      }
    }
  }
}
```

## Adding the Chicago History Museum

`PUT /wikipedia-mappings-simple/locations/chicago_history_museum`

```json
{
  "name": "Chicago History Museum",
  "phone_number": "(312) 642-4600"
}
```

## Trying to find the phone number in a different format

`GET /wikipedia-mappings-simple/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "phone_number": "312.642.4600"
          }
        }
      ]
    }
  }
}
```

## Adding a Proper Phone Number Mapping

`POST /wikipedia-mappings-phone/`

```json
{
  "settings": {
    "analysis": {
      "filter": {
        "digits_only": {
          "type": "pattern_replace",
          "pattern": "\\D",
          "replacement": ""
        }
      },
      "analyzer": {
        "phone_number": {
          "type": "custom",
          "tokenizer": "keyword",
          "filter": [
            "digits_only"
          ]
        }
      }
    }
  },
  "mappings": {
    "locations": {
      "properties": {
        "phone_number": {
          "type": "string",
          "analyzer": "phone_number"
        }
      }
    }
  }
}
```

## Testing Our New Field Mapping

`GET /wikipedia-mappings-phone/_analyze?field=phone_number&text=(312) 642-4600`

## Indexing the Chicago History Museum Again

`PUT /wikipedia-mappings-phone/locations/chicago_history_museum`

```json
{
  "name": "Chicago History Museum",
  "phone_number": "(312) 642-4600"
}
```

## Searching for the History Museum Again

`GET /wikipedia-mappings-phone/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "phone_number": "312.642.4600"
          }
        }
      ]
    }
  }
}
```

## TODO: Not analyzed

## TODO: Not stored

## TODO: Snowball Stemming

## TODO: Synonyms

## TODO: Edge NGrams

## TODO: Multi-Field

