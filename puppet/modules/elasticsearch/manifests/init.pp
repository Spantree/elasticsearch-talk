class elasticsearch {
	package { "elasticsearch":
		provider => dpkg,
 		ensure   => latest,
 		source   => "/tmp/elasticsearch-0.19.8.deb",
 		require	 => [
 			File['/tmp/elasticsearch-0.19.8.deb'],
 			Class['java']
 		]
	}

	service { "elasticsearch":
	    enable => true,
		ensure => running,
		hasstatus => true,
		require => [File['/etc/init.d/elasticsearch'],
					File['/etc/elasticsearch/elasticsearch.yml'], 
					File['/etc/elasticsearch/logging.yml'],
					Package['elasticsearch']]
	}

	file { 
		'/tmp/elasticsearch-0.19.8.deb':
		ensure => present,
		source => "puppet:///modules/elasticsearch/elasticsearch-0.19.8.deb",
	}

	file {
		'/etc/init.d/elasticsearch':
		owner => root,
		group => root,
		mode => 744,
		ensure => present,
		source => "puppet:///modules/elasticsearch/etc/init.d/elasticsearch",
		notify => Service["elasticsearch"],
	}

	file {
		'/etc/elasticsearch':
		ensure => directory
	}

	file {
		'/etc/elasticsearch/elasticsearch.yml':
		ensure => file,
		content => template("elasticsearch/elasticsearch.yml.erb"),
		require => File['/etc/elasticsearch'],
		notify => Service["elasticsearch"],
	}

	file {
		'/etc/elasticsearch/logging.yml':
		ensure => present,
		recurse => true,
		source => "puppet:///modules/elasticsearch/etc/elasticsearch/logging.yml",
		require => File['/etc/elasticsearch'],
		notify => Service["elasticsearch"],
	}

	exec {
		"install-head-plugin":
		command => "/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head",
		require => Service["elasticsearch"]
	}

	exec {
		"install-bigdesk-plugin":
		command => "/usr/share/elasticsearch/bin/plugin -install lukas-vlcek/bigdesk",
		require => Service["elasticsearch"]
	}
}