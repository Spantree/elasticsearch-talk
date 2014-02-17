node default {
  $node_version = 'v0.10.25'
  $elasticsearch_version = '1.0.0'

	# Virtual Machines
	class { 'java7': }

  # Runtimes
  class { 'groovy':
    version     => '2.2.1',
    require     => Class['java7']
  }

  # Build systems
  class { 'gradle':
    version     => '1.11',
    require     => Class['java7']
  }

  # Web Servers

  class { 'nginx': }

  file { '/etc/nginx/conf.d/default.conf':
    source      => 'puppet:///modules/elasticsearch_talk/etc/nginx/default.conf',
    require     => Class['nginx::package'],
    notify      => Service['nginx']
  }

  class { 'nodejs':
    version => $node_version,
  }

  package { 'grunt-cli':
    provider => npm,
    require => Class['nodejs']
  }

  # Presentation

  class { 'revealjs':
    presentation_dir => '/usr/src/elasticsearch-talk/presentation',
    node_home        => "/usr/local/node/node-${node_version}",
    require          => Package['grunt-cli']
  }

  # Hotness
  class { 'elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${elasticsearch_version}.deb",
    require     => Class['java7'],
    config      => {
      'http' => {
        'max_content_length'=> '500mb'
      }
    }
	}

  elasticsearch::plugin{'mobz/elasticsearch-head':
    module_dir  => 'head'
  }

  elasticsearch::plugin { 'elasticsearch/marvel/latest':
    module_dir  => 'marvel'
  }

  class {'elasticsearch_talk' :
    require     => [
      Class['groovy'],
      Elasticsearch::Plugin['elasticsearch/marvel/latest']
    ]
  }
}