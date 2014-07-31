## Cluster Design


### Example

![Analysis phases](images/sharding-replica.svg)


### Configuring a cluster with multicast

* Just works out the box (usually)
* Repeat the process on two machines on the same subnet
* They will (usually) discover each other via multicast
* Must have the same cluster name


### Configuring a cluster with explicit IPs

Modify `config/elasticsearch.yml`

```
discovery.zen.ping.multicast.enabled: false
discovery.zen.ping.unicast.hosts: ["192.168.0.250[9300-9400]", "192.168.0.251[9300-9400]"]
```


### Clustering: Sharding and Replication

* <em>Shard</em> - A slice of an index
    * More shards means better write performance
    * Single Lucene index (portion of Elasticsearch index)
* <em>Replica</em> - Copy of a shard
    * More replicas means faster queries


### Failover

* When a Node Fails
    * If Master Elect a new Master
    * Replicas are promoted to primary shards
    * Cluster status is yellow but operational


### Master Nodes

* Elected on a per-cluster basis and primarily responsible for coordination
* Keeps track of all the other nodes
* Is replaced by another master-eligible node if current master fails
* Routes new documents to data node holding the primary shard
* Handles collating responses from shards, doing sorting, pagination, etc 
* Nodes electable as master by setting `node.master: true` in `elasticsearch.yml` 


### Data nodes

* Holds one or more primary and replica shards
* Responsible for indexing data on its primary shards
* Responsible for querying data on its primary and replica shard
* Nodes eligible as data nodes by setting `node.data: true` in `elasticsearch.yml`


### When to use dedicated masters

* When you have critical clusters
* When you have high write or read throughput
* Always have an odd number to avoid split brain
* Still vulnerable to some [split brain issues](http://github.com/elasticsearch/elasticsearch/issues/2488)
* Improvements coming in 1.3.0 hopefully


### Shard allocation

* Happens during initial recovery, replica allocation, rebalancing, and node addition/removal
* Shard allocation awareness allows us to ensure that a primary shard and its replica will not be collocated to a node with the same value 


### Configuring shard allocation awareness

```yaml
node.rack_id: rack_one
cluster.routing.allocation.awareness.attributes: rack_id
```


### Planning for resiliency
              
* Prefer bulk updates when possible, buffering updates to reduce data loss
* Force a refresh at the as an ACK
* Use an external message queue (RabbitMQ, Kafka, etc) to feed events into Elasticsearch
* If you run into issues, consider using alternative discovery plugins (e.g. [sonian-zookeeper-plugin](https://github.com/sonian/elasticsearch-zookeeper))