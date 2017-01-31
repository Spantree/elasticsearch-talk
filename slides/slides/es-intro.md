![Elasticsearch logo](images/elastic-white.png#plain)  <!-- .element: style="max-height: 160px;" -->

"You know, for Search!"

![Shay Bannon](images/shay-bannon.jpg) <!-- .element: style="max-height: 160px;" -->

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
  <thead>
    <th>Filter</th>
    <th>Query</th>
    <th>Match</th>
  </thead>
  <tbody>
    <tr>
      <th>Lowercase</th>
      <td>iPhone</td>
      <!-- <td>&#8781;</td> -->
      <td>iphone</td>
    </tr>
    <tr>
      <th>Stemming</th>
      <td>Runner</td>
      <!-- <td>&#8781;</td> -->
      <td>Running</td>
    </tr>
    <tr>
      <th>Synonyms</th>
      <td>Car</td>
      <!-- <td>&#8781;</td> -->
      <td>Automobile</td>
    </tr>
    <tr>
      <th>Word delimiters</th>
      <td>Show-off</td>
      <!-- <td>&#8781;</td> -->
      <td>Show off</td>
    </tr>
    <tr>
      <th>ASCII Folding</th>
      <td>Nestl&eacute;</td>
      <!-- <td>&#8781;</td> -->
      <td>Nestle</td>
    </tr>
    <tr>
      <th>Pattern Replace</th>
      <td>+1 (888) 386-5501</td>
      <!-- <td>&#8781;</td> -->
      <td>8883865501</td>
    </tr>
    <tr>
      <th>Edge NGram</th>
      <td>ela</td>
      <!-- <td>&#8781;</td> -->
      <td>elasticsearch</td>
    </tr>
  </tbody>
</table>

---

### Relational vs Non-Relational

![Relational vs Non-Relational Databases](images/diagrams/relational-vs-nonrelational.jpg#diagram)

---


### Relational vs Document Model

![Relational vs Document Model](images/diagrams/relational-vs-document-model.png#diagram)
