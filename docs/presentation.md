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
curl -XPUT 'http://192.168.50.100:9200/wikipedia/location/_bulk' --data-binary '@elasticsearch-talk/presentation/data/bulk.json'
```

### Querying

#### Basic Full-Text

##### Search for "college"

```javascript
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "college"
          }
        }
      ]
    }
  }
}
```
##### Search for "lake shore"

```javascript
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "lake shore"
          }
        }
      ]
    }
  }
}
```

##### Search for lake shore (strict)

```javascript
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "lake shore",
            "minimum_should_match": "100%"
          }
        }
      ]
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
            "fields": ["name^2", "keywords^1.5", "description", "about"],
            "query": "theater OR theatre"
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
      "must": [
        {
          "query_string": {
            "query": "chicago"
          }
        }
      ]
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
  "sort": ["_name"],
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

### Mapping

#### Mapping keyword fields

* Dates types/formats
* Store/No Store
* Secondary fields
	* Facet keyword fields
	* EgdeNGrams





#### Facet

* Keywords



* Distance

#### Range Filters

* Distance

### Updating/Versioning

* Partial updates
* Go back in time

### Multi-Tenant

* Create two indexes
* Search across them



### Analysis

* Keyword tokenizers
* EgdeNGrams
* Synonym filters
* Regex replacement

#### Modify Mapping

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