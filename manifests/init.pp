class fedora(
  $fedora_base          = $fedora::params::fedora_base,
  $fedora_home          = $fedora::params::fedora_home,
  $user                 = $fedora::params::user,
  $fedora_admin_pass    = $fedora::params::fedora_admin_pass,
  $group                = $fedora::params::group,
  $tomcat_http_port     = $fedora::params::tomcat_http_port,
  $tomcat_https_port    = $fedora::params::tomcat_https_port,
  $tomcat_shutdown_port = $fedora::params::tomcat_shutdown_port,
  $fedora_context       = $fedora::params::fedora_context,
  $messaging_uri        = $fedora::params::messaging_uri,
  $ri_enabled           = $fedora::params::ri_enabled,
  $tomcat_home          = $fedora::params::tomcat_home,
  $server_host          = $fedora::params::server_host
) inherits fedora::params {

  include fedora::config

  staging::file { 'fcrepo-installer.jar':
    source  => 'http://downloads.sourceforge.net/fedora-commons/fcrepo-installer-3.6.1.jar',
    timeout => 1200,
    subdir  => 'fedora'
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
 
  package { $fedora::params::packages:
    ensure => present
  }

  file { $fedora_base:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0775'
  }
 
  concat::fragment { 'fedora-defaults':
    content => template('fedora/fedora_installer_properties.erb'),
    target  => $fedora::config::propfile,
  }
 
  exec { 'install-fedora':
    command     => "java -jar /opt/staging/fedora/fcrepo-installer.jar ${fedora::config::propfile}",
    creates     => "$fedora_home/server",
    environment => "FEDORA_HOME=${fedora_home}",
    timeout     => 1800,
    user        => $user,
    group       => $group,
    path        => ['/bin', '/usr', '/usr/bin'],
    require     => [Concat::Fragment['fedora-defaults'], Staging::File['fcrepo-installer.jar'],
      File["${tomcat_home}/conf/Catalina/${server_host}"]]
  }
 
  file { [$fedora_home, "${fedora_home}/server/logs", "${fedora_home}/server/fedora-internal-use", 
    "${fedora_home}/server/management/upload", "${fedora_home}/server/work"]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0775',
    require => Exec['install-fedora']
  }

  file { ["${tomcat_home}/conf/Catalina", "${tomcat_home}/conf/Catalina/${server_host}"]:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0775',
    require => Package['tomcat']
  }

  file {  ["${fedora_home}/server/status"]:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0664',
    recurse => true,
    require => Exec['install-fedora']
  }

  concat { "/etc/sysconfig/tomcat":
    require => Package['tomcat']
  }  
  
  concat::fragment { 'fedora':
    target => "/etc/sysconfig/tomcat",
    content => "FEDORA_HOME='${fedora_home}'\n"
  }
 
}