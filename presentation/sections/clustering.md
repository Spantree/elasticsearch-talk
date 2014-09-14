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


### Shards and Replicas

* <em>Shard</em> - A slice of an index
    * Single Lucene instance 
    * Choose # carefully: can't be changed later
* <em>Replica</em> - Copy of a shard
    * Grow and shrink number as desired

Note: 
* Show configuration


### Master Nodes

* Master
    * Maintains "official" cluster state and applies any modifications
    * Distributes shards in cluster
* Not to be confused with primary replicas

Note: 
* Show configuration
* Any node can handle a query, including paging/sorting/collating results


### Master election with Zen

* Elasticsearch built-in discovery algorithm


### Zen: Multicast

* Default configuration
    * (Port 54328 broadcast to multicast group 224.2.2.4)
* Great for magically forming clusters
* Doesn't work well on EC2


### Zen: Unicast

* Specify list of IP addresses


### What happens when a node fails?

* When a Node Fails
    * If master failed, elect a new Master
    * Some replica shards promoted to primary shards


### Communicating with a cluster

* Client node: 
    * Bidirectional R/W connection
    * Can also be a data node
* Transport client
    * Unidirectional R/W connection


### Elasticsearch connections

* **Recovery (2)** - Index recovery
* **Bulk (3)** - Bulk operations
* **Reg (6)** - Normal queries
* **State (1)** - Cluster state read/write
* **Ping (1)** - Detecting missing nodes


### Automatic shard balancing

![Analysis phases](images/sharding-replica.svg)


### Indexing/getting a document

* **```shard = hash(id) % number_of_primary_shards```**
* This is why number of shards is not changeable


### Servicing a search query

![Query phases](images/query-steps.svg)


### Production clusters
* Some tips


### Split brain problem 
* A network can split in two and form two clusters with elected masters
    * Now there are two indexes that can have different content!


### Split brain problem 
![Query phases](images/split-brain.svg)


### Split brain solution(?)
* Have an odd number of nodes
* Elect new master when you can see n/2+1 of all nodes
* There are many ways this can still fail 
    * (but rarely does!)


### Dedicated masters

* Eligible masters and clients, but not data nodes
* Decreases querying/indexing load on masters


### AWS EC2 ZEN

* EC2 discovery plugin
    * Uses AWS API for unicast discovery
* Bonus: save snapshots to S3


### Shard allocation

* Don't place your primary and replica shards where you can lose them both!
* Shard allocation:

```yaml
node.rack_id: rack_one
cluster.routing.allocation.awareness.attributes: rack_id
```

