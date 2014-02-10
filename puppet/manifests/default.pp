node default {
	# Virtual Machines
	class { 'java7': }

  # Runtimes
  class { 'groovy':
    version => '2.2.1',
    require => Class['java7']
  }

  # Hotness
  class { 'elasticsearch':
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.RC2.deb',
    require     => Class['java7']
	}

  elasticsearch::plugin{'mobz/elasticsearch-head':
    module_dir => 'head'
  }

  elasticsearch::plugin { 'elasticsearch/marvel/latest':
    module_dir => 'marvel'
  }
}
