## Suggestions


### Why do you mean by a suggestion?

* **Autocorrect** Pick closest known terms
* **Autocomplete** Predict rest of query
* **Autosuggest** Predict alternate queries


### Autocorrect

* Term suggester
* Phrase suggester


### Why do you mean by a suggestion?

* **Autocorrect** Pick closest known terms
* **Autocomplete** Predict rest of query
* **Autosuggest** Predict alternate queries


### Autocorrect

* Term suggester
* Phrase suggester


### Term suggester

* Edit distance (Levenshtein)


### Phrase suggester

* How to correct multiple terms?
* **Language model** for word likelihood 
* **Generators** to pick candidates
* **Smoothing models** for scoring candidates


### Autocomplete

* Completion suggester
* Context suggester


### Completion suggester

* Manually add suggestions
* If "input" then suggest "output"
* Allows fuzzy queries
* Suggestions can have payloads


### Context suggester

* Define special completion field in mapping
* Maintain completions by category or geolocation


### Autosuggest

* Data science tools + Elasticsearch

