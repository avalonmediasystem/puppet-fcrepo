class fcrepo::config(
  $fedora_base          = $fcrepo::params::fedora_base,
  $fedora_home          = $fcrepo::params::fedora_home,
  $user                 = $fcrepo::params::user,
  $version              = $fcrepo::params::version,
  $fedora_admin_pass    = $fcrepo::params::fedora_admin_pass,
  $group                = $fcrepo::params::group,
  $java_version         = $fcrepo::params::java_version,
  $tomcat_http_port     = $fcrepo::params::tomcat_http_port,
  $tomcat_https_port    = $fcrepo::params::tomcat_https_port,
  $tomcat_shutdown_port = $fcrepo::params::tomcat_shutdown_port,
  $fedora_context       = $fcrepo::params::fedora_context,
  $messaging_uri        = $fcrepo::params::messaging_uri,
  $ri_enabled           = $fcrepo::params::ri_enabled,
  $tomcat_home          = $fcrepo::params::tomcat_home,
  $server_host          = $fcrepo::params::server_host,
) inherits fcrepo::params {

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
  		content => template('fcrepo/fedora_tomcat_properties.erb'),
  		target => $propfile
  	}
  }

  concat::fragment { 'fedora-defaults':
    content => template('fcrepo/fedora_installer_properties.erb'),
    target  => $propfile
  }

}
