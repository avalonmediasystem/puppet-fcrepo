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

class fcrepo {
  if defined(jdk) {
    include jdk
  }
  
  if $config::version == 'latest' {
    $download_url = "http://sourceforge.net/projects/fedora-commons/files/latest/download"
  } else {
    $download_url = "http://downloads.sourceforge.net/fedora-commons/fcrepo-installer-${config::version}.jar"
  }

  File {
    selinux_ignore_defaults => true
  }

  staging::file { 'fcrepo-installer.jar':
    source  => $download_url,
    timeout => 1200,
    subdir  => 'fcrepo'
  }
 
  file { $config::fedora_base:
    ensure => directory,
    owner  => $config::user,
    group  => $config::group,
    mode   => '0775',
    require => Class['fcrepo::config']
  }
 
  notify { 'fedora-install':
    message     => "Installing fedora ${config::version} as ${config::user}",
    require     => Class['fcrepo::config']
  }->
  exec { 'install-fedora':
    command     => "/usr/bin/java -jar /opt/staging/fcrepo/fcrepo-installer.jar ${fcrepo::config::propfile}",
    creates     => "${config::fedora_home}/server",
    environment => ["FEDORA_HOME=${config::fedora_home}", "CATALINA_HOME=/usr/local/tomcat"],
    timeout     => 1800,
    user        => $config::user,
    group       => $config::group,
    path        => ['/bin', '/usr', '/usr/bin'],
    require     => [Staging::File['fcrepo-installer.jar']],
    notify      => [File["${config::fedora_home}/server/status"], Service["tomcat"]]
    #Concat::Fragment['fedora-tomcat-config']]
  }
 
  file { [$config::fedora_home, "${config::fedora_home}/server/logs", "${config::fedora_home}/server/fedora-internal-use", 
    "${config::fedora_home}/server/management/upload", "${config::fedora_home}/server/work"]:
    ensure  => directory,
    owner   => $config::user,
    group   => $config::group,
    mode    => '0775',
    require => Exec['install-fedora']
  }

  file { "${config::fedora_home}/server/status":
    ensure  => present,
    owner   => $config::user,
    group   => $config::group,
    mode    => '0664',
    recurse => true,
    require => Exec['install-fedora']
  }

}
