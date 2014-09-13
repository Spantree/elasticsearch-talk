## Indexing


### Anatomy of a Request

```bash
curl -XPUT 'http://esdemo.local:9200/wikipedia/location/1' -d '{
  "name": "Spantree Technology Group, LLC",
  "about" : "Spantree is a boutique, Chicago-based consultancy delivering intelligent, high quality software solutions for the web.",
  "lastUpdated":"2013-12-30T02:14:41+0000",
  "yearFounded":2009
}'
```

http://esdemo.local:9200/_plugin/marvel/sense/#02-indexing,L5


### Automatic Mappings

![AutomaticMapping](images/automatic-mapping.png)              


### Create or Update Document

```bash
curl -XPUT 'http://esdemo.local:9200/wikipedia/location/1' -d '{
  "name": "Spantree Technology Group, LLC",
  "about" : "Spantree is a boutique, Chicago-based consultancy delivering intelligent, high quality software solutions for the web.",
  "lastUpdated":"2013-12-30T02:14:41+0000",
  "yearFounded":2009
}'
```

```bash

curl -XPOST 'http://esdemo.local:9200/wikipedia/location/' -d '{
  "name": "Spantree Technology Group, LLC",
  "about" : "Spantree is a boutique, Chicago-based consultancy delivering intelligent, high quality software solutions for the web.",
  "lastUpdated":"2013-12-30T02:14:41+0000",
  "yearFounded":2009
}'
```

http://esdemo.local:9200/_plugin/marvel/sense/#02-indexing,L46

### Update API

```bash
curl -XPOST 'http://esdemo.local:9200/wikipedia/location/1/_update' -d '{
  "script": "ctx._source.lastUpdated = date",
  "params": {
    "date": "2014-02-18T02:14:41+0000"
  }
}'
```

```bash
curl -XPOST 'http://esdemo.local:9200/wikipedia/location/1/_update' -d '{
  "doc": {
    "lastUpdated": "2014-02-18T02:14:41+0000"
  }
}'
```

http://esdemo.local:9200/_plugin/marvel/sense/#02-indexing,L28

### Bulk API

```bash
$ cat divvy.json

{"index": {"_type": "station", "_id": "119"}}
{"capacity": 15, "name": "Lake Park Ave & 56th St", "location": {"lat": 41.793242, "lon": -87.587782}}
{"index": {"_type": "station", "_id": "353"}}
{"capacity": 15, "name": "Ada St & Washington Blvd", "location": {"lat": 41.88283, "lon": -87.661206}}
```

```bash
curl -f -s -S -XPOST --data-binary "@divvy.json" http://esdemo.local:9200/divvy/_bulk
```

http://esdemo.local:9200/_plugin/marvel/sense/#02-indexing,L64
