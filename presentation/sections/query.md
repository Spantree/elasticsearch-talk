## Querying


### Search API

```bash
curl -XGET http://esdemo.local:9200/wikipedia/_search?q=about:lake
```

or

```bash
curl -XPOST "http://esdemo.local:9200/wikipedia/_search" -d '{
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


### Most Useful Queries

<table>
<tr><td>match</td><td><b>multi match </b> </td><td> <b> bool </b></td><tr>                

<tr><td> boosting  </td><td> common terms </td><td nowrap> constant score </td><tr> 
<tr><td>  dis max  </td><td>filtered  </td><td> fuzzy like this </td><tr> 
<tr><td>  fuzzy like this field </td><td> function score </td><td> fuzzy </td><tr> 
<tr><td>  geoshape </td><td>has child  </td><td>has parent </td><tr> 
<tr><td>    ids </td><td>indices  </td><td>  match all </td><tr> 
<tr><td>  more like this </td><td>  more like this field  </td><td> nested </td><tr> 
<tr><td>   prefix </td><td> <b>query_string</b>   </td><td>  simple query </td><tr>
<tr><td>   <b> range </b></td><td> regexp   </td><td> span first </td><tr> 
<tr><td>      span multi term  </td><td> span near  </td><td> span not </td><tr> 
<tr><td>     span or  </td><td> span term  </td><td> <b>term </b> </td><tr> 
<tr><td>   terms </td><td> top children  </td><td> wildcard</td><tr> 
<tr><td nowrap>   minimum should match  </td><td nowrap> multi term query rewrite</td><tr> 
</table>


### Search Demos

[API Examples](http://esdemo.local:9200/_plugin/marvel/sense/#03-search-api)


### Explaining queries


### How is it so fast?


### Inverted index
<div class="row ix-illustration" data-illustration="ix-illustration" ng-controller="InvertedIndexController">
  <dv ng-include src="'sections/js/templates/_invindex.html'"></div>
</div> 


### How does it know which document is most relevant?

* ...Math


### Simple scoring

* Make vectors of scores
* Finds angle between vectors of scores


### Simple example: TF-IDF
$tf \times idf = tf \times \log{ \frac{N}{df} }$

* **term frequency ($tf$)** number of times a term occurs in a particular document
* **document frequency ($df$)** number of all documents a term occurs in 
* **inverse document frequency ($idf$)** is (usually) $\log{\frac{N}{df}}$, where $N$ is the number of documents in the index


### Scoring demo
<div class="row tfidf-illustration ix-illustration" data-illustration="tfidf-illustration" ng-controller="InvertedIndexController">
  <dv ng-include src="'sections/js/templates/_scoring.html'"></div>
</div>


### Actual scoring: Okapi BM25

<br/>
$\frac{tf}{(k_1(1 - b) + b \frac{dl}{avdl}) + tf} \times \log \frac{ N - df + 0.5 }{ df + 0.5 }$
<br/><br/>

* Yuck!


### That was fun


### More on scoring

* Defaults to Okapi BM25
* Modified via boosting
* Can rewrite scoring engine


### Filtering


### Queries vs Filters

![Ornaments](images/querying_vs_filtering.svg)


### Queries vs Filters

<table class="qvf">
<tr>
<th>Queries</th>
<th>Filters</th>
</tr>
<tr>
<td>Scored</td>
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
</table>