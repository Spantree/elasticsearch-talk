## Querying


### Search API

```bash
curl -XGET http://estalk.spantree.local:9200/wikipedia/_search?q=about:lake
```

or

```bash
curl -XPOST "http://estalk.spantree.local:9200/wikipedia/_search" -d '{
  "query" : {
    "term" : { "about" : "lake" }
  }
}'
```


### Types of Queries

<table>
<tr><td>match</td><td>multi match </td><td> bool</td><tr>                

<tr><td> boosting  </td><td> common terms </td><td nowrap> constant score </td><tr> 
<tr><td>  dis max  </td><td>filtered  </td><td> fuzzy like this </td><tr> 
<tr><td>  fuzzy like this field </td><td> function score </td><td> fuzzy </td><tr> 
<tr><td>  geoshape </td><td>has child  </td><td>has parent </td><tr> 
<tr><td>    ids </td><td>indices  </td><td>  match all </td><tr> 
<tr><td>  more like this </td><td>  more like this field  </td><td> nested </td><tr> 
<tr><td>   prefix </td><td> query_string   </td><td>  simple query </td><tr>
<tr><td>    range</td><td> regexp   </td><td> span first </td><tr> 
<tr><td>      span multi term  </td><td> span near  </td><td> span not </td><tr> 
<tr><td>     span or  </td><td> span term  </td><td> term </td><tr> 
<tr><td>   terms </td><td> top children  </td><td> wildcard</td><tr> 
<tr><td nowrap>   minimum should match  </td><td nowrap> multi term query rewrite</td><tr> 
</table>


### Search Demos

[API Examples](http://estalk.spantree.local:9200/_plugin/marvel/sense/#03-search-api)


### Search is very fast!


### How is it so fast?

* ![Science Cat](images/science-cat.jpg)


### Simple example: Inverted index
<div class="row ix-illustration" data-illustration="ix-illustration" ng-controller="InvertedIndexController">
  <dv ng-include src="'sections/js/templates/_invindex.html'"></div>
</div>


### Simple example: How to query? 

* Make vectors of document scores
* Make vector to represent query 
* Find smallest angle between document and query


### Simple example: Document score vector

* "A text query"
* $[\text{score}_0, \text{score}_1, \text{score}_2]$


### Simple example: TF-IDF scores
$tf \times idf = tf \times \log{ \frac{N}{df} }$

* **term frequency ($tf$)** number of times a term occurs in a particular document
* **document frequency ($df$)** number of all documents a term occurs in 
* **inverse document frequency ($idf$)** is (usually) $\log{\frac{N}{df}}$, where $N$ is the number of documents in the index


### Simple example: Finding angles

* $\text{similarity} = \cos(\theta) = {D \cdot Q \over \|D\| \|Q\|}$


### Simple example: Scoring demo
<div class="row tfidf-illustration ix-illustration" data-illustration="tfidf-illustration" ng-controller="InvertedIndexController">
  <dv ng-include src="'sections/js/templates/_scoring.html'"></div>
</div>


### In Lucene...

* It's more complicated!


### Practical Scoring Function
$s = coord \times \sum_{t} (qn \times boost \times idf) \times (tf \times idf \times fn)$

* **qn (queryNorm)** - tries to make results of different queries comparable
* **coord** - coord, boosts documents that contain more of the query
* **boost** - boosts value of a term in the query
* **fn (fieldNorm)** - boosts score when matching shorter fields


### Scoring in action

[Explain query](http://estalk.spantree.local:9200/_plugin/marvel/sense/#03-search-api,S3.11)


### More on scoring

* Modified via boosting
* Can rewrite scoring algorithm
* Can use alternative scoring algorithms (Okapi BM25, etc)


### Now for something completely different

* Filtering


### Queries vs Filters

![Ornaments](images/querying_vs_filtering.svg)


### Queries vs Filters

<table class="qvf">
<tr>
<th>Queries</th>
<th>Filters</th>
</tr>
<tr>
<td>Fuzzy</td>
<td>Boolean</td>
</tr>
<tr>
<td>Slower</td>
<td>Faster</td>
</tr>
<tr>
<td>Never cached</td>
<td>Cacheable</td>
</tr>
<tr>
<td>Scored</td>
<td>Never scored</td>
</tr>
</table>


### Filtering Demos

[API Examples](http://estalk.spantree.local:9200/_plugin/marvel/sense/#03-search-api,S3.14)