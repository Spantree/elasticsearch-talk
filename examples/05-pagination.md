# Pagination

## Setting the Page Size

Specify a search result page size.

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "coordinates"],
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "query": "chicago"
          }
        }
      ]
    }
  },
  "size": 20
}
```

## Specifying Ranges

Specify a search result start/from value

`GET /wikipedia/_search`

```json
{
  "fields": ["name", "coordinates"],
  "query": {
    "bool": {
      "must": [
        {"query_string": {"query": "chicago"}}
      ]
    }
  },
  "size": 10,
  "from": 10
}
```

## Starting a Scan Query

For frequently-changing data sets, it is often difficult to 
keep search results consistent across pages. For example, if 
a user is sorting results by freshness, a search result once appeared in position 10 may be in position 11 by the time the second page is requested. Elasticsearch has the ability to retain a previously fetched result set via a "scan query".  This is similar to a JDBC cursor.

`GET /wikipedia/_search?search_type=scan&scroll=10m&size=10`

```json
{
  "fields": ["name", "coordinates"],
  "query": {
    "bool": {
      "must": [
        {"query_string": {"query": "chicago"}}
      ]
    }
  }
}
```

## Continuing a Scan Query

Use the field _scroll_id from the above query in the following query.

`GET /_search/scroll?scroll=10m&scroll_id={scroll_id}`