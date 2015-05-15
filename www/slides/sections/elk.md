## Log Aggregation with the ELK Stack

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

Use an agent to tail log files, parse them into a uniform format, and ship them "somewhere else."

<table>
  <tr>
    <td style="vertical-align: middle;">![Logstash](images/logstash.png)</td>
    <td style="vertical-align: middle;"><img src="images/fluentd.png" alt="Fluentd" style="width: 500px;"/></td>
    <td style="vertical-align: middle;">![Rsyslog](images/rsyslog.png)</td>
    <td style="vertical-align: middle;">![Flume](images/flume.png)</td>
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

```
input {
  tcp {
    port => 3333
    type => "some_other_machine"
  }
  file {
    type => "apache_access"
    path => [ "/var/log/apache/access.log" ]
    start_position => "beginning"
  }
}

filter {
  mutate {
    add_field => [ "host_ip", "%{host}" ]
  }

  if [type] == "apache_access" {
    grok {
      match => {
        message => "%{IPORHOST:remote_addr} - %{USER:user} \[%{HTTPDATE:timestamp}\] \"%{WORD:http_method} %{URIPATHPARAM:request} HTTP/%{NUMBER:http_version}\" %{NUMBER:status} (?:%{NUMBER:bytes}|-) \"(?:%{URI:referrer}|-)\" %{QS:user_agent}"
      }
    }

    date {
      locale => "en"
      match => ["timestamp", "dd/MMM/yyyy:HH:mm:ss Z"]
    }

    mutate {
      remove_field => "timestamp"
      gsub => [
        "user_agent", "(^\"|\"$)", ""
      ]
    }

    useragent {
      source => "user_agent"
      prefix => "user_agent_"
    }

    geoip {
      source => "remote_addr"
      target => "geoip"
      database =>"/usr/local/share/geoip/GeoLiteCity.dat"
      add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
      add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
    }

    mutate {
      convert => [ "[geoip][coordinates]", "float" ]
    }
  }
}

output {
  elasticsearch {
    host => "elasticsearch.local"
    template => "/etc/logstash/logstash-es-template.json"
  }
}
```


### What does the output look like?

```json
{
  "message": "24.150.169.57 - - [30/Apr/2003:22:00:18 -0700] \"GET /random/video/Star_Wars_Kid_Remix.wmv HTTP/1.1\" 302 313 \"http://www.waxy.org/archive/2003/04/29/star_war.shtml\" \"Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)\"",
  "@version": "1",
  "@timestamp": "2003-05-01T05:00:18.000Z",
  "host": "127.0.0.1:36626",
  "type": "apache_access",
  "host_ip": "127.0.0.1:36626",
  "remote_addr": "24.150.169.57",
  "http_method": "GET",
  "request": "/random/video/Star_Wars_Kid_Remix.wmv",
  "http_version": "1.1",
  "status": "302",
  "bytes": "313",
  "referrer": "http://www.waxy.org/archive/2003/04/29/star_war.shtml",
  "user_agent": "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)",
  "user_agent_name": "IE",
  "user_agent_os": "Windows 98",
  "user_agent_os_name": "Windows 98",
  "user_agent_device": "Other",
  "user_agent_major": "5",
  "user_agent_minor": "5",
  "geoip": {
    "ip": "24.150.169.57",
    "country_code2": "CA",
    "country_code3": "CAN",
    "country_name": "Canada",
    "continent_code": "NA",
    "region_name": "ON",
    "city_name": "Burlington",
    "postal_code": "L7R",
    "timezone": "America/Toronto",
    "real_region_name": "Ontario",
    "coordinates": [
      -79.7957,
      43.32480000000001
    ]
  }
}
```


### Elasticsearch

We already know about Elasticsearch (woo!)


### Kibana

[A picture is worth a thousand words](http://bit.ly/ccc-waxy1)