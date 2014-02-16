# Pain points

## Relational Database vs NoSQL vs Elasticsearch

Data store types, expected interaction

RDBMS:

* SELECT * FROM Person WHERE FirstName = "Edgar" And LastName = "Codd" INNER JOIN Scientist ON Person.ID = Scientist.ID

Other NoSQL:

* db.Spantree.find({name: "Eric", lastName: "Evans"})
* GET "Eric Brewer"
* MATCH (a:Person { name:"Emil Eifrem" }) RETURN a

Elasticsearch:

```{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "vannevar bush"
          }
        }
      ]
    }
  }
}```

## SQL Queries

In a large database with a complex schema, queries become:

* Complex - due to the amount of entities
* Slow(er) - due to the amount of data

## Text analysis

When dealing with text, we often want to find

* "Runner" when searching for "running" (stemming)
* "Car" whean searching for "automobile" (synonyms)
* "Show-off" when searching for "show off" (word delimiter)
* "Nestlé" when searching for "nestle" (ascii folding)
* et cetera

## Highlighting

When searching a large section of text, we want to see the whole text and the portions that match

* "be" should yield "to <em>be</em> or not to <em>be</em>"

## Infrastructure

For many applications, you'll want

* Load balancing
* Redundancy
* Monitoring

And you don't want to have to put too much effort into it!

## Scoring/Boosting

When searching for "shiny product", you'll want

* "product is shiny and reasonably priced" to come up before "the product is very dull and expensive"
* unless, of course, your pointy-haired boss wants the latter to come up first!

## Relational Databases with Full Text Search vs Elasticsearch

* [List of relational databases with full-text search]
* Similar ideas, but sometimes... 
    * harder to configure
    * lack analysis features
    * closed source/expensive
    
## Specialization means…

* Search relevance and speed is more important than 
    * data consistency
    * memory/storage savings
    * flexible result output 
    
## Solr vs Elasticsearch

Elasticsearch

* is easier to configure
* has nested data structure
* other nuances


