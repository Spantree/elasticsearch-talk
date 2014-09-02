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
  <div class="col-md-4">
    <div class="panel panel-default">
      <div class="panel-body" style="height:500px; overflow-y:scroll; padding: 30px;">
        <span> Documents </span>
        <div ng-model="documentsHtml" ng-repeat="(docKey, doc) in documentsHtml">
            <div style="padding-bottom: 5px; height: 100px; ">
                <span style="font-size: 14pt">{{docKey}}</span>
                <div ng-bind-html="doc" class="form-control" style="font-size: 18pt; line-height: 20pt; font-weight: bold; height: 60px; ">
                </div>
            </div>
        </div>
        <button class="btn btn-success" ng-click="buildInvIndex()">Build Index</button>
       </div>
    </div>
  </div>
  <div class="col-md-1">
  </div>
  <div class="col-md-7">
    <div class="panel panel-default">
      <div class="panel-body" style="height:500px; overflow-y:scroll; padding: 30px;">
        <table class="table" style="font-size: 70%;">
          <tr>
            <th>
              Word
            </th>
            <th>
              Document
            </th>
            <th>
              Positions
            </th>
          </tr>
          <tr ng-model="invindex" ng-repeat-start="entry in invIndex">
            <td rowspan="{{entry.documentsLength}}" ng-mouseover="highlight(entry.word)" style="cursor: pointer; font-weight: bold">
              {{entry.word}}
            </td>
            <td ng-repeat-start="(document, words) in entry.documents" ng-show="$first">
                {{document}}
            </td>
            <td ng-repeat-end ng-show="$first">
                {{words.join(', ')}}
            </td>
          </tr>
          <tr ng-repeat-end ng-repeat="(document, words) in entry.documents" ng-show="!$first">
            <td>
                {{document}}
            </td>
            <td>
                {{words.join(', ')}}
            </td>
          </tr>
        </table>
      </div>
    </div>
  </div>
</div>


### TF-IDF Scoring Of Documents
$tf \times idf = tf \times \log{ \frac{N}{df} }$

* <em>term frequency ($tf$)</em> number of times a term occurs in a particular document
* <em>document frequency ($df$)</em> number of all documents a term occurs in 
* <em>inverse document frequency ($idf$)</em> is (usually) $\log{\frac{N}{df}}$, where $N$ is the number of documents in the index


### Scoring documents
<div class="row tfidf-illustration" data-illustration="tfidf-illustration" ng-controller="InvertedIndexController">
  <div class="col-md-4">
    <div class="panel panel-default">
      <div class="panel-body" style="height:500px; overflow-y:scroll; padding: 30px;">
        <span> Documents </span>
        <div ng-model="documentsHtml" ng-repeat="(docKey, doc) in documentsHtml">
            <div style="padding-bottom: 5px; height: 100px; ">
                <span style="font-size: 14pt">{{docKey}}</span>
                <div ng-bind-html="doc" class="form-control" style="font-size: 18pt; line-height: 20pt; font-weight: bold; height: 60px; ">
                </div>
            </div>
        </div>
        <button class="btn btn-success" ng-click="buildInvIndex()">Build Index</button>
       </div>
    </div>
  </div>
  <div class="col-md-1">
  </div>
  <div class="col-md-7">
    <div class="panel panel-default">
      <div class="panel-body" style="height: 500px; overflow-y: scroll; padding: 30px;">
        <input type="text" class="form-control" ng-model="searchQuery" ng-change="updateQuery()" placeholder="Enter search text" ng-value="searchQuery"/>
        <table class="table" style="font-size: 70%;" ng-show="searchQuery">
          <tr>
            <th>
            </th>
            <th ng-repeat="word in searchWords track by $index">
              {{word}}
            </th>
          </tr>
          <tr ng-model="documentsHtml" ng-repeat="(docKey, doc) in documentsHtml">
            <td>{{docKey}}</td>
            <td ng-model="searchWords" ng-repeat="word in searchWords track by $index">
              <span mathjax-bind="{{termFrequencies[docKey][word]}} \times \log{ \frac{ {{documentCount}} }{ {{documentFrequencies[word]}} } }">
              </span>
            </td>
          </tr>
        </table>
      </div>
    </div>
  </div>
</div>


### Scoring our example

<table style="margin: auto">
  <tr>
    <td rowspan="3">work</td><td rowspan="3">&rarr;</td><td>0:</td><td>{0}</td>
  </tr>
  <tr>
    <td>1:</td><td>{7}</td>
  </tr>
  <tr>
    <td>2:</td><td>{0}</td>
  </tr>
  <tr>
    <td>hour</td><td>&rarr;</td><td>1:</td><td>{2, 3}</td>
  </tr>
  <tr>
    <td rowspan="2">harder</td><td rowspan="2">&rarr;</td><td>0:</td><td>{8}</td>
  </tr>
  <tr>
    <td>2:</td><td>{2}</td>
  </tr>
</table>


<table class="tf-idf">
  <tr>
    <th></th>
    <th>work</th>
    <th>hour</th>
    <th>harder</th>
  </tr>
  <tr>
    <td>0:</td><td>$1 \times \log{\frac{3}{3}}$</td><td>$0 \times \log{\frac{3}{1}}$</td><td>$1 \times \log{\frac{3}{2}}$</td>
  </tr>
  <tr>
    <td>1:</td><td>$1 \times \log{\frac{3}{3}}$</td><td>$2 \times \log{\frac{3}{1}}$</td><td>$0 \times \log{\frac{3}{2}}$</td>
  </tr>
  <tr>
    <td>2:</td><td>$1 \times \log{\frac{3}{3}}$</td><td>$0 \times \log{\frac{3}{1}}$</td><td>$1 \times \log{\frac{3}{2}}$</td>
  </tr>
<table>


### Scoring our example
<table class="scoring">
  <tr>
    <th></th>
    <th>work</th>
    <th>hour</th>
    <th>harder</th>
  </tr>
  <tr>
    <td>0:</td><td>0</td><td>0</td><td>.35</td>
  </tr>
  <tr>
    <td>1:</td><td>0</td><td>.95</td><td>0</td>
  </tr>
  <tr>
    <td>2:</td><td>0</td><td>0</td><td>.35</td>
  </tr>
<table>
<br/>

* Create a vector for the query: $\[1,1,1\]$
* Take the cosine-similarity of the two vectors
  * Gives the cosine of the angle between two vectors


### The Lucene Library

![Lucene](images/lucene.png)


### How it *really* works

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