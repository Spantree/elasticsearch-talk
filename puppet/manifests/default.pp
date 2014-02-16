node default {
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
    source      => 'puppet:///modules/elasticsearch_talk/default.conf',
    require     => Class['nginx::package'],
    notify      => Service['nginx']
  }

  # Hotness
  class { 'elasticsearch':
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.deb',
    require     => Class['java7']
	}

  elasticsearch::plugin{'mobz/elasticsearch-head':
    module_dir  => 'head'
  }

  elasticsearch::plugin { 'elasticsearch/marvel/latest':
    module_dir  => 'marvel'
  }

  class {'elasticsearch_talk' :
    require     => Class['groovy']
  }
}