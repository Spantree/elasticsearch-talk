# Search API

## Searching with Query String

Find the term "college" anywhere in the documents

`GET /wikipedia/_search`

```json
{
    "query": {
      "query_string": {
          "query": "college"
        }
    }
}
```

## Searcing for Multiple Terms

Find the terms "lake" and "shore" anywhere in the documents.

`GET /wikipedia/_search`

```json
{
  "query": {
    "query_string": {
      "query": "lake shore"
    }
  }
}
```

## Adding Minimum Should Match

Find the terms "lake" and "shore" anywhere in the documents.  Both the terms should be present.

`GET /wikipedia/_search`

```json
{
  "query": {
    "query_string": {
      "query": "lake shore",
      "minimum_should_match": "100%"
    }
  }
}
```

## Searching a Subset of Fields

`GET /wikipedia/_search`

```json
{
  "query": {
    "query_string": {
      "fields": ["name", "keywords"],
      "query": "theater OR theatre"
    }
  }
}
```

## Returning subset of fields

Return only the name and keywords fields.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords"],
  "query": {
    "query_string": {
      "fields": ["name", "keywords"],
      "query": "theater OR theatre"
    }
  }
}
```

## Searching with Boolean Syntax

Find the term "theater" and "theatre" anywhere in the documents.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords", "description"],
  "query": {
    "query_string": {
      "fields": ["name", "keywords", "description"],
      "query": "theater AND theatre"
    }
  }
}
```

## Excluding Results

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords", "description"],
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["name", "keywords", "description"],
            "query": "theater OR theatre"
          }
        }
      ],
      "must_not": [
        {
          "query_string": {
            "fields": ["name"],
            "query": "theatre"
          }
        }
      ]
    }
  }
}
```

## Narrowing Results

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords", "description"],
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["name", "keywords", "description"],
            "query": "theater OR theatre"
          }
        },
        {
          "query_string": {
            "query": "pier"
          }
        }
      ]
    }
  }
}
```

## Using Should Clauses

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords", "description"],
  "query": {
    "bool": {
      "should": [
        {
          "query_string": {
            "fields": ["name", "keywords", "description"],
            "query": "theater OR theatre"
          }
        },
        {
          "query_string": {
            "query": "pier"
          }
        }
      ]
    }
  }
}
```

## Highlighting Matched Terms

Search for the term "Chicago" and highlight matches.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "description"],
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
          "description": {}
      }
  }
}
```

## Explaining Results

`GET /wikipedia/locations/chicago_shakespeare_theater/_explain`

```json
{
    "query": {
        "query_string": {
            "fields": [
                "description"
            ],
            "query": "navy^3 pier^2 place^4"
        }
    }
}
```

## Field Boosting

Find the term "theater" anywhere in the documents,
boosting matches on name higher than matches on
description or about.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords", "about"],
  "query": {
    "query_string": {
      "fields": ["name^2", "keywords^1.5", "about"],
      "query": "theater",
      "minimum_should_match": "100%"
    }
  }
}
```

## Scripted scoring

Double the score of each document

`GET /wikipedia/_search`

```json
{
    "fields": [
        "name",
        "keywords",
        "about"
    ],
    "query": {
      "function_score": {
          "query": {
              "query_string": {
                  "fields": [
                      "name",
                      "keywords",
                      "about"
                  ],
                  "query": "theater",
                  "minimum_should_match": "100%"
              }
          },
          "script_score": {
            "script": "_score * 2",
            "lang": "groovy"
          }
      }
    }
}
```

## Term Filtering

`GET /wikipedia/_search`

```json
{
  "query": {
    "match_all": {}
  },
  "filter": {
    "term" : {
      "name" : ["theater", "theatre"]
    }
  }
}
```

## Geo-Distance Filtering

`GET /divvy/station/_search`

```json
{
  "query": {
    "match_all": {}
  },
  "filter": {
    "geo_distance" : {
      "distance": "1mi",
      "location" : {
        "lat": 41.886732,
        "lon": -87.655979
      }
    }
  }
}
```