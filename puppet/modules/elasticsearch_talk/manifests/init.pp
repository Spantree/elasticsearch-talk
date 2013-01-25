class elasticsearch_talk {
	file { "/home/vagrant/es-repl":
		ensure => "link",
		target => "/home/vagrant/scripts/repl"
	}

	file { "/home/vagrant/split-data":
		ensure => "link",
		target => "/home/vagrant/scripts/split-data"
	}
}