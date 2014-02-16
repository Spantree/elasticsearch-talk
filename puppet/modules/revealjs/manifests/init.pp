class revealjs(
  $node_home = '/usr/local/node/node-default',
  $src_dir = '/usr/src/revealjs',
  $presentation_dir = nil
) {
  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin',
      "${node_home}/bin"
    ]
  }

  exec { 'revealjs-clone':
    command => "git clone https://github.com/hakimel/reveal.js.git $src_dir",
    creates => $src_dir
  }

  exec { 'revealjs-npm-install':
    command => 'npm install',
    cwd     => $src_dir,
    require => Exec['revealjs-clone']
  }

  exec { 'revealjs-link-presentation':
    command => "ln -sf ${presentation_dir}/* .",
    cwd     => $src_dir,
    require => Exec['revealjs-npm-install']
  }

  file { "/etc/init/revealjs.conf":
    ensure             => file,
    content            => template('revealjs/revealjs.conf.erb'),
    mode               => '0700',
    notify             => Service['revealjs'],
    require            => Exec['revealjs-link-presentation']
  }

  service { 'revealjs':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    provider   => 'upstart',
    require    => File["/etc/init/revealjs.conf"]
  }

}