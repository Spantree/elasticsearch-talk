## Terminology


### Index

![Index Structure](images/index-structure.svg)


### Document

![Document Structure](images/document-structure.svg)


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


### Mapping
* Defines fields and field data types
* Defines analyzers


### Data Types
* string
* integer/long
* float/double
* boolean
* ip
* geo point
* geo shape
* attachment
* object


### Analyzers


### Analyzer chain

![Analysis phases](images/analysis-chain.svg)


### Index-time vs Query-time analysis


### Analyzing at query and index time

![Mapping and analysis](images/mapping-analysis.svg)