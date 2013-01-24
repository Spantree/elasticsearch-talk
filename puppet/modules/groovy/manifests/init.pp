class groovy {
	package { "groovy":
		ensure => latest;
	}

	file { "/home/vagrant/.groovy":
		ensure => directory,
		source => "puppet:///modules/groovy/.groovy",
		owner => vagrant,
		group => vagrant,
		recurse => true
	}
}
