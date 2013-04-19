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

class fcrepo::mysql {
  $database     = 'mysql'
  $driver       = 'included'
  $driver_class = 'com.mysql.jdbc.Driver'
  $db_user      = 'vagrant_fc_user'
  $db_pass      = 'vagrant_fc_pwd'
  $jdbc_url     = 'jdbc:mysql://localhost/fedora3?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true'

  include mysql

  class { 'mysql::server':
    config_hash => { 'root_password' => 'vagrant_root_pwd' }
  }
  mysql::db { 'fedora3':
    user     => 'vagrant_fc_user',
    password => 'vagrant_fc_pwd',
    host     => 'localhost',
    grant    => ['all'],
  }
  
  concat::fragment { "fedora-database":
    ensure  => present,
    content => template('fcrepo/fedora_db_properties.erb'),
		target  => $fcrepo::config::propfile
  }
}
