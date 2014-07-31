## Querying


### Search API

```bash
curl -XGET http://esdemo.local:9200/wikipedia/_search?q=about:lake
```

or

```bash
curl -XGET "http://esdemo.local:9200/wikipedia/_search" -d '{
"query" : {
"term" : { "about" : "lake" }
}
}'
```


<h3>Types of Queries</h3>

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


<h3>Types of Queries</h3>

<table>
<tr><td>match</td><td><b>multi match </b> </td><td> <b> bool </b></td><tr>                

<tr><td> <b>boosting </b>  </td><td> common terms </td><td nowrap> constant score </td><tr> 
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


### Scoring

* Defaults to Okapi BM25
* Modified via boosting
* Can rewrite scoring engine


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
</table>


### Filter on Red and Green

![Ornaments](images/red-and-green-ornaments.jpg)
![MM](images/red-green-m-m.jpg)
![RedGreen](images/red_green.jpg)


### Query on Red and Green - Also returns

![Red](images/red.png)
![Green](images/green.png)
![Blue](images/blue.svg)