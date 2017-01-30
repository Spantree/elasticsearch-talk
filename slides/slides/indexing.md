## Indexing

---

### Anatomy of a Request

```bash
curl -XPUT 'http://localhost:9200/wikipedia/location/1' -d '{
  "name": "Spantree Technology Group, LLC",
  "about": "We build smart software for the web.",
  "lastUpdated": "2013-12-30T02:14:41+0000",
  "yearFounded": 2009
}'
```

[Basic Indexing](sense://indexing.sense)

---

### Automatic Mappings

Elasticsearch will guess the mappings for new fields it hasn't seen before

[Automatic Mappings in Action](sense://indexing.sense#L15)

---

### Update API

You can also update a document via script or "upsert"

[Update Examples](sense://indexing.sense#L31)

---

### Bulk API

You can also add/remove/update documents in bulk using the Bulk API. This is recommended for batch updates

[Bulk API Examples](sense://indexing.sense#L66)

---

### Indexing advice

* Index asynchronously (via [CQRS](https://martinfowler.com/bliki/CQRS.html) if possible)
* Have a separate process that batches updates into Elasticsearch
* Use updates when you can
* Be mindful of refresh intervals
