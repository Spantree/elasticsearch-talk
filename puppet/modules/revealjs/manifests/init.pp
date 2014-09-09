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
    command => "ln -sfn ${presentation_dir}/* .",
    returns => [0, 1],
    cwd     => $src_dir,
    require => Exec['revealjs-npm-install']
  }
}