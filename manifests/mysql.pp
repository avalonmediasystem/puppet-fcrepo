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
  $db_host      = $fcrepo_mysql_host
  $db_user      = $fcrepo_mysql_user
  $db_pass      = $fcrepo_mysql_password
  $db_database  = $fcrepo_mysql_database
  $jdbc_url     = "jdbc:mysql://${db_host}/${db_database}?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true"

  include mysql

  mysql::db { $db_database:
    user     => $db_user,
    password => $db_pass,
    host     => $db_host,
    grant    => ['all'],
  }
  
  concat::fragment { "fedora-database":
    ensure  => present,
    content => template('fcrepo/fedora_db_properties.erb'),
		target  => $fcrepo::config::propfile
  }
}
