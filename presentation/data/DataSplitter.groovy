#!/usr/bin/env groovy

import groovy.json.JsonSlurper
import groovy.json.JsonBuilder

// remove any old files starting with `location_`
new File('.').eachFileMatch( ~/location.*\.json/) { oldFile ->
	oldFile.delete()
}

// read in the long json string
def jsonStr = new File("wikipedia_locations.json").text
// slurp the json into objects
def slurper = new JsonSlurper()
def json = slurper.parseText(jsonStr)

// for each location under the `results` property
json.results.each { location ->
	// calculate a slug, replacing whitespace and punctuation with underscores
	String slug = location.wikipedia_id.replaceAll(/\W+/, '_').toLowerCase()
	// construct a filename using the slug
	String filename = "location_${slug}.json"
	// write the location json file to the calculated filename
	def out = new JsonBuilder(location)
	new File(filename) << out.toPrettyString()
}