class pygments {
	package {
		"python-setuptools": ensure => latest;
		"python-pip": ensure => latest;
		"python-dev": ensure => latest;
		"build-essential": ensure => latest;
	}

	package {"pygments":
 		ensure => installed,
 		provider => pip,
 		require => Package["python-setuptools", "python-pip", "python-dev", "build-essential"]
 	}

 	package { "pygments-json":
 		ensure => latest,
 		provider => pip,
 		require => Package["pygments"]
 	}
}