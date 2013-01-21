class curl {
	package { "curl":
		ensure => present,
		provider => apt
	}
}