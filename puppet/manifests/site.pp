node default {
	# Structure
	stage { 'first': before => Stage['main'] }
    stage { 'last': }
    Stage['main'] -> Stage['last']

    # Linuxy Stuff
	class { "aptupdate": stage => "first" }

	# Runtimes
	class { "java": }
	class { "groovy": stage => "last" }

	# Tools
	class { "curl": stage => "first" }
	class { "pygments": }

	# Hotness
	class { "elasticsearch":
		version => "0.20.2",
		stage => "last"
	}
}
