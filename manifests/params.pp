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

class fcrepo::params {
  $fedora_base          = '/usr/local'
  $fedora_home          = "$fedora_base/fedora"
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
  $tomcat_home          = '/usr/local/tomcat'
  $server_host          = $::fqdn
}
