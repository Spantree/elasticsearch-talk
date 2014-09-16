## Aggregations


### Buckets vs Metrics

* Buckets - Classify your data
* Metrics - Analyze your data


### Buckets

* **Terms** - Break up the data based on text / keywords
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,L5)
* **Histograms** - Define an interval to break up the data
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,L140)


### Custom Buckets

* Bucket by defined ranges

[API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,L40)


### Metrics - Statistics

* **Stats** - Common statistics for your data

* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,S7.4)

* **Extended Stats** - More statistics for your data

* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,S7.5)


### Metrics - Percentiles

* Approximate, not exact
* Still incredidbly good
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,S7.7)

### Aggregations as a User Experience


### Terms Facets
* Enable visual filters
* Better inform choices


### Top Hits
* Meld two types of products
* Create Google Ads-esque design with one query
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,L171)


### Subaggregations
* Enables processing of several different facets in memory
* Enables complex graphs and visualizations
* [API Example](http://esdemo.local:9200/_plugin/marvel/sense/#07-aggregations,L203)