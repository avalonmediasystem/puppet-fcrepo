# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

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
 
  file { "${staging::path}/fcrepo":
    ensure => directory
  }

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

	$propfile = "${staging::path}/fcrepo/installer.properties"
  concat { $propfile: 
    require => File["${staging::path}/fcrepo"]
  }

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
