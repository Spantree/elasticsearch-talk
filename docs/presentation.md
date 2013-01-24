# ElasticSearch

> You know, for Search

## Title Page

## Cool stuff

* RESTful interface
* Uses JSON
* Based on Lucene
* Wicked fast
* Wicked configurable
* Wicked scalable
* Open Source

## Not so cool stuff

* Documentation a "work in progress"
* No field collapsing (yet)
* Nested facets not (yet) supported
* No built-in spellchecker

## Demo time

### What We'll Need

* VirtualBox
* Vagrant

http://howdoesvagrantwork.com/

* A text editor
* A web browser
* Curl

### Wikipedia Location Searcher

#### Infochimps

> Show Screenshot of Data Extract

#### Document Structure

```javascript
{
	"url": "http://en.wikipedia.org/wiki/Frontera_Grill",
	...
	"keywords": ["restaurants", "chicago,illinois"],
	"about": "Frontera Grill is a Southwestern restaurant in Chicago, Illinois..",
	"description": "Frontera Grill is a Mexican restaurant in Chicago, Illinois...",
	"wikipedia_id": "Frontera Grill",
	"wikipedia_numeric_id": 7353370,
	"name": "Frontera Grill",
	"coordinates": [-87.630806, 41.890575],
	"external_links": ["http://rdf.freebase.com/ns/m/06x4q7"]
}
```

### Indexing

#### Push one location documents

```bash
curl -XPOST http://localhost:9200/wikipedia/locations -d '{
    "geo_geometry_type": "Point",
    "keywords": [
        "restaurants",
        "chicago,illinois"
    ],
    "external_links": [
        "http://rdf.freebase.com/ns/m/06x4q7"
    ],
    "about": "Frontera Grill is a Southwestern restaurant in Chicago, Illinois. It is owned by Rick Bayless. It opened in January 1987 and is located at 445 N. Clark Street in Chicago's River North neighborhood. In 1994, Frontera Grill was ranked Chicago's third-best casual restaurant by the International Herald Tribune. In 2007, Frontera Grill won the James Beard Foundation's \"Outstanding Restaurant\" award, designating it the best restaurant in the U.S.",
    "lastUpdated": "2012-04-30T02:14:41+0000",
    "wikipedia_id": "Frontera Grill",
    "wikipedia_numeric_id": 7353370,
    "url": "http://en.wikipedia.org/wiki/Frontera_Grill",
    "_type": "encyclopedic.wikipedia.wikipedia_article",
    "_id": "frontera_grill",
    "md5id": "63709e0df3dbb92057d9d96e118f3045",
    "description": "Frontera Grill is a Mexican restaurant in Chicago, Illinois. It is owned by Rick Bayless. It opened in January 1987 and is located at 445 N. Clark Street in Chicago's River North neighborhood. In 2007, Frontera Grill won the James Beard Foundation's \"Outstanding Restaurant\" award, designating it the best restaurant in the U.S.",
    "name": "Frontera Grill",
    "_domain_id": 7353370,
    "contained_in": {
        "core_based_stat_areas": "16980",
        "combined_stat_areas": "176",
        "cities": "1714000",
        "counties": "17031",
        "census_tracts": "17031081700",
        "postal_codes": "60654",
        "states": "il",
        "sen_legislative_dist_uppers": "17003",
        "countries": "us"
    },
    "coordinates": [
        -87.630806,
        41.890575
    ]
}'
```

### Push all location documents (one by one)

```bash
for f in elasticsearch-talk/presentation/data/location_*
do
	echo "Posting ${f}"
	curl -XPOST curl -XPOST http://localhost:9200/wikipedia/locations -d @${f}
done
```

### Push all location documents in bulk

```bash
curl -XPUT 'http://192.168.80.100:9200/wikipedia/location/_bulk' --data-binary '@elasticsearch-talk/presentation/data/bulk.json'
```

### Querying

#### Basic Full-Text

##### Search for "college"

```javascript
{
  "query": {
    "bool": {
      "must": [{
        "query_string": {
          "query": "college"
        }
      }]
    }
  }
}
```
##### Search for "lake shore"

```javascript
{
  "query": {
    "bool": {
      "must": [{
        "query_string": {
          "query": "lake shore"
        }
      }]
    }
  }
}
```

##### Search for lake shore (strict)

```javascript
{
  "query": {
    "bool": {
      "must": [{
        "query_string": {
          "query": "lake shore",
          "minimum_should_match": "100%"
        }
      }]
    }
  }
}
```

##### Search for theater

```javascript
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "theater"
          }
        }
      ]
    }
  }
}
```


##### Search for theater (boost name and keywords)

```javascript
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["name^2", "keywords^1.5", "description", "about"],
            "query": "theater",
            "minimum_should_match": "100%"
          }
        }
      ]
    }
  }
}
```

##### Search for theater (boolean query string)

```javascript
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["name^2", "keywords^1.5", "description", "about"],
            "query": "theater OR theatre"
          }
        }
      ]
    }
  }
}
```

#### Highlighting

```javascript
{
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
  "highlight": {
  	"fields": {
  		"name": {},
  		"description": {},
  		"name": {}
  	}
  }
}
```

#### Paging

#### Size

```javascript
{
  "query": {
    "bool": {
      "must": [{
        "query_string": {
	      "query": "chicago"
	    }
	  }]
    }
  },
  "size": 10
}
```

```javascript
{
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
  "size": 50
}
```

#### From

```javascript
{
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
  "size": 10,
  "from": 0
}
```

```javascript
{
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
  "size": 10,
  "from": 10
}
```

```javascript
{
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
  "size": 10,
  "from": 20
}
```

#### Scrolling

```bash
curl -XGET 'http://localhost:9200/wikipedia/location/_search?scroll=5m' -d ...
```

```javascript
{
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
  "size": 10,
  "from": 0
}
```

```bash
curl -XGET 'http://localhost:9200/wikipedia/location/_search/scroll?scroll=5m&scroll_id=cXVlcnlUaGVuRmV0Y2g7NTs0MzE6UFFrSDR6WjJRS09qcnk4c0R1UkZmUTs0MzI6UFFrSDR6WjJRS09qcnk4c0R1UkZmUTs0MzQ6UFFrSDR6WjJRS09qcnk4c0R1UkZmUTs0MzM6UFFrSDR6WjJRS09qcnk4c0R1UkZmUTs0MzU6UFFrSDR6WjJRS09qcnk4c0R1UkZmUTswOw==
```

#### Sort

##### By date

```javascript
{
  "query": {
    "bool": {
      "must": [{
        "query_string": {"query": "chicago"}
      }]
    }
  },
  "sort": ["lastUpdated"]
}
```

#### Multiple fields

```javascript
{
  "query": {
    "bool": {
      "must": [{
        "query_string": {"query": "chicago"}
      }]
    }
  },
  "sort": ["lastUpdated"]
}
```

#### By text

```javascript
{
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
  "sort": [{"name":"desc"}],
  "size": 100
}
```

> DOH!

#### By distance

```javascript
{
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
        "coordinates": [
          41.884445,
          -87.647901
        ],
        "order": "asc",
        "unit": "mi"
      }
    }
  ],
  "size": 100
}
```

> DOH!

#### Mapping fields

* Types
  * string, integer/long, float, double, boolean, null
  * Array
  * JSON Object
  * geo_point, geo_shape
  * Nested
    * Nested docs that can be searched individually and easily joined to parent document
  * Attachment - base64 type
* Secondary fields (include_in_all: false)
* Analyzers per field
* Mapping changes try to be made automatically, but may require reindex 


#### Defining a geo_point mapping

* geo_point mapping can parse several different formats (array of two doubles here)
* We'll just delete and reinsert our data...

```bash 
curl -XDELETE 'http://192.168.80.100:9200/wikipedia/' 
curl -XPUT 'http://192.168.80.100:9200/wikipedia/' 
curl -XPUT 'http://192.168.80.100:9200/wikipedia/location/_mapping' -d '{
  "location" : {
        "properties" : {
            "coordinates" : {"type" : "geo_point"}
        }
    }
}'

curl -XPUT 'http://192.168.80.100:9200/wikipedia/location/_bulk' --data-binary '@elasticsearch-talk/presentation/data/bulk.json'
```
* Now we can run our distance query!

#### Defining a 'not analyzed' field

```
curl -XPUT 'http://192.168.80.100:9200/wikipedia/location/_mapping' -d '{
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

### Running a sorted query against it

```javascript
{
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
      "name_not_analyzed": "asc"
    }
  ],
  "size": 100
}

```

#### Facets (Terms)

```javascript
{
  "query": {
    "query_string": {
      "query": "college*"
    }
  },
  "facets": {
    "tags": {
      "terms": {
        "field": "name"
      }
    }
  }
}
```

#### Facets (Distance)
```javascript
{
  "query": {
    "match_all": {}
  },
  "facets": {
    "geo1": {
      "geo_distance": {
        "coordinates": [
          41.884445,
          -87.647901
        ],
        "ranges": [
          {
            "from": 14800,
            "to": 14810
          },
          {
            "from": 14810,
            "to": 14820
          },
          {
            "from": 14820,
            "to": 14830
          },
          {
            "from": 14830
          }
        ]
      }
    }
  }
}
```

#### Filter (Distance and Query)

```javascript
{
  "query": {
    "filtered": {
      "query": {
        "match_all": {}
      },
      "filter": {
        "and": [
          {
            "query": {
              "query_string": {
                "query": "college OR school"
              }
            }
          },
          {
            "geo_distance": {
              "distance": "1495km",
              "coordinates": {
                "lat": 40,
                "lon": -70
              }
            }
          }
        ]
      }
    }
  }
}
```

### Analysis (defining an analyzer)

* Analyzers can be defined dynamically or via the configuration yaml

```bash
curl -XDELETE 'http://192.168.80.100:9200/wikipedia/'
curl -XPUT 'http://192.168.80.100:9200/wikipedia/' -d'{
  "index": {
      "analysis": {
        "analyzer": {
          "lower_keyword": {
            "type": "custom",
            "filter": "lowercase",
            "tokenizer": "keyword"
          }
        }
      }
    }
  }
}'
```

### Analysis (specifying an analyzer in the mapping)
* Re-map everything
* Define a "name_lower" field that we can sort on

```bash
curl -XPUT 'http://192.168.80.100:9200/wikipedia/location/_mapping' -d'{
    "location": {
      "properties": {
        "coordinates": {
          "type": "geo_point"
        },
        "name": {
          "type": "multi_field",
          "fields": {
            "name": {
              "type": "string",
              "index": "analyzed"
            },
            "name_lower": {
              "type": "string",
              "index_analyzer": "lower_keyword",
              "search_analyzer": "standard"
            },
            "name_not_analyzed": {
              "type": "string",
              "index": "not_analyzed"
            }
          }
        }
      }
    }
  
}'
```

### Analysis (Using the field for sorting)

```javascript
{
  "fields": [
    "name"
  ],
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
      "name_lower": "desc"
    }
  ],
  "size": 100
}
```


### Multi-Tenant

* Create two indexes
* Search across them



### Scaling

#### Discovery

#### Shards

### Plugins (Head)

### Lucene Internals

## Stuff We Didn't Cover

### Querying Multiple Types

### Highlighting

### River Plugins

### Percolating