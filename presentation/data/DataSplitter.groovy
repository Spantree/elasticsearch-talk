#!/usr/bin/env groovy

import groovy.json.JsonSlurper
import groovy.json.JsonBuilder

// remove any old files starting with `location_`
new File('.').eachFileMatch( ~/(location.*|bulk)\.json/) { oldFile ->
	oldFile.delete()
}

// read in the long json string
def jsonStr = new File("wikipedia_locations.json").text
// slurp the json into objects
def slurper = new JsonSlurper()
def json = slurper.parseText(jsonStr)

def bulkFile = new File('bulk.json')

// for each location under the `results` property
json.results.each { location ->
	// calculate a slug, replacing whitespace and punctuation with underscores
	String slug = location.wikipedia_id.replaceAll(/\W+/, '_').toLowerCase()
	// construct a filename using the slug
	String filename = "location_${slug}.json"
	location.id = slug
	// write the location json file to the calculated filename
	def docBuilder = new JsonBuilder(location)
	new File(filename) << docBuilder.toPrettyString()
	
	def commandBuilder = new JsonBuilder([index: [_id: slug]])
	
	bulkFile << commandBuilder.toString() << '\n'
	bulkFile << docBuilder.toString() << '\n'
}