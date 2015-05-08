## Mapping, Analysis and Embedded Objects


### Automatic Mappings

* Elasticsearch will try to guess your mappings based on input
* But you can also provide them explicitly

[API Example](http://esdemo.local:9200/_plugin/marvel/sense/#04-mapping)


### Embedded Objects


## Inner object

```javascript
  [
    {
      first_name : "Gary",
      last_name : "Turovsky"
    },
    {
      first_name : "Cedric",
      last_name : "Hurst"
    }
  ]
```

### becomes

```javascript
{
    first_name : ["Gary", "Cedric"],
    last_name : ["Turovsky", "Hurst"]
}
```


## Nested 

* Maintained as separate document
* Must be explicitly defined on mapping
* Can only accessed by a nested query
* Can use "include_in_root" to also index as inner object
* Can complicate queries if there are multiple types of nested objects used


## Parent-child

* Child is a first-class document that has a special *_parent* type
* Can query on children separately from parents
* Can do "Has Child/Parent" queries
* Slower and require an in-memory *join table*