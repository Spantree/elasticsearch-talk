node default {
	stage { 'first': 
      before => Stage['main'],
    }
    stage { 'last': }
    Stage['main'] -> Stage['last']

	class { "aptupdate":
		stage => "first",
	}

	class { "curl": stage => "first" }
	
	# Virtual Machines
	class { "java": }

	# Middleware
	class { "elasticsearch": 
		version => "0.20.2"
	}
}
