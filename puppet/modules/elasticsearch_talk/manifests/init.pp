class elasticsearch_talk(
  $sense_root = '/usr/share/elasticsearch/plugins/marvel/_site/sense',
  $editor_replace_file = 'spantree.senseEditorReplace.js',
  $src_dir = '/usr/src/elasticsearch-talk'
) {
  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin',
      '/usr/share/groovy/bin', '/opt/gradle/bin/'
    ]
  }

  $transform_dir = "${src_dir}/transform"

  exec { 'copy-transform-dependencies':
    command => "gradle copyDependencies",
    cwd => $transform_dir,
    creates => "${transform_dir}/lib"
  }

  exec { 'create-sense-files':
    command => "groovy -cp \"lib/*\" src/main/groovy/net/spantree/elasticsearch/talk/TransformExamples.groovy",
    cwd => $transform_dir,
    require => Exec['copy-transform-dependencies']
  }

  file { '/var/www':
  	ensure => directory,
  	owner   => 'root',
  	group  => 'root'
  }

  exec { 'copy-sense-files':
  	command => 'cp -f * /var/www/',
  	cwd     => '/usr/src/elasticsearch-talk/transform/www',
  	user    => 'root',
  	group   => 'root',
  	require => [
  		File['/var/www'],
  		Exec['create-sense-files']
  	]
  }

  file { "${sense_root}/app/${editor_replace_file}":
    ensure  => file,
    source  => "puppet:///modules/elasticsearch_talk/sense/app/${editor_replace_file}"
  }

  $sense_line_to_add = template('elasticsearch_talk/sense/add_to_index.html.erb')

  exec { 'add-editor-replace-to-sense-html':
    command   => "sed -i -e 's|</body>|${sense_line_to_add}</body>|' index.html",
    cwd       => "${sense_root}",
    unless    => "cat index.html | grep '${editor_replace_file}'",
    require   => File["${sense_root}/app/${editor_replace_file}"],
    logoutput => on_failure
  }

  class { 'elasticsearch_talk::visualizations':
    src_dir => "${src_dir}/visualizations"
  }

  class { 'elasticsearch_talk::elk':
    backend_hostname => 'esdemo.local',
    frontend_hostname => 'kibana.local'
  }

  if($do_reindex == 'true') {
    elasticsearch_talk::index { 'getting-started':
      delete_only  => true
    }

    elasticsearch_talk::index { 'spantree':
      delete_only  => true
    }

    elasticsearch_talk::index { 'wikipedia':
      bulk_file    => 'wikipedia.locations.json.bulk',
      mapping_file => 'wikipedia.locations.mappings.json'
    }

    elasticsearch_talk::index { 'freebase':
      bulk_file    => 'films.json.bulk',
      mapping_file => 'films.mappings.json'
    }

    exec { 'delete-inappropriate-films':
      command => "curl -XDELETE -f -s -S --data-binary \"@films-delete-inappropriate-query.json\" http://localhost:9200/freebase/film/_query",
      require => Elasticsearch_talk::Index['freebase'],
      cwd => "/usr/src/elasticsearch-talk/data/bulk"
    }

    elasticsearch_talk::index { 'wikipedia-mappings-simple':
      delete_only  => true
    }

    elasticsearch_talk::index { 'wikipedia-mappings-phone':
      delete_only  => true
    }

    elasticsearch_talk::index { 'wikipedia-mappings-edgengrams':
      delete_only  => true
    }

    elasticsearch_talk::index { 'wikipedia-mappings-multifield':
      delete_only  => true
    }

    elasticsearch_talk::index { 'wikipedia-mappings-stemmed':
      delete_only  => true
    }

    elasticsearch_talk::index { 'wikipedia-mappings-synonyms':
      delete_only  => true
    }

    # class { 'elasticsearch_talk::divvy': }

    elasticsearch_talk::index { "divvy":
      bulk_file     => 'divvy.json.bulk',
      mapping_file  => 'divvy.mappings.json'
    }
  }
}