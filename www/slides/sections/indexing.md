## Indexing


### Anatomy of a Request

```bash
curl -XPUT 'http://estalk.spantree.local:9200/wikipedia/location/1' -d '{
  "name": "Spantree Technology Group, LLC",
  "about" : "Spantree is a boutique, Chicago-based consultancy delivering intelligent, high quality software solutions for the web.",
  "lastUpdated":"2013-12-30T02:14:41+0000",
  "yearFounded":2009
}'
```

[API Example](http://estalk.spantree.local:9200/_plugin/marvel/sense/#02-indexing,S2.1)


### Automatic Mappings

Elasticsearch will guess the mappings for new fields it hasn't seen before

[API Example](http://estalk.spantree.local:9200/_plugin/marvel/sense/#02-indexing,S2.3)


### Update API

You can also update a document via script or "upsert"

[API Example](http://estalk.spantree.local:9200/_plugin/marvel/sense/#02-indexing,S2.5)


### Bulk API

You can also add/remove/update documents in bulk using the Bulk API. This is recommended for batch updates

[API Example](http://estalk.spantree.local:9200/_plugin/marvel/sense/#02-indexing,S2.9)


### Indexing advice

* Index asychronously
* Have a separate process that batches updates into Elasticsearch
* Use rivers cautiously (they're deprecated)
* Use updates when you can
* Be mindful of refresh intervals