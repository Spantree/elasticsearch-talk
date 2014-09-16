## The "ELK Stack"

* Elasticsearch
* Logstash
* Kibana


### What are our goals for log management?


Aggregate business and system events from multiple sources


Figure out what went wrong


Figure out what will go wrong


Search, filter and report via a central interface


Detect critical events and trigger notifications


Provide a low-maintenance toolchain


### How can we meet these goals?

Use an agent to tail log files, parse them into a uniform format, and ship them "somewhere else.""

<table>
  <tr>
    <td>![Logstash](images/logstash.png)</td>
    <td>![Fluentd](images/fluentd.png)</td>
    <td>![Rsyslog](images/rsyslog.png)</td>
    <td>![Flume](images/flume.png)</td>
  </tr>
</table>


### How else can we meet these goals?

Make that "somewhere else" be Elasticsearch, and use its powerful query and aggregation API to gain insights from events.

![Elasticsearch](images/elasticsearch.png)


### How else can we meet these goals?

Develop a composable dashboard and data visualization tool to help us make sense of all this data.

![Kibana](images/kibana.png)


### What does this look like?

![ELK Flow](images/elk-flow.png)


### Logstash in a Nutshell

* Java-based agent that runs in the background, mostly tailing log files
* Uses a configuration format called `grok` to parse log files
* Ships logging events in batch to an "output", usually Elasticsearch


### What does grok look like?

```json
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
    host => "es.somewhereelse.local"
    port => 9300
  }
}
```


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


### Elasticsearch

We already know about Elasticsearch (woo!)


### Kibana

[A picture is worth a thousand words](http://kibana.local)