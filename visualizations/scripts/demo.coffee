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
  $pb = $('.progress-bar')

  setProgressBarStatus = (percentage) ->
    $pb.css('width', "#{percentage}%")
    $pb.attr('aria-valuenow', percentage)
    # $pb.html("#{percentage}%")

  setProgressBarStatus 10

  days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']

  $scope.resetAll = () ->
    dc.filterAll()
    dc.redrawAll()

  dateFormat = d3.time.format "%A %B %e, %Y"

  dateAgg = new DateHistogramAggregation
      name: 'date_of_trip'
      field: 'start_time'
      interval: '1h'
      dimensionFunction: (d) -> d3.time.day.floor(d.date_of_trip)
      chartPostSetup: (c) ->
        # c.stack $scope.date_of_trip_group, "Rides per Day", (d) -> d.value
        c.group $scope.date_of_trip_group, "Rides per Day"
      chartOptions:
        title: (d) ->
          "#{dateFormat(d.key)}\n#{d.value} rides"


  aggregations = [
    dateAgg

    new TermsAggregation
      name: 'rider_type'
      field: 'user_type'

    new TermsAggregation
      name: 'gender',
      field: 'gender'
    
    new HistogramAggregation
      name: 'age'
      field: 'age'

    new HistogramAggregation
      name: 'trip_duration'
      field: 'trip_duration'
      interval: 60
      dimensionFunction: (d) -> d3.round(d.trip_duration)/60
  ]

  updateTimeout = null

  updateProgressBar = (min, max) ->
    v = Number.parseInt($pb.attr('aria-valuenow'))
    if(v < max)
      setProgressBarStatus v + 1
      updateTimeout = setTimeout _.partial(updateProgressBar, min, max), 100

  es = new elasticsearch.Client
    host: 'esdemo.local:9200'
    log: 'debug'

  aggregationBody = buildAggregationBody(aggregations)

  setProgressBarStatus 20

  updateProgressBar 20, 100

  es.search
    index: 'divvy'
    body:
      aggs: aggregationBody
  .then (resp) ->
    clearTimeout(updateTimeout)

    data = flattenAggregationResults(aggregations, resp.aggregations)

    window.ndx = crossfilter(data)

    for agg in aggregations
      agg.applyToCrossfilter(ndx)
      $scope["#{agg.name}_dimension"] = agg.dimension
      $scope["#{agg.name}_group"] = agg.group
      $scope["#{agg.name}_chart_post_setup"] = agg.chartPostSetup
      $scope["#{agg.name}_chart_options"] = agg.chartOptions

    $scope.day_of_week_dimension = ndx.dimension (d) ->
      d.date_of_trip.getDay()

    $scope.day_of_week_group = $scope.day_of_week_dimension.group().reduceSum(dateAgg.reduceSumFunction)

    $scope.day_of_week_post_setup = (c) ->
      c.label (d) ->
        days[d.key]
      .xAxis().ticks(4)

    $scope.hour_of_day_dimension = ndx.dimension (d) ->
      d.date_of_trip.getHours()

    $scope.hour_of_day_group = $scope.hour_of_day_dimension.group().reduceSum(dateAgg.reduceSumFunction)

    $scope.hour_of_day_post_setup = (c) ->
      c.xAxis().tickFormat (v) ->
        if v == 0 then "Midnight" else if v < 12 then "#{v}am" else "#{v-12}pm"
      .ticks(6)

    $scope.$apply()

    $('#loading').css('display', 'none')
    $('#charts').css('display', 'table')

