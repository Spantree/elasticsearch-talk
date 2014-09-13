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

`PUT /suggestions `

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

`PUT /suggestions/suggestion/1 `

```json
{
    "name" : "Nevermind",
    "suggest" : {
        "input": [ "Nevermind", "Nirvana" ],
        "output": "Nirvana - Nevermind",
        "payload" : { "artistId" : 2321 },
        "weight" : 34
    }
}
```

`POST /suggestions/_suggest `

```json
{
  "completion_suggestion": {
    "text": "n",
    "completion": {
      "field": "suggest"
    }
  }
}
```

`POST /suggestions/_suggest `

```json
{
  "completion_suggestion": {
    "text": "n",
    "completion": {
      "field": "suggest",
      "fuzzy" : {
        "fuzziness" : 2
      }
    }
  }
}
```