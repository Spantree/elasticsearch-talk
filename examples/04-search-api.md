# Search API

## Query String Search

Find the term "college" anywhere in the documents

`GET /wikipedia/_search`

```json
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

## Multiple Terms

Find the terms "lake" and "shore" anywhere in the documents.

`GET /wikipedia/_search`

```json
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

## Minimum Should Match

Find the terms "lake" and "shore" anywhere in the documents.  Both the terms should be present.

`GET /wikipedia/_search`

```json
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

## Field Boosting

Find the term "theater" anywhere in the documents,
boosting matches on name higher than matches on
description or about.

`GET /wikipedia/_search`

```json
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

## Boolean OR Queries

Find the term "theater" *or* "theatre" anywhere in the documents, boosting matches on name higher than matches on description or about.

`GET /wikipedia/_search`

```json
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

## Boolean AND Queries

Find the term "theater" *and* "theatre" anywhere in the documents, boosting matches on name higher than matches on description or about. This should be a smaller set.

`GET /wikipedia/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["name^2", "keywords^1.5", "description", "about"],
            "query": "theater AND theatre"
          }
        }
      ]
    }
  }
}
```

## Return subset of fields

Return only the name and keywords fields.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "keywords"],
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "fields": ["name^2", "keywords^1.5"],
            "query": "theater OR theatre"
          }
        }
      ]
    }
  }
}
```

## TODO: Match Query

## TODO: Multimatch

## TODO: Filters

## TODO: Explain

## Highlight Matches

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