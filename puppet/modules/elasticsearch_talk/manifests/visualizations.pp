class elasticsearch_talk::visualizations(
  $node_home = '/usr/local/node/node-default',
  $src_dir = nil
) {
  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin',
      "${node_home}/bin"
    ],
    user => $::ssh_username
  }

  exec { 'visualizations-bower-install':
    command => 'bower install',
    cwd => $src_dir
  }

  exec { 'visualizations-coffee-compile':
    command => 'coffee -c demo.coffee',
    cwd => "${src_dir}/scripts"
  }
}