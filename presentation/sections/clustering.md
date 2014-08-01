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
    * Holds/applies cluster state
    * Distributes shards in cluster
* Not to be confused with master replicas

Note: 
* Show configuration
* Any node can handle a query, including paging/sorting/collating results


### Zen: Pinging


### Zen: Multicast

* Default configuration
    * Port 54328 broadcast to multicast group 224.2.2.4


### Zen: Unicast

* Specify list of IP addresses


### Transport protocol

### Routing a document request

Note:
* ``` shard = hash(routing) % number_of_primary_shards ```
    * This is why number of shards is not changeable


### Automatic balancing

![Analysis phases](images/sharding-replica.svg)


### How are requests directed


### What happens when a node fails?

* When a Node Fails
    * If Master Elect a new Master
    * Replicas are promoted to primary shards
    * Cluster status is yellow but operational


### Split brain problem 


### Dedicated masters

* When you have critical clusters
* When you have high write or read throughput
* Always have an odd number to avoid split brain
* Still vulnerable to some [split brain issues](http://github.com/elasticsearch/elasticsearch/issues/2488)
* Improvements coming in 1.3.0 hopefully


### Shard allocation

* Happens during initial recovery, replica allocation, rebalancing, and node addition/removal
* Shard allocation awareness allows us to ensure that a primary shard and its replica will not be collocated to a node with the same value 

```yaml
node.rack_id: rack_one
cluster.routing.allocation.awareness.attributes: rack_id
```


### Alternative discovery plugins
              
* If you run into issues, consider using alternative discovery plugins (e.g. [sonian-zookeeper-plugin](https://github.com/sonian/elasticsearch-zookeeper))