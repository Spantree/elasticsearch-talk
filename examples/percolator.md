# Percolation: search, in reverse

Provide a query to be checked as new documents are added later

`PUT /wikipedia_percolation/.percolator/1 `

```json
{
	"query" : {
		"match" : {
			"body" : "earl grey"
		}
	}
}
```

This newly-added document will provide no matches for the percolation query

`GET /wikipedia_percolation/aboutus/_percolate `
```json
{
	"doc" : {
		"title" : "Favorite Office Drinks",
		"body" : "Malynda likes to drink peppermint tea"
	}
}
```

This new document will provide a match for the percolation query 

`GET /wikipedia_percolation/aboutus/_percolate `
```json
{
	"doc" : {
		"title" : "Favorite Office Drinks",
		"body" : "Gary likes to drink Earl Grey tea"
	}
}
```

Percolation queries can also be filtered, given maximum number of matches, use facet definitions, etc.