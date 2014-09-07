node default {
  $node_version = 'v0.10.31'

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
    make_install => false
  }

  package { ['grunt-cli', 'bower', 'coffee-script']:
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
  class { 'elasticsearch_node':
    require => Class['java7']
  }

  class {'elasticsearch_talk' :
    require     => [
      Class['groovy'],
      Class['elasticsearch_node'],
      Service['elasticsearch']
    ]
  }
}