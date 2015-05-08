### Bulk indexing

* Prefer bulk updates when possible, buffering updates to reduce data loss
* Force a refresh at the as an ACK


### Distributed indexing

* Use an external message queue (RabbitMQ, Kafka, etc) to feed events into Elasticsearch


### River plugins?
