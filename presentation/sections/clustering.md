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
    * Choose carefully: can't be changed later
* <em>Replica</em> - Copy of a shard
    * Grow and shrink number as desired

Note: 
* Show configuration


### Shard Illustration?
<div class="shard-illustration"></div>


### Master Nodes

* Master
    * Maintains "official" cluster state and applies any modifications
    * Distributes shards in cluster
* Not to be confused with master replicas

Note: 
* Show configuration
* Any node can handle a query, including paging/sorting/collating results


### Zen

* Elasticsearch built-in discovery algorithm


### Zen: Multicast

* Default configuration
    * Port 54328 broadcast to multicast group 224.2.2.4
* Great for magically forming clusters
* Doesn't work well on EC2


### Zen: Unicast

* Specify list of IP addresses


### Joining a cluster

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


### What happens when a node fails?

* When a Node Fails
    * If Master failed, elect a new Master
        * Sort eligible nodes, pick first (?!)
    * Some replica shards promoted to primary shards


### Routing a document request

* GET ```/index/type/id```
* ```shard = hash(id) % number_of_primary_shards```
    * This is why number of shards is not changeable


### Executing a common search query
1. Issue query to appropriate replica/master shard holders in the cluster
2. Each replica finds documents and calculates their scores
3. Each replica sends back scores and other metadata
4. Merge all in a priority queue and prune
5. Retrieve actual documents from each shard


### Split brain problem 
* A network can split in two and form two clusters with elected masters
    * Now there are two indexes that can have different content!


### Split brain solution(?)
* Have an odd number of nodes
* Elect new master when you can see n/2+1 of all nodes
* There are many ways this can still fail 
    * (but rarely does!)


### High load clusters
* Stuff you should consider doing under high load


### Dedicated masters

* Eligible masters and clients, but not data nodes
* Decreases querying/indexing load on masters

### On AWS

* EC2 discovery plugin
    * Uses AWS API for unicast discovery
* As a bonus, makes it easier to save snapshots to S3

### Shard allocation

* Happens during initial recovery, replica allocation, rebalancing, and node addition/removal
* Shard allocation awareness allows us to ensure that a primary shard and its replica will not be collocated to a node with the same value 

```yaml
node.rack_id: rack_one
cluster.routing.allocation.awareness.attributes: rack_id
```



