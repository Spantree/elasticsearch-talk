# Overview
This is a compiled version of a simple beat we created to simulate completely fake, pseudo-random Apache traffic from a Beat.

The short term goals are to simply show how Logstash, Beats, etc. can play nicely together in a testing and lab environment.

# Usage
To execute the data dump, it's easiest to simply execute from the command line.

`./datadumpbeat-darwin-amd64 -e` - Starts the beat and outputs the logs to the STDERR/STDOUT