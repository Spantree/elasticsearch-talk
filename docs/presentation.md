# ElasticSearch

> You know, for Search

## Title Page

## Cool stuff

* RESTful interface
* Uses JSON
* Based on Lucene
* Wicked fast
* Wicked configurable
* Wicked scalable
* Open Source

## Not so cool stuff

* Documentation a "work in progress"
* No field collapsing yet
* Nested facets not (yet) supported
* No built-in spellchecker

## Demo time

### Indexing

* Push in wikipedia documents

### Querying

#### Basic Full-Text

* Search for "college"
* Search for "lake"

#### Dismax

* Search for "lake view"

#### Facet

* Keywords
* Distance

#### Sort

* By term
* By score

#### Range Filters

* Distance

### Updating/Versioning

* Partial updates
* Go back in time

### Multi-Tenant

* Create two indexes
* Search across them

### Mapping

* Dates types/formats
* Store/No Store
* Secondary fields
	* Facet keyword fields
	* EgdeNGrams

### Analysis

* Keyword tokenizers
* EgdeNGrams
* Synonym filters
* Regex replacement

#### Modify Mapping

### Scaling

#### Discovery

#### Shards

### Plugins (Head)

### Lucene Internals

## Stuff We Didn't Cover

### Querying Multiple Types

### Highlighting

### River Plugins

### Percolating