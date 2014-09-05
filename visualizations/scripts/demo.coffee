class Aggregation
  dimension: null
  group: null

  constructor: (opts) ->
    _.assign(@, opts)
    if not @name
      throw new Error('Name is not defined')

  chartPostSetup: () ->

  bucketKey: (bucket) -> bucket.key
  bucketCount: (bucket) -> bucket.doc_count

  mapBucket: (bucket) ->
    key: @bucketKey(bucket)
    count: @bucketCount(bucket)

  dimensionFunction: (d) => d[@name]

  reduceSumFunction: (d) => d.count

  applyToCrossfilter: (ndx) ->
    @dimension = ndx.dimension(@dimensionFunction)
    @group = @dimension.group().reduceSum(@reduceSumFunction)

class DateHistogramAggregation extends Aggregation
  constructor: (opts) ->
    super opts
    @interval = @interval || 'day'
    if not @field
      throw new Error("Date histogram field for '#{@name}' is not defined")

  aggregator: ->
    date_histogram:
      field: @field
      interval: @interval

  bucketKey: (bucket) -> new Date(bucket.key_as_string)

class HistogramAggregation extends Aggregation
  constructor: (opts) ->
    super opts
    @interval = @interval || 1
    if not @field
      throw new Error("Histogram field for '#{@name}' is not defined")

  aggregator: ->
    histogram:
      field: @field
      interval: @interval

class TermsAggregation extends Aggregation
  constructor: (opts) ->
    super opts
    if not @field
      throw new Error("Terms field for '#{@name}' is not defined")

  aggregator: ->
    terms:
      field: @field

window.angular.module 'app', ['angularDc']

buildAggregationBody = (aggregations) ->
  body = {}
  first = _.first(aggregations)
  rest = _.rest(aggregations)
  body[first.name] = first.aggregator()
  if rest.length > 0
    body[first.name].aggs = buildAggregationBody(rest)
  body

flattenAggregationResults = (aggregations, results, parentData) ->
  parentData = parentData || new Object
  aggregation = _.first(aggregations)
  childAggregations = _.rest(aggregations)
  buckets = results[aggregation.name].buckets
  data = []
  for bucket in buckets
    obj = _.clone(parentData)
    obj[aggregation.name] = aggregation.bucketKey(bucket)
    if(childAggregations.length == 0)
      obj.count = aggregation.bucketCount(bucket)
      data.push obj
    else
      children = flattenAggregationResults(childAggregations, bucket, obj)
      for child in children
        data.push child
  data

window.myController = ($scope) ->
  $scope.resetAll = () ->
    dc.filterAll()
    dc.redrawAll()

  aggregations = [
    new TermsAggregation
      name: 'gender',
      field: 'gender'
    new DateHistogramAggregation
      name: 'date_of_trip'
      field: 'start_time'
    new HistogramAggregation
      name: 'age'
      field: 'age'
    new HistogramAggregation
      name: 'trip_duration'
      field: 'trip_duration'
      interval: 60
      dimensionFunction: (d) -> d3.round(d.trip_duration)/60
  ]

  es = new elasticsearch.Client
    host: 'esdemo.local:9200'
    log: 'debug'

  es.search
    index: 'divvy'
    body:
      aggs: buildAggregationBody(aggregations)
  .then (resp) ->
    data = flattenAggregationResults(aggregations, resp.aggregations)

    window.ndx = crossfilter(data)

    for agg in aggregations
      agg.applyToCrossfilter(ndx)
      $scope["#{agg.name}_dimension"] = agg.dimension
      $scope["#{agg.name}_group"] = agg.group
      $scope["#{agg.name}_chart_post_setup"] = agg.chartPostSetup

    $scope.$apply()

