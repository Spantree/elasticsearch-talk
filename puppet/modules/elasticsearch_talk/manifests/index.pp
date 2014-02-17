define elasticsearch_talk::index(
  $bulk_file = '',
  $mapping_file = 'empty.json',
  $bulk_file_dir = "/usr/src/elasticsearch-talk/data/bulk",
  $mapping_file_dir = "/usr/src/elasticsearch-talk/data/mappings",
) {
  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin'
    ],
    logoutput => true
  }

  exec { "delete-index-${name}":
    command => "curl -s -S -XDELETE http://localhost:9200/${name}",
  }

  $pause_payload = '{"index": {"refresh_interval": "-1"}}'
  $restart_payload = '{"index": {"refresh_interval": "1s"}}'

  exec { "create-index-${name}":
    command => "curl -s -S -XPOST --data-binary \"@${mapping_file}\" http://localhost:9200/${name}",
    cwd => $mapping_file_dir,
    require => Exec["delete-index-${name}"]
  }

  exec { "pause-refresh-interval-${name}":
    command => "curl -s -S -XPUT http://localhost:9200/${name}/_settings -d '${pause_payload}'",
    require => Exec["create-index-${name}"]
  }

  exec { "bulk-insert-${name}":
    command => "curl -s -S -XPOST --data-binary \"@${bulk_file}\" http://localhost:9200/${name}/_bulk",
    cwd => $bulk_file_dir,
    require => Exec["pause-refresh-interval-${name}"],
    logoutput => on_failure
  }

  exec { "restart-refresh-interval-${name}":
    command => "curl -s -S -XPUT http://localhost:9200/${name}/_settings -d '${restart_payload}'",
    require => Exec["bulk-insert-${name}"]
  }
}