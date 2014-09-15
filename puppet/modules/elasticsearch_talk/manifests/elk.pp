class elasticsearch_talk::elk(
  $logstash_version = '1.4.2-1-2c0f5a1',
  $kibana_version = '3.1.0',
  $log_file_archive = '/tmp/apache_log.2.bz2',
  $backend_hostname = nil,
  $frontend_hostname = nil,
  $default_dashboard = 'apachelogs'
) {
  $elasticsearch_url = "http://${backend_hostname}:9200"

  file { "${log_file_archive}":
    ensure => file,
    source => "puppet:///modules/elasticsearch_talk${log_file_archive}"
  }

  class { 'logstash':
    package_url => "https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_${logstash_version}_all.deb"
  }

  logstash::configfile { 'logstash':
    content => template('elasticsearch_talk/logstash/logstash.conf.erb')
  }

  exec { 'push-to-logstash':
    command => "bzip2 -cd ${log_file_archive} | nc localhost 3333",
    unless => "curl -XHEAD -fs http://localhost:9200/logstash-2011.08.29",
    require => [
      Class["logstash"],
      File["${log_file_archive}"]
    ]
  }

  nginx::resource::vhost { "${frontend_hostname}":
    www_root => '/opt/kibana',
  }

  class { 'kibana':
    file_content      => template('elasticsearch_talk/kibana/config.js.erb'),
    webserver         => nginx,
    version           => $kibana_version,
    virtualhost       => $frontend_hostname,
    require           => [
      Nginx::Resource::Vhost["${frontend_hostname}"]
    ]
  }

  file { '/opt/kibana/app/dashboards/':
    ensure => directory,
    source => "puppet:///modules/elasticsearch_talk/opt/kibana/app/dashboards/",
    recurse => true,
    require => Class['kibana']
  }
} 