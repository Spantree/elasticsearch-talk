class elasticsearch_node(
  $elasticsearch_version = '1.3.2',
  $user = 'elasticsearch',
  $group = 'elasticsearch'
) {
  $es_heap_size = floor($memorysize_mb * 0.6)

  $elasticsearch_publish_host = $vm_type ? {
    'vagrant' => $ipaddress_eth1,
    default   => $ipaddress_eth0
  }

  class { 'elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${elasticsearch_version}.deb",
    status => 'enabled',
    init_defaults => {
      'ES_HEAP_SIZE' => "${es_heap_size}m"
    },
    autoupgrade => true,
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
      },
      discovery => {
        zen => {
          ping => {
            multicast => {
              enabled => false
            },
            unicast => {
              hosts => ["192.168.80.100[9300]", "192.168.80.101[9300]"]
            }
          }
        }
      }
    }
  }

  elasticsearch::plugin{'mobz/elasticsearch-head':
    module_dir  => 'head'
  }

  elasticsearch::plugin { 'elasticsearch/marvel/latest':
    module_dir  => 'marvel'
  }

  elasticsearch::plugin { 'polyfractal/elasticsearch-inquisitor':
    module_dir  => 'inquisitor'
  }

  file { '/etc/elasticsearch/analysis':
    ensure => 'directory',
    owner => $user,
    group => $group
  }

  file { '/etc/elasticsearch/analysis/first_name.synonyms.txt':
    ensure => file,
    source  => "puppet:///modules/elasticsearch_node/etc/elasticsearch/analysis/first_name.synonyms.txt",
    owner => $user,
    group => $group,
    require => File['/etc/elasticsearch/analysis']
  }
}