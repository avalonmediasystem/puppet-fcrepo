class fedora::config(
  $fedora_base          = $fedora::params::fedora_base,
  $fedora_home          = $fedora::params::fedora_home,
  $user                 = $fedora::params::user,
  $version              = $fedora::params::version,
  $fedora_admin_pass    = $fedora::params::fedora_admin_pass,
  $group                = $fedora::params::group,
  $java_version         = $fedora::params::java_version,
  $tomcat_http_port     = $fedora::params::tomcat_http_port,
  $tomcat_https_port    = $fedora::params::tomcat_https_port,
  $tomcat_shutdown_port = $fedora::params::tomcat_shutdown_port,
  $fedora_context       = $fedora::params::fedora_context,
  $messaging_uri        = $fedora::params::messaging_uri,
  $ri_enabled           = $fedora::params::ri_enabled,
  $tomcat_home          = $fedora::params::tomcat_home,
  $server_host          = $fedora::params::server_host,
) inherits fedora::params {

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
