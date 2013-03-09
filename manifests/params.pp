class fedora::params {
  $fedora_base          = '/usr/share'
  $fedora_home          = '/usr/share/fedora'
  $user                 = 'tomcat'
  $version              = 'latest'
  $fedora_admin_pass    = 'fedoraAdmin'
  $group                = 'tomcat'
  $java_version         = '1.7.0'
  $tomcat_http_port     = '8080'
  $tomcat_https_port    = '8443'
  $tomcat_shutdown_port = '8005'
  $fedora_context       = 'fedora'
  $messaging_uri        = ''
  $ri_enabled           = 'true'
  $tomcat_home          = '/usr/share/tomcat'
  $server_host          = fqdn
 
  if $::osfamily == 'redhat' {
    $packages = ['java-1.7.0-openjdk']
  }
}