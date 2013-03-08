class fedora::derby($fedora_home) {
	include fedora::config

	$database 		= 'included'
	$driver   		= 'included'
	$driver_class = 'org.apache.derby.jdbc.EmbeddedDriver'
	$jdbc_url     = "jdbc:derby:${fedora_home}/derby/fedora3;create=true"
	$db_user      = "UNUSED"
	$db_pass			= "ALSO_UNUSED"
	
	concat::fragment { "fedora-database":
		ensure  => present,
		content => template('fedora/fedora_db_properties.erb'),
		target  => $fedora::config::propfile
	}
}