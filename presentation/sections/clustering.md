## Cluster Design

<!--
* Shards and replicas
* Master and slave nodes
* Discovery
    * Multicast
    * Unicast
* Automatic balancing
* Transport protocol
* How are requests directed?
* What happens when a node fails?
    * Split brain problem
* Designing your application for resiliency
    * Dedicated masters
    * Shard allocation
    * Efficiently indexing into the cluster
        * Bulk indexing
        * River plugins
* Tribes
-->


### Primary shard

* Where documents are indexed
* Quantity can only be set at index creation


### Replica shard

* Gets updates from primary shard
* Handles queries
* Grow and shrink as desired


### Master Node

* Maintains "official" cluster state and applies any modifications
* Distributes shards in cluster
* Does not necessarily have all the primary shards
* Does not necessarily coordinate all the queries


### Zen

* Elasticsearch built-in discovery algorithm


### Multicast Zen

* Great for magically forming clusters
* (Port 54328 broadcast to multicast group 224.2.2.4)
* Doesn't work well in some cases


### Zen: Unicast

* Specify list of IP addresses


### Client nodes

* Bidirectional R/W connection
* Can be a data node
* Port 9300
* Full mesh


### Transport client

* Unidirectional R/W connection
* Does not join cluster
* Port 9300


### Elasticsearch connections

* **Recovery (2)** - Index recovery
* **Bulk (3)** - Bulk operations
* **Reg (6)** - Normal queries
* **State (1)** - Cluster state read/write
* **Ping (1)** - Detecting missing nodes


### REST client

* HTTP
* Port 9200


### Balancing load


### Automatic shard balancing

![Analysis phases](images/sharding-replica.svg)


### Balancing document indexing

* **```shard = hash(id) % number_of_primary_shards```**
* This is why number of shards is not changeable


### Recovery

* If master failed, elect a new Master
* If primary replica failed, make another replica primary


### Servicing a search query

![Query phases](images/query-steps.svg)


### Split brain problem 
![Query phases](images/split-brain.svg)


### Split brain safeguard
* Have an odd number of nodes
* Can I see n/2+1 of all nodes?

```
discovery.zen.minimum_master_nodes: 2
```


### Load problem

* Master keeps getting overloaded and goes down
* Other master-eligible nodes under heavy load too
* Triggers a lot of instability


### Dedicated masters

* Eligible masters and clients, but not data nodes

```
node.master: true 
node.data: false
```

* Client-only data nodes

```
node.master: false ## or node.client: true
node.data: true
```

### On AWS 

* Use AWS Discovery Plugin
* Discover based on groups, IPs, tags
* Bonus: save snapshots to S3


