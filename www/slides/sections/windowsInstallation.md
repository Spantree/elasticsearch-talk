## Installing on Windows


## Configuring your environment

* Install Java 7 or 8
* Configure your `JAVA_HOME`
* Download the Elasticsearch zip file from web
* Extract to destination directory (e.g. C:\elasticsearch)


## Starting Elasticsearch

```
cd C:\elasticsearch\elasticsearch-1.2.1\bin
./elasticsearch
```


## Installing plugins

```
cd C:\elasticsearch\elasticsearch-1.2.1\bin
./plugin -i lukas-vlcek/bigdesk
./plugin -i elasticsearch/marvel/latest
./plugin -i mobz/elasticsearch-head
./elasticsearch
```


## Configuring as a Windows service

```
cd C:\elasticsearch\elasticsearch-1.2.1\bin
./service install
```