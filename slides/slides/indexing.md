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

### Consistency

* Refresh intervals control how often newly indexed data is made available for search
* New segments are created in the file system on each refresh
* Smaller segments eventually merged with bigger ones
* Segments are replicated between primaries and replicas
* Queries can be run as sync (default), primary only or async

---

### Transaction Log

* New insert/update/delete operations are written to a write-ahead log
* In the event of segment corruption or node failure, the write-ahead log can be replayed

---

### Segments

* Elasticsearch index consists of shards
* Shard consists of Lucene index
* Lucene index consists of segments
* Segments consist of files

---

### Segment Hierarchy

![Segment Hierarchy](images/diagrams/segment-hierarchy.jpeg#diagram)

---

### Segment File Structure

![Segment File Structure](images/diagrams/segment-file.png#diagram)

[More Detail on Lucene Files](https://lucene.apache.org/core/3_0_3/fileformats.html#tis)

---

### Merging

To avoid an infinitely growing number of tiny segments, smaller segment files merge with larger ones.

![Merge flow](images/diagrams/merge-flow.png#plain)

---

### Merging in Motion

![Concurrent Merge Animation](images/animations/lucene-merge-concurrent.gif#diagram)

---

### Tiered Merging in Motion

![Tiered Merge Animation](images/animations/lucene-merge-tiered.gif#diagram)

---

### Indexing advice

* Index asynchronously (via [CQRS](https://martinfowler.com/bliki/CQRS.html) if possible.
* Have a separate process that batches updates into Elasticsearch.
* Use the bulk API when possible.
* Use updates when you can.
* Be mindful of refresh intervals.

---

### Performance Tuning

* More often than not, you are fine with only one shard.
* Increase shards when you need more indexing throughput.
* Increase replicas when you need more query throughput.
