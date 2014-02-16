class elasticsearch_talk(
  $sense_root = '/usr/share/elasticsearch/plugins/marvel/_site/sense',
  $editor_replace_file = 'spantree.senseEditorReplace.js'
) {
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
}