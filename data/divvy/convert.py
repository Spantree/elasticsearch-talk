import json
import csv
import datetime
from dateutil.parser import parse

stations_in = open('stations.in','r')
station_reader = csv.reader(stations_in)
next(station_reader)

trips_in = open('trips.in','r')
trip_reader = csv.reader(trips_in)
next(trip_reader)
name_id_map = {}

dayOfWeekMap = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

def get_date(str):
  date_field = str.split(' ')[0]
  date_fields = date_field.split('-')
  return datetime.date(int(date_fields[0]),int(date_fields[1]), int(date_fields[2]))

for trip_fields in trip_reader:
  trip_map = {}
  index_map = {"index": {"_type": "trip", "_id": trip_fields[0]}}
  
  start_time = parse(trip_fields[1])
  end_time = parse(trip_fields[2])

  trip_map['trip_id'] = int(trip_fields[0])
  trip_map['start_time'] = start_time.strftime('%m/%d/%Y %H:%M')
  trip_map['end_time'] = end_time.strftime('%m/%d/%Y %H:%M')
  trip_map['hour_of_day'] = start_time.strftime('%H')
  trip_map['bike_id'] = int(trip_fields[3])
  trip_map['trip_duration'] = int(trip_fields[4].replace(",", ""))
  trip_map['from_station_id'] = trip_fields[5]
  trip_map['from_station_name'] = trip_fields[6]
  trip_map['to_station_id'] = trip_fields[7]
  trip_map['to_station_name'] = trip_fields[8]
  trip_map['user_type'] = trip_fields[9].title()
  trip_map['gender'] = trip_fields[10].title() or "Undisclosed"
  trip_map['birth_year'] = trip_fields[11].strip()
  if trip_map['birth_year'] != '':
    trip_map['age'] = 2013 - int(trip_map['birth_year'])
  else:
    trip_map['age'] = -1

  weekday = start_time.weekday()
  trip_map['day_of_week'] = dayOfWeekMap[weekday]

  name_id_map[trip_map['from_station_name']] = trip_map['from_station_id']
  name_id_map[trip_map['to_station_name']] = trip_map['to_station_id']

  print json.dumps(index_map)
  print json.dumps(trip_map)

for station_fields in station_reader:
  index_map = {"index": {"_type": "station", "_id": name_id_map[station_fields[0]]}}

  station_map = {}
  station_map['name'] = station_fields[0]
  location_map = {}
  location_map['lat'] = float(station_fields[1])
  location_map['lon'] = float(station_fields[2])
  station_map['location'] = location_map
  station_map['capacity'] = int(station_fields[3].strip())

  print json.dumps(index_map)
  print json.dumps(station_map)
