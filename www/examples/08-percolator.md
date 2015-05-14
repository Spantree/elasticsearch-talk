# Percolation

## Add a sample document to seed our mappings

PUT /spantree/team/cedric
{
  "drinks": ["Red Bull"]
}

## Register a percolation query

Percolation queries allow you to search in reverse.  Instead of adding documents and then providing a query, you add queries first and then provide documents to see which queries they match. This is very useful for things like RSS feeds and notification systems.

Below are some examples based on a theoretical employee onboarding process at Spantree, where we'd like to be notified if they modify our scheduled amazon orders for various teas.

First, we will register a percolator for people who like to drink earl grey.

`PUT /spantree/.percolator/earl_grey`

```json
{
	"query" : {
		"match" : {
			"drinks": "earl grey"
		}
	}
}
```

## Add Percolator for Russian Caravan

`PUT /spantree/.percolator/russian_caravan`

```json
{
	"query" : {
		"match" : {
			"drinks": "russian caravan"
		}
	}
}
```

## See if Cedric modifies the Amazon schedule

`GET /spantree/people/_percolate`

```json
{
	"doc" : {
		"name": "Cedric",
		"drinks": [
		  "Triple Espresso",
		  "Green Tea with Brown Rice",
		  "Coconut Water"
		]
	}
}
```

## See if Kevin modifies the Amazon schedule

`GET /spantree/people/_percolate`

```json
{
	"doc" : {
		"name": "Kevin",
		"drinks": [
		  "Sodastream Energy",
		  "Dark Magic Coffee",
		  "Earl Grey Tea"
		]
	}
}
```

## Check what that percolator represents

`GET /spantree/.percolator/earl_grey`

## See If Gary modifies the Amazon schedule

`GET /spantree/people/_percolate`

```json
{
	"doc": {
		"name": "Gary",
		"drinks": [
		  "Earl Grey Tea",
		  "Russian Caravan Tea",
		  "Assam Tea"
		]
	}
}
```