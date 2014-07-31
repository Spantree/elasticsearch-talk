## Connecting from .NET


### Connections

* JVM clients typically use the Transport layer (9300)
* Non-JVM clients typically use HTTP-REST (9200) or Thrift (9400)


### Available Libraries

* [PlasticElastic.net](https://github.com/Yegoroff/PlainElastic.Net) (command builder pattern)
* [NEST](https://github.com/Mpdreamz/NEST) (High-Level)
* [Elasticsearch.net](https://github.com/medcl/ElasticSearch.Net) (Low-Level)


### PlasticElastic

```c#
// 1. It provides ES HTTP connection
var connection  = new ElasticConnection("localhost", 9200);

// 2. And sophisticated ES command builders:
string command = Commands.Index(index: "twitter", type: "user", id: test)

// 3. And gives you the ability to serialize your objects to JSON:  
var serializer = new JsonNetSerializer();
var tweet = new Tweet { Name = "Some Name" };
string jsonData = serializer.ToJson(tweet);

// 4. Then you can use appropriate HTTP verb to execute ES command:
string response = connection.Put(command, jsonData);

// 5. And then you can deserialize operation response to typed object to easily analyze it:
IndexResult indexResult = serializer.ToIndexResult(result);
if(indexResult.ok) {
   ... // do something useful.
}
```


### NEST


```c#
public class Person
{
    public string Id { get; set; }
    public string Firstname { get; set; }
    public string Lastname { get; set; }
}

var person = new Person
{
    Id = "1",
    Firstname = "Martijn",
    Lastname = "Laarman"
};
var index = client.Index(person);
```


## Elasticsearch.net

```c#
var client = new ElasticSearchClient(“localhost”);
client.CreateIndex("index", new IndexSetting(5, 1));
client.Index("testindex", "testtype", "testkey", "{\"a\":\"b\"}");
```
