node 'es1.local' {
	# Virtual Machines
	class { 'java7': }

	class { 'elasticsearch_node':
		require => Class['java7']
	}
}