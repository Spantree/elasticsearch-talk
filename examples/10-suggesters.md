# Suggesters

## Term suggester

`POST /wikipedia/_suggest `

```json
{
  "term_suggestion": {
    "text": "buildng",
    "term": {
      "field": "description"
    }
  }
}
```

## Phrase suggester

`POST /wikipedia/_suggest `

```json
{
  "text": "high risk buildng",
  "simple_phrase": {
    "phrase": {
      "field": "description",
      "gram_size": 2,
      "real_word_error_likelihood": 0.95,
      "confidence": 1,
      "max_errors": 100,
      "size": 1,
      "analyzer": "standard",
      "shard_size": 5,
      "direct_generator": [
        {
          "field": "description",
          "suggest_mode": "popular",
          "max_edits": 2,
          "min_word_len": 4,
          "max_inspections": 5,
          "min_doc_freq": 0,
          "max_term_freq": 0
        }
      ]
    }
  }
}
```

## Create completion suggestions index

`PUT /suggestions `

## Create completion suggestion mapping

`PUT /suggestions/suggestion/_mapping `

```json
{
  "suggestion" : {
        "properties" : {
            "name" : { "type" : "string" },
            "suggest" : { 
              "type" : "completion",
              "index_analyzer" : "simple",
              "search_analyzer" : "simple",
              "payloads" : true
            }
        }
    }
}
```

## Create completion suggestion 1

`PUT /suggestions/suggestion/1 `

```json
{
    "name" : "Cedric Hurst",
    "suggest" : {
        "input": [ "Cedster", "The Ced", "C-Man", "Hurst the Not So First", "Software Engineer" ],
        "output": "Cedric",
        "payload" : { "title" : "Principal" },
        "weight" : 37
    }
}
```

## Create completion suggestion 2

`PUT /suggestions/suggestion/2 `

```json
{
    "name" : "Kevin Greene",
    "suggest" : {
        "input": [ "Kev", "KG", "Greene", "Michigan", "Software Engineer" ],
        "output": "Kevin",
        "payload" : { "title" : "Senior Software Engineer" },
        "weight" : 101
    }
}
```

## Get completion suggestion

`POST /suggestions/_suggest `

```json
{
  "completion_suggestion": {
    "text": "software",
    "completion": {
      "field": "suggest"
    }
  }
}
```

## Get fuzzy completion suggestion

`POST /suggestions/_suggest `

```json
{
  "completion_suggestion": {
    "text": "mchgan",
    "completion": {
      "field": "suggest",
      "fuzzy" : {
        "fuzziness" : 2
      }
    }
  }
}
```

## Create context suggestion type

`PUT suggestions/conference/_mapping `

```json
{
    "conference": {
        "properties": {
            "name": {
                "type": "string"
            },
            "suggestion": {
                "type": "completion",
                "context": {
                    "location": {
                        "type": "geo",
                        "precision": "500km",
                        "neighbors": true,
                        "default": "u33"
                    }
                }
            }
        }
    }
}
```

## Create Goto Chicago 2014 context suggestion

`PUT suggestions/conference/1`

```json
{
    "name": "Goto Chicago 2014",
    "suggestion": {
        "input": [
            "goto",
            "chicago",
            "tech conference"
        ],
        "output": "Goto Chicago 2014",
        "context": {
            "location": {
                "lat": 41.8337329,
                "lon": -87.7321555
            }
        }
    }
}
```

## Create Strangeloop 2014 context suggestion

`PUT suggestions/conference/2`

```json
{
    "name": "Strangeloop 2014",
    "suggestion": {
        "input": [
            "strange",
            "loop",
            "tech conference"
        ],
        "output": "Strangeloop 2014",
        "context": {
            "location": {
                "lat": 38.6537065,
                "lon": -90.2477908
            }
        }
    }
}
```

## Suggest nearby

`POST suggestions/_suggest`

```json
{
    "context_suggestion": {
        "text": "tech",
        "completion": {
            "field": "suggestion",
            "size": 10,
            "context": {
                "location": {
                    "lat": 39.626072,
                    "lon": -90.0769822
                }
            }
        }
    }
}
```