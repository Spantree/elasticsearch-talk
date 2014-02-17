class elasticsearch_talk::divvy{
  exec {'unzip trips.in':
    command => "gunzip -c trips.in.gz > trips.in",
    cwd     => "/usr/src/elasticsearch-talk/data/divvy",
    creates => "/usr/src/elasticsearch-talk/data/divvy/trips.in"
  }
  exec {'create bulk divvy script':
    command => "python convert.py > /usr/src/elasticsearch-talk/data/bulk/divvy_bulk_update.json",
    cwd     => "/usr/src/elasticsearch-talk/data/divvy",
    creates => "/usr/src/elasticsearch-talk/data/bulk/divvy_bulk_update.json",
    require => Exec['unzip trips.in']
  }
}