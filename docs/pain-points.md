# Pain points

## Relational Database vs NoSQL vs Elasticsearch

Data store types, expected interaction

RDBMS:

* SELECT * FROM Person WHERE FirstName = "Edgar" And LastName = "Codd" INNER JOIN Scientist ON Person.ID = Scientist.ID


NoSQL:

* db.Spantree.find {name: "Eric", lastName: "Evans"}
* [Column]
* [Key-value]
* [Graph]

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

## What happens when you use a relational database for search?



## Relational Databases with Full Text Search

* [List of relational databases with full-text search]
* Similar ideas, but 
    * not specialized
    * tougher to configure

## Specialization means…

* Search relevance and speed is more important than 
    * data consistency
    * memory/storage savings
    * flexible result output 



## Languages
## SQL query performance
## SQL query complexity
## User-defined filters
## Highlighting
## Scaling
## NLP (Type what you want freeform)
## Statistics
