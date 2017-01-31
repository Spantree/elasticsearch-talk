## Terminology

---

### Document

* A record, unit of search
* Represented as JSON
* The thing returned in search results
* Not quite a row, but similar

---

### What a document looks like

```json

{
  "name": "Wells Community Academy High School",
  "wikipedia_numeric_id": 10907332,
  "keywords": ["schools", "chicago", "public"],
  "about": "Wells Community Academy High School is...",
  "lastUpdated": "2012-08-08T07:45:13+0000",
  "coordinates": [
    -87.667915,
    41.899246
  ]
}
```

---

### Data Types

<table class="examples col-3">
  <tr>
    <td>string</td>
    <td>long</td>
    <td>integer</td>
  </tr>
  <tr>
    <td>short</td>
    <td>byte</td>
    <td>double</td>
  </tr>
  <tr>
    <td>float</td>
    <td>date</td>
    <td>boolean</td>
  </tr>
  <tr>
    <td>binary</td>
    <td>type</td>
    <td>object</td>
  </tr>
  <tr>
    <td>nested</td>
    <td>geo_point</td>
    <td>geo_shape</td>
  </tr>
  <tr>
    <td>ip</td>
    <td>completion</td>
  </tr>
</table>

---

### Field

* A typed slot in a document for storing and retrieving values
* Can store multiple values and nested values
* Any field value for a document is optional
* Not quite a column, but similar

---

### Types

* Logical grouping of documents in an index
* All documents in a given type have the same fields (but they're all optional)

---

### Tokens

Individual words or pieces of text indexed by Elasticsearch, for example:

`quick` `brown` `fox` `jumped` `over` `the` `lazy` `dog` <!-- .element style="font-size: 0.9em;" -->

---

### Character filters

* Preprocess a character stream before being passed to a tokenizer
* Can only remove or replace single characters at a time

---

### Tokenizers

Split phrases into words

[Example](inquisitor://#/tokenizers)

---

### Token filters

Modify tokens by adding, removing or changing their values

[Example](inquisitor://#/analyzers)

---

### Analyzers

A chain of character filters, tokenizers and token filters

![Analysis Chain](images/diagrams/analysis-chain-with-background.png#diagram)

---

### Index

* A collection of documents managed as a unit
* Physically isolated in separate files on disk (segments)
* Similar to a database, but not quite
* Elasticsearch allows you to search across indices

---

### Node

* An running instance of Elasticsearch
* Can be master, client or data node (or any combination)

---

### Cluster

One or more nodes sharing data and workload

---

### Shard

* A slice of the data in an index
* Siloed in different directories
* Can be replicated across nodes

---

### A physical view

![A physical view](images/diagrams/cluster-topology.png#diagram)
