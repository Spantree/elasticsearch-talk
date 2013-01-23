node default {
	# Structure
	stage { 'first': before => Stage['main'] }
    stage { 'last': }
    Stage['main'] -> Stage['last']

    # Linuxy Stuff
	class { "aptupdate": stage => "first" }
	class { "curl": stage => "first" }

	# Virtual Machines
	class { "java": stage => "first" }

	# Runtimes
	class { "groovy": }

	# Hotness
	class { "elasticsearch": version => "0.20.2" }
}
