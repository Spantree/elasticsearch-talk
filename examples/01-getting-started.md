# Getting Started

## Getting Server Status

Executing an HTTP GET request to the root of the Elasticsearch
web server will give you a server status as JSON.

`GET /`

## Indexing a single document

Now, we will insert a single document into Elasticsearch. Note that
we don't need to create an index or type, it gets created automatically if it doesn't already exist.  Elasticsearch will also try to guess the types for document fields based on the initial JSON payload.

`PUT /getting-started/locations/frontera_grill`

```json
{
    "name": "Frontera Grill",
    "description": "Frontera Grill is a Mexican restaurant in Chicago, Illinois. It is owned by Rick Bayless. It opened in January 1987 and is located at 445 N. Clark Street in Chicago's River North neighborhood. In 2007, Frontera Grill won the James Beard Foundation's \"Outstanding Restaurant\" award, designating it the best restaurant in the U.S.",
    "url": "http://en.wikipedia.org/wiki/Frontera_Grill",
    "keywords": [
        "restaurants",
        "chicago,illinois"
    ],
    "wikipedia_numeric_id": 7353370,
    "lastUpdated": "2012-07-12T10:37:44+0000"
}
```

## Fetching our document

You can retrieve a single document by its ID with a simple HTTP GET request.

`GET /getting-started/locations/frontera_grill`

## Finding all documents

We can also execute a request to get all documents in this index.  At this point, there should only be one.

`GET /getting-started/_search`

```json
{
  "query": {
    "bool": {
      "must": [
        {
    	    "match_all" : { }
        }
      ]
    }
  }
}
```

## Reviewing the Mappings

We can also peek at the mappings Elasticsearch automatically generated for the location document type.

`GET /getting-started/locations/_mapping`