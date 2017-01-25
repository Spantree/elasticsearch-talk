![Elasticsearch logo](images/elasticsearch.png)

<p><img src="images/kimchy.jpeg" style="width:50px;vertical-align:text-top"> "You know, for Search!"</p>

---

![Cote Tweet](images/cote-tweet.png)

---

## The Challenge

![Simplicity](images/simplicity.png)

---

### How We Query

#### SQL Database

```sql
SELECT *
FROM Person INNER JOIN Scientist ON Person.ID = Scientist.ID
WHERE FirstName LIKE "Edgar%" And LastName = "Codd";
```

#### Elasticsearch

```json
GET /spantree/_search

{
  "query": {
    "query_string": {
      "query": "vannevar bush"
    }
  }
}
```

---

### What People Expect
#### Searching Across Fields

```json
{
  "product": {
    "name": "nifty doodad",
    "description": "this is an example"
  }
}
```

This document should match <em>example doodad</em>

---

### What People Expect

<table class="examples">
  <tbody>
    <tr>
      <th>Lowercase</th>
      <td>iPhone</td>
      <td>&#8781;</td>
      <td>iphone</td>
    </tr>
    <tr>
      <th>Stemming</th>
      <td>Runner</td>
      <td>&#8781;</td>
      <td>Running</td>
    </tr>
    <tr>
      <th>Synonyms</th>
      <td>Car</td>
      <td>&#8781;</td>
      <td>Automobile</td>
    </tr>
    <tr>
      <th>Word delimiters</th>
      <td>Show-off</td>
      <td>&#8781;</td>
      <td>Show off</td>
    </tr>
    <tr>
      <th>ASCII Folding</th>
      <td>Nestl&eacute;</td>
      <td>&#8781;</td>
      <td>Nestle</td>
    </tr>
    <tr>
      <th>Pattern Replace</th>
      <td>(888) 386-5501</td>
      <td>&#8781;</td>
      <td>888.386.5501</td>
    </tr>
    <tr>
      <th>Edge NGram</th>
      <td>ela</td>
      <td>&#8781;</td>
      <td>elasticsearch</td>
    </tr>
  </tbody>
</table>
<!-- TODO: Fill in with multi-match example -->
