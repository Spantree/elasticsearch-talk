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

## Reviewing the Mappings

We can also peek at the mappings Elasticsearch automatically generated for the location document type.

`GET /getting-started/locations/_mapping`