## More Queries


### Pagination

* Most cases use from / to
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#05-pagination)
* Option of using a cursor
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#05-pagination,S5.3)


### Sorting - What you expect

* Sort most fields by ascending or descending

[API Example](http://es1.local:9200/_plugin/marvel/sense/#06-sorting)


### Sorting - What you don't expect

* Tokenizers affect sorting as well
* Need to make sure you are sorting on the right field

[API Example](http://es1.local:9200/_plugin/marvel/sense/#06-sorting,S6.4)


### Count

* Doesn't return hits
* Normally leaves you wanted for more statistics