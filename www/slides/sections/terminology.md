## Terminology


### Document

* A JSON object
* Smallest searchable unit
* Self-contained
* Hierarchical


### What a document looks like

```json
{
  "_index": "index_name",
  "_type": "document_type",
  "_id": 1337,
  "_source": {
    "field0": 777,
    "field1": "value",
    "field2": ["value1","value2","value3"],
    "field3": {
      "subfield0":"value1",
      "subfield1":"value2"
    } 
  }
}
```


### Data Types

<table class="examples col-3">
  <tr>
    <td>String</td>
    <td>Integer (&#42;)</td>
    <td>Long (&#42;)</td>
  </tr>
  <tr>
    <td>Float (&#42;)</td>
    <td>Double (&#42;)</td>
    <td>Boolean</td>
  </tr>
  <tr>

  <tr>
    <td>Date (&#42;)</td>
    <td>Geopoint (&#42;)</td>
    <td>Geoshape</td>
  </tr>
  <tr>
    <td>IP</td>
    <td>Attachment</td>
    <td>Object</td>
  </tr>
  <tr>
    <td colspan="3" style="font-size: 0.8em;">
      (&#42;) Numbers and dates are stored as tries.
    </td>
  </tr>
</tr>


### Field

* The "keys" in a JSON document
* Has a type
* Analyzed based on the defined mapping

### Mapping types

* Logical grouping of documents
* Mappings specify the structure of a document


### Tokens

Individual words or pieces of text indexed by Elasticsearch, for example:

`the` `quick` `brown` `fox` `jumped` `over` `the` `lazy` `dog`


### Character filters

Preprocess a character stream before being passed to a tokenizer


### Tokenizers

Methods of splitting up a field value into tokens

[Example](http://esdemo.local:9200/_plugin/inquisitor/#/tokenizers)


### Token filters

Modify tokens by adding, removing or changing their values

[Example](http://esdemo.local:9200/_plugin/inquisitor/#/analyzers)


### Analyzers

A chain of character filters, tokenizers and token filters

![Analysis phases](images/analysis-chain.svg)


### Analyzing at query and index time

![Mapping and analysis](images/mapping-analysis.svg)


### Index

* Siloed containers for mapping types
* Physically isolated in separate files on disk
* You can search across indices


### Node

An instance of Elasticsearch


### Cluster

One or more nodes sharing data and workload


### Shard

* A slice of the data in an index
* Siloed in different directories
* Can be replicated across nodes


### A physical view

![A physical view](images/sharding-replica.svg)