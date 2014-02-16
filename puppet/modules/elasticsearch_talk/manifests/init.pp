class elasticsearch_talk {
  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin',
      '/usr/share/groovy/bin', '/opt/gradle/bin/'
    ]
  }

  exec { 'create-sense-files':
    command => "gradle transform",
    cwd     => "/usr/src/elasticsearch-talk/transform",
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
}