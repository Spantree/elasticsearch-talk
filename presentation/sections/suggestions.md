## Suggestions


### Several types of suggestions


### Some definitions of suggestions

* **Autocorrect** Pick closest known terms
* **Autocomplete** Predict rest of query
* **Autosuggest** Predict alternate queries


### Autocorrect

* Term suggester
* Phrase suggester


### Term suggester

* Edit distance (Levenshtein)


### Term suggester
[Term API Examples](http://esdemo.local:9200/_plugin/marvel/sense/#10-suggesters,S10.1)


### Phrase suggester

* How to correct multiple terms?
* **Language model** for word likelihood 
* **Generators** to pick candidates
* **Smoothing models** for scoring candidates


### Phrase suggester
[Phrase API Examples](http://esdemo.local:9200/_plugin/marvel/sense/#10-suggesters,S10.2)


### Autocomplete

* Completion suggester
* Context suggester


### Completion suggester

* Manually add suggestions
* If "input" then suggest "output"
* Allows fuzzy queries
* Suggestions can have payloads


### Completion suggester
[Completion API Examples](http://esdemo.local:9200/_plugin/marvel/sense/#10-suggesters,S10.3)


### Context suggester

* Define special completion field in mapping
* Maintain completions by category or geolocation


### Context suggester
[Context API Examples](http://esdemo.local:9200/_plugin/marvel/sense/#10-suggesters,S10.9)


### Autosuggest

* Data science tools -> Elasticsearch

