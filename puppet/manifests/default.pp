node default {
  $node_version = 'v0.10.31'
  $elasticsearch_version = '1.3.2'


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

  $es_heap_size = floor($memorysize_mb * 0.6)

  $elasticsearch_publish_host = $vm_type ? {
    'vagrant' => $ipaddress_eth1,
    default   => $ipaddress_eth0
  }

  # Hotness
  class { 'elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${elasticsearch_version}.deb",
    status => 'enabled',
    init_defaults => {
      'ES_HEAP_SIZE' => "${es_heap_size}m"
    },
    config => {
      http => {
        max_content_length => '500mb'
      },
      network => {
        publish_host => $elasticsearch_publish_host,
        bind_host => '0.0.0.0'
      },
      cluster => {
        routing => {
          allocation => {
            cluster_concurrent_rebalance => 2
          }
        }
      },
      marvel => {
        agent => {
          enabled => $enable_marvel_agent
        }
      },
      bootstrap => {
        mlockall => true
      },
      indices => {
        fielddata => {
          cache => {
            size => '25%'
          }
        }
      }
    },
    require => Class['java7'],
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
      Class['elasticsearch'],
      Elasticsearch::Plugin['elasticsearch/marvel/latest']
    ]
  }
}