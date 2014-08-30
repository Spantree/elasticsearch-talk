define elasticsearch_talk::index(
  $bulk_file = '',
  $mapping_file = 'empty.json',
  $bulk_file_dir = "/usr/src/elasticsearch-talk/data/bulk",
  $mapping_file_dir = "/usr/src/elasticsearch-talk/data/mappings",
  $delete_only = false,
  $max_split_lines = 10000
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
    tries => 5,
    try_sleep => 5,
    returns => [0, 7]
  }

  if(!$delete_only) {
    $pause_payload = '{"index": {"refresh_interval": "60s"}}'
    $restart_payload = '{"index": {"refresh_interval": "1s"}}'

    exec { "create-index-${name}":
      command => "curl -f -s -S -XPOST --data-binary \"@${mapping_file}\" http://localhost:9200/${name}",
      cwd => $mapping_file_dir,
      tries => 5,
      try_sleep => 10,
      require => Exec["delete-index-${name}"]
    }

    exec { "pause-refresh-interval-${name}":
      command => "curl -f -s -S -XPUT http://localhost:9200/${name}/_settings -d '${pause_payload}'",
      require => Exec["create-index-${name}"]
    }

    exec { "extract-${bulk_file}":
      command => "tar xzvf ${bulk_file}.tar.gz -C /tmp/",
      cwd => $bulk_file_dir
    }

    $split_file_pattern = "find /tmp -iname '${bulk_file}.*[0-9]'"

    exec { "remove-${name}-splits":
      command => "$split_file_pattern -exec rm {} \\;",
      cwd => '/tmp',
      returns => [0, 2]
    }

    exec { "split-${name}":
      command => "split -d -a 5 -l ${max_split_lines} ${bulk_file} ${bulk_file}.",
      cwd => '/tmp',
      require => Exec["remove-${name}-splits"]
    }

    exec { "bulk-insert-${name}":
      command => "${split_file_pattern} -exec curl -f -s -S -XPOST --data-binary \"@{}\" http://localhost:9200/${name}/_bulk \\;",
      cwd => '/tmp/',
      require => [
        Exec["pause-refresh-interval-${name}"],
        Exec["split-${name}"]
      ],
      logoutput => on_failure,
      timeout => 0
    }

    exec { "restart-refresh-interval-${name}":
      command => "curl -f -s -S -XPUT http://localhost:9200/${name}/_settings -d '${restart_payload}'",
      require => Exec["bulk-insert-${name}"],
      tries => 5,
      try_sleep => 5
    }
  }
}