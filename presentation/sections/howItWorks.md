## How It Works


### What does querying an index do?

* Find the documents that match the query
* Score the documents 


### Inverted index

![Book Index](images/book-index.png)


### Inverted index

* Maps word to document or position


### Inverted Index 
<div class="row ix-illustration" data-illustration="ix-illustration" ng-controller="InvertedIndexController">
  <dv ng-include src="'sections/js/templates/_invindex.html'"></div>
</div>


### TF-IDF Scoring Of Documents
$tf \times idf = tf \times \log{ \frac{N}{df} }$

* <em>term frequency ($tf$)</em> number of times a term occurs in a particular document
* <em>document frequency ($df$)</em> number of all documents a term occurs in 
* <em>inverse document frequency ($idf$)</em> is (usually) $\log{\frac{N}{df}}$, where $N$ is the number of documents in the index


### Cosine similarity

* Vector space model
* Documents are vectors of TF-IDF values
* Compute the angle between query and document

$\cos{\theta} = \frac{d \cdot q}{||d|| \cdot ||q||} $


### Scoring documents
<div class="row tfidf-illustration ix-illustration" data-illustration="tfidf-illustration" ng-controller="InvertedIndexController">
  <dv ng-include src="'sections/js/templates/_scoring.html'"></div>
</div>


### The Lucene Library

![Lucene](images/lucene.png)


### Okapi BM25 Scoring
<br/>
$\frac{tf}{(k_1(1 - b) + b \frac{dl}{avdl}) + tf} \times \log \frac{ N - df + 0.5 }{ df + 0.5 }$
<br/><br/>

* $tf$, $df$ and $N$ defined as before
* $dl$ is document length and $avdl$ is average document length
* $k_1$ and $b$ are free variables


### For the curious

* [http://lucene.apache.org/core/4_0_0/core/overview-summary.html](http://lucene.apache.org/core/4_0_0/core/overview-summary.html)
* [http://wiki.apache.org/lucene-java/LucenePapers](http://wiki.apache.org/lucene-java/LucenePapers)


### Terminology Overview

![Index Structure](images/index-structure.svg)


### Terminology Overview

![Document Structure](images/document-structure.svg)


### Indexes

One or more Lucene indexes, composed of segments


### Lucene segement merging in action
<iframe width="560" height="315" src="//www.youtube.com/embed/YW0bOvLp72E?rel=0" frameborder="0" allowfullscreen></iframe>


### Documents

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


### Types and Mappings
* The fields a document should have
* The data type of each field
* Analysis
  * How to generate tokens from document (indexing)
  * How to generate tokens from query string (searching)


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


### Analyzer

![Analysis phases](images/analysis-chain.svg)


### Mappings and analysis

![Mapping and analysis](images/mapping-analysis.svg)


### Example

![Analysis phases](images/sharding-replica.svg)