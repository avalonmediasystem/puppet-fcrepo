class fedora::config(
  $fedora_base          = '/usr/share',
  $fedora_home          = '/usr/share/fedora',
  $user                 = 'tomcat',
  $version              = 'latest',
  $fedora_admin_pass    = 'fedoraAdmin',
  $group                = 'tomcat',
  $java_version         = '1.7.0',
  $tomcat_http_port     = '8080',
  $tomcat_https_port    = '8443',
  $tomcat_shutdown_port = '8005',
  $fedora_context       = 'fedora',
  $messaging_uri        = '',
  $ri_enabled           = 'true',
  $tomcat_home          = '',
  $server_host          = fqdn
) {
	include staging
 
  if $messaging_uri == '' {
    $messaging_enabled = 'false'
  } else {
    $messaging_enabled = 'true'
  }
 
  if $tomcat_https_port == '' {
    $ssl_available = 'false'
  } else {
    $ssl_available = 'true'
  }

	$propfile = "${staging::path}/fedora/installer.properties"
  concat { $propfile: }

  if $tomcat_home == '' {
	  $install_tomcat = 'true'
  } else {
  	$install_tomcat = 'false'
  	concat::fragment { 'fedora-tomcat-properties':
  		content => template('fedora/fedora_tomcat_properties.erb'),
  		target => $propfile
  	}
  }

  concat::fragment { 'fedora-defaults':
    content => template('fedora/fedora_installer_properties.erb'),
    target  => $propfile
  }

}