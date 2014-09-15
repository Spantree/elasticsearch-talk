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

## Let's try to get Elasticsearch to infer an integer mapping

`PUT /spantree-mappings/employee/andrea`

```json
{
  "dogs": 1
}
```

## We can add another employee with a different setup

`PUT /spantree-mappings/employee/allie`
```json
{
  "dogs": ["Kirby"]
}
```

## Seeing How a Name Value Gets Analyzed

`GET /wikipedia-mappings-simple/_analyze?field=name&text=Lane Tech: College Prep High School`

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

## Reviewing the Mapping for Phone Number

`GET /wikipedia-mappings-simple/_mapping`

## Analyzing the Indexed Phone Number

`GET /wikipedia-mappings-simple/_analyze?field=phone_number&text=(312) 642-4600`

## Analyzing the Queried Phone Number

`GET /wikipedia-mappings-simple/_analyze?field=phone_number&text=312.642.4600`

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

## Analyzing the Indexed Phone Number Again

`GET /wikipedia-mappings-phone/_analyze?field=phone_number&text=(312) 642-4600`

## Analyzing the Queried Phone Number Again

`GET /wikipedia-mappings-phone/_analyze?field=phone_number&text=312.642.4600`

## Indexing the Chicago History Museum with the Proper Mappings

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


## Stemming

`POST /wikipedia-mappings-stemmed/`

```json
{
  "settings": {
    "analysis": {
      "filter": {
        "stemmed": {
          "type": "snowball",
          "language": "English"
        }
      },
      "analyzer": {
        "stemmed": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": [
            "standard",
            "lowercase",
            "stemmed"
          ]
        }
      }
    }
  },
  "mappings": {
    "essays": {
      "properties": {
        "description": {
          "type": "string",
          "analyzer": "stemmed"
        }
      }
    }
  }
}
```

## Testing Our Stemmed Field

`GET /wikipedia-mappings-stemmed/_analyze?field=description&text=Spantree is one of many companies at the Chicago Java Users Group that are looking for great developers.`

## Working with Synonyms

`POST /wikipedia-mappings-synonyms/`

```json
{
  "settings": {
    "analysis": {
      "filter": {
        "first_name_synonyms": {
          "type": "synonym",
          "synonyms": [
            "susan, susie",
            "ed, edward",
            "tom, thomas"
          ]
        }
      },
      "analyzer": {
        "first_name_synonyms": {
          "type": "custom",
          "filter": [
            "standard",
            "asciifolding",
            "lowercase",
            "stop",
            "first_name_synonyms"
          ],
          "tokenizer": "standard"
        }
      }
    }
  },
  "mappings": {
    "essays": {
      "properties": {
        "author": {
          "type": "string",
          "analyzer": "first_name_synonyms"
        }
      }
    }
  }
}
```

## Testing Out Our Synonym Field

`GET /wikipedia-mappings-synonyms/_analyze?field=author&text=Thomas Jefferson`

## Working with Edge N-Grams

`POST /wikipedia-mappings-edgengrams/`

```json
{
  "settings": {
    "analysis": {
      "filter": {
        "edge_left": {
          "type": "edgeNGram",
          "side": "front",
          "min_gram": 1,
          "max_gram": 20
        }
      },
      "analyzer": {
        "edge_left": {
          "type": "custom",
          "filter": [
            "standard",
            "asciifolding",
            "lowercase",
            "edge_left"
          ],
          "tokenizer": "standard"
        }
      }
    }
  },
  "mappings": {
    "essays": {
      "properties": {
        "title": {
          "type" : "string",
          "index_analyzer" : "edge_left",
          "search_analyzer" : "standard",
          "include_in_all" : false
        }
      }
    }
  }
}
```

## Testing Out Our Edge N-Gram Field

`GET /wikipedia-mappings-edgengrams/_analyze?field=title&text=Lorem ipsum dolor`

## Putting It All Together With Multi-fields

`POST /wikipedia-mappings-multifield`

```json
{
  "settings": {
    "analysis": {
      "filter": {
        "edge_left": {
          "type": "edgeNGram",
          "side": "front",
          "min_gram": 1,
          "max_gram": 20
        },
        "first_name_synonyms": {
          "type": "synonym",
          "synonyms": [
            "susan, susie",
            "ed, edward",
            "tom, thomas"
          ]
        },
        "stemmed": {
          "type": "snowball",
          "language": "English"
        }
      },
      "analyzer": {
        "edge_left": {
          "type": "custom",
          "filter": [
            "standard",
            "asciifolding",
            "lowercase",
            "stop",
            "edge_left"
          ],
          "tokenizer": "standard"
        },
        "stemmed": {
          "type": "custom",
          "filter": [
            "standard",
            "asciifolding",
            "lowercase",
            "stop",
            "stemmed"
          ],
          "tokenizer": "standard"
        },
        "first_name_synonyms": {
          "type": "custom",
          "filter": [
            "standard",
            "asciifolding",
            "lowercase",
            "stop",
            "first_name_synonyms"
          ],
          "tokenizer": "standard"
        }
      }
    }
  },
  "mappings": {
    "essays": {
      "properties": {
        "name": {
          "type": "multi_field",
          "fields": {
            "name": {
              "type": "string",
              "index": "analyzed"
            },
            "edge" : {
              "type" : "string",
              "index_analyzer" : "edge_left",
              "search_analyzer" : "standard",
              "include_in_all" : false
            },
            "stemmed" : {
              "type" : "string",
              "analyzer" : "stemmed",
              "include_in_all" : false
            }
          }
        },
        "author": {
          "type": "multi_field",
          "fields": {
            "author": {
              "type": "string",
              "index": "analyzed"
            },
            "edge" : {
              "type" : "string",
              "index_analyzer" : "edge_left",
              "search_analyzer" : "standard",
              "include_in_all" : false
            },
            "stemmed" : {
              "type" : "string",
              "analyzer" : "stemmed",
              "include_in_all" : false
            },
            "synonyms": {
              "type": "string",
              "index_analyzer" : "first_name_synonyms",
              "search_analyzer" : "standard",
              "include_in_all": false
            }
          }
        }
      }
    }
  }
}
```

## Adding an Essay to Our Multi-Field Index

`PUT /wikipedia-mappings-multifield/essays/rights_of_british_america`

```json
{
  "name": "A Summary View of the Rights of British America",
  "author": "Thomas Jefferson"
}
```

## Handling Type-Ahead Searches with Edge N-Grams

`GET /wikipedia-mappings-multifield/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "righ",
            "fields": [
              "name",
              "name.edge",
              "name.stemmed",
              "author",
              "author.edge",
              "author.stemmed",
              "author.synonyms"
            ]
          }
        }
      ]
    }
  },
  "highlight": {
      "fields": {
          "name": {},
          "name.edge": {},
          "name.stemmed": {},
          "author": {},
          "author.edge": {},
          "author.stemmed": {},
          "author.synonyms": {}
      }
  }
}
```

## Handling Word Variations with Stemming

`GET /wikipedia-mappings-multifield/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "summaries",
            "fields": [
              "name",
              "name.edge",
              "name.stemmed",
              "author",
              "author.edge",
              "author.stemmed",
              "author.synonyms"
            ]
          }
        }
      ]
    }
  },
  "highlight": {
      "fields": {
          "name": {},
          "name.edge": {},
          "name.stemmed": {},
          "author": {},
          "author.edge": {},
          "author.stemmed": {},
          "author.synonyms": {}
      }
  }
}
```

## Finding Tom Jefferson with Name Synonyms

`GET /wikipedia-mappings-multifield/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "tom jefferson",
            "fields": [
              "name",
              "name.edge",
              "name.stemmed",
              "author",
              "author.edge",
              "author.stemmed",
              "author.synonyms"
            ]
          }
        }
      ]
    }
  },
  "highlight": {
      "fields": {
          "name": {},
          "name.edge": {},
          "name.stemmed": {},
          "author": {},
          "author.edge": {},
          "author.stemmed": {},
          "author.synonyms": {}
      }
  }
}
```