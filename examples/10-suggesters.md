# Term suggester

POST /wikipedia/_suggest
{
  "term_suggestion": {
    "text": "buildng",
    "term": {
      "field": "description"
    }
  }
}

POST /wikipedia/_suggest
{
  "text": "high risk buildng",
  "simple_phrase": {
    "phrase": {
      "field": "description",
      "gram_size": 2,
      "real_word_error_likelihood": 0.95,
      "confidence": 1,
      "max_errors": 100,
      "size": 1,
      "analyzer": "standard",
      "shard_size": 5,
      "direct_generator": [
        {
          "field": "description",
          "suggest_mode": "popular",
          "max_edits": 2,
          "min_word_len": 4,
          "max_inspections": 5,
          "min_doc_freq": 0,
          "max_term_freq": 0
        }
      ]
    }
  }
}