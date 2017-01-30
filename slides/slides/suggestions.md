## Suggestions

---

### Several types of suggestions

---

### Some definitions of suggestions

* **Autocorrect** Pick closest known terms
* **Autocomplete** Predict rest of query
* **Autosuggest** Predict alternate queries

---

### Autocorrect

* Term suggester
* Phrase suggester

---

### Term suggester

* Edit distance (Levenshtein)

---

### Term suggester
[Term Suggester Examples](sense://suggestions.sense)

---

### Phrase suggester

* How to correct multiple terms?
* **Language model** for word likelihood
* **Generators** to pick candidates
* **Smoothing models** for scoring candidates

---

### Phrase suggester
[Phrase API Examples](sense://suggestions.sense#L17)

---

### Autocomplete

* Completion suggester
* Context suggester

---

### Completion suggester

* Manually add suggestions
* If "input" then suggest "output"
* Allows fuzzy queries
* Suggestions can have payloads

[Completion Suggester Examples](sense://suggestions.sense#L49)

---

### Context suggester

* Define special completion field in mapping
* Maintain completions by category or geolocation

[Context Suggester Examples](sense://suggestions.sense#L127)

---

### Autosuggest

* Data science tools -> Elasticsearch

---

### More like this

[More Like This Example](sense://more-like-this.sense)
