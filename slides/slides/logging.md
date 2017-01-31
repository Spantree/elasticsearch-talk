## Log Aggregation with Elastic Stack

* Elasticsearch
* Logstash
* Kibana
* Beats

---

### What are our goals for log management?

Aggregate business and system events from multiple sources

Figure out what went wrong

Figure out what will go wrong

Search, filter and report via a central interface

Detect critical events and trigger notifications

Provide a low-maintenance toolchain

---

### How can we meet these goals?

Use an agent to tail log files, parse them into a uniform format, and ship them "somewhere else."

<div class="grid" style="width: 900px;">
![Beats](images/logos/beats.png#plain)
![Logstash](images/logstash.png#plain)
![Fluentd](images/fluentd.png#plain) <!-- .element style="width: 500px;" -->
![Rsyslog](images/rsyslog.png#plain)
![Flume](images/flume.png#plain)
</div>

---

### How else can we meet these goals?

Make that "somewhere else" be Elasticsearch, and use its powerful query and aggregation API to gain insights from events.

![Elasticsearch](images/elastic.png#plain)

---

### How else can we meet these goals?

Develop a composable dashboard and data visualization tool to help us make sense of all this data.

![Kibana](images/kibana.png)

---

### What does this look like?

![ELK Flow](images/diagrams/beats-logstash-es-flow.png#plain)

---

### Beats in a Nutshell

* Written in Golang
* Designed to install at the edge of your logging events
* Supports many different inputs and outputs
* Supports limited enrichment

---

### Filebeat Config

```yaml
filebeat.prospectors:
- input_type: log
  paths:
    - /var/log/*.log
output.elasticsearch:
  hosts: ["elastic1:9200"]
```

---

### Logstash in a Nutshell

* JVM agent that runs in the background
* Also supports many inputs
* Uses a configuration format called `grok` to parse log files
* Ships logging events in batch to an "output" (often Elasticsearch)
* Not very fast (because JRuby)

---

### What does grok look like?

```
input {
  file {
    path => "/var/log/http.log"
  }
}
filter {
  grok {
    type => "apache",
    match => [ "message", "\[%{HTTPDATE:timestamp}\] %{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes}"]
  }

  date {
    type => "apache"
    match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
  }
}
output {
  elasticsearch {
    host => "elastic1"
    port => 9300
  }
}
```

---

### What does the output look like?

```json
{
  "_index": "logstash-2011.08.29",
  "_type": "apache",
  "_id": "3kHe3_YYRi6k7k4QrDcBcA",
  "_source": {
    "message": "[29/Aug/2011:13:19:31 -0700] 80.245.86.19 POST /blog/geekery/solaris-10-sshd-publickey-solution 16809",
    "@version": "1",
    "client": "80.245.86.19",
    "timestamp": "29/Aug/2011:13:19:31 -0700",
    "method": "POST",
    "request": "/blog/geekery/solaris-10-sshd-publickey-solution",
    "bytes": "16809"
  }
}
```

---

### Elasticsearch 5.0

* Coming Soon (or now)... [Ingest Nodes](https://www.elastic.co/guide/en/elasticsearch/reference/master/ingest.html)

---

### Kibana

[A picture is worth a thousand words](kibana://app/kibana)
