## Rivers 


## What are rivers? 

* Services that automatically index data from various datasources
* Installed as plugins
* Run on one node in your cluster at a time


## Managing river plugins 

* Install like plugins
* Started on a cluster like so:

```
curl -XPUT 'localhost:9200/_river/my_river/_meta' -d '{
  "type" : "dummy"
}'
```
* Stopping:

```
curl -XDELETE 'localhost:9200/_river/my_river'
```


## Why use rivers? 

* Minimal effort to ensure that your index mirrors your database
* Simple failover in the cluster


## Why NOT use rivers? 

* Rivers do not distribute load
* Node failure can cause some data not to get indexed


## JDBC River Issues

* When rows are updated can be complex
   * Use *$job* and *$now* parameters to grab latest data
* Updating existing documents happens when _id field stays the same


## Recommendation

* Feed data externally to mitigate data loss
* Externally feeding threads can be coordinated via a message queue