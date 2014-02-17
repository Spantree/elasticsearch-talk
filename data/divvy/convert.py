import json
import csv

stations_in = open('stations.in','r')
station_reader = csv.reader(stations_in)
next(station_reader)

trips_in = open('trips.in','r')
trip_reader = csv.reader(trips_in)
next(trip_reader)
name_id_map = {}

for trip_fields in trip_reader:
  trip_map = {}
  trip_map['_index'] = 'divvy'
  trip_map['_type'] = 'station'
  trip_map['_id'] = trip_fields[0]
  trip_map['trip_id'] = trip_fields[0]
  trip_map['start_time'] = trip_fields[1]
  trip_map['end_time'] = trip_fields[2]
  trip_map['bike_id'] = trip_fields[3]
  trip_map['trip_duration'] = trip_fields[4]
  trip_map['from_station_id'] = trip_fields[5]
  trip_map['from_station_name'] = trip_fields[6]
  trip_map['to_station_id'] = trip_fields[7]
  trip_map['to_station_name'] = trip_fields[8]
  trip_map['user_type'] = trip_fields[9]
  trip_map['gender'] = trip_fields[10]
  trip_map['birth_year'] = trip_fields[11].strip()

  name_id_map[trip_map['from_station_name']] = trip_map['from_station_id']
  name_id_map[trip_map['to_station_name']] = trip_map['to_station_id']

  bulk_update = {'index': trip_map}
  print json.dumps(bulk_update)

for station_fields in station_reader:
  station_map = {}
  station_map['_index'] = 'divvy'
  station_map['_type'] = 'station'
  station_map['_id'] = name_id_map[station_fields[0]]
  station_map['name'] = station_fields[0]
  location_map = {}
  location_map['lat'] = station_fields[1]
  location_map['lon'] = station_fields[2]
  location_map['location'] = location_map
  station_map['capacity'] = station_fields[3].strip()

  bulk_update = {'index': station_map}
  print json.dumps(bulk_update)
