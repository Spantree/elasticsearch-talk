# Indexing

## Indexing John Doe with an Assigned ID

`POST /spantree/people/`

```json
{
  "name": "Johnny Noname"
}
```

## Finding John in the Index

`GET /spantree/_search`

## Reviewing automatic mappings

Elasticsearch will automatically guess a mapping for new fields.

`GET /spantree/_mapping`

## Indexing Cedric with a known ID

`PUT /spantree/people/cedric`

```json
{
  "name": "Cedric Hurst",
  "title": "Principal"
}
```

## Making Sure Cedric is There

`GET /spantree/people/cedric`

## Adding More Information about Cedric

`POST /spantree/people/cedric/_update`

```json
{
  "doc": {
    "git_commits": 2560
  }
}
```

## Adding One More Git Commit for Cedric

`POST /spantree/people/cedric/_update`

```json
{
  "script": "ctx._source.git_commits += 1",
  "lang": "groovy"
}
```

## Upserting Kevin

`POST /spantree/people/kevin/_update`

```json
{
  "doc": {
    "git_commits": 1912
  },
  "upsert": {
    "name": "Kevin Greene",
    "title": "Senior Software Engineer",
    "git_commits": 1912
  }
}
```

## Making Sure Kevin is Alive

`GET /spantree/people/kevin`

## Adding Everyone Else

`POST /spantree/_bulk`

```json
{"index":{"_id":"gary","_type": "people"}}
{"name":"Gary Turovsky","title":"Senior Software Engineer","git_commits":  611}
{"index":{"_id":"jonathan","_type": "people"}}
{"name":"Jonathan Freeman","title":"Software Engineer","git_commits": 186}
```

## Reviewing the Whole List

`GET /spantree/_search`