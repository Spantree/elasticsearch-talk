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
