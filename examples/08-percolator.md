# Percolation: search, in reverse

## Register a percolation query

Percolation queries allow you to search in reverse.  Instead of adding documents and then providing a query, you add queries first and then provide documents to see which queries they match. This is very useful for things like RSS feeds and notification systems.

First, we will register a percolation query for the phrase 'earl grey'.

`PUT /wikipedia/.percolator/1`

```json
{
	"query" : {
		"match" : {
			"body" : "earl grey"
		}
	}
}
```

## See If Malynda Likes Earl Grey

This newly-added document will provide no matches for the percolation query.

`GET /wikipedia_percolation/aboutus/_percolate `

```json
{
	"doc" : {
		"title" : "Favorite Office Drinks",
		"body" : "Malynda likes to drink peppermint tea"
	}
}
```

## See If Gary Likes Earl Grey

However, this one will match.

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