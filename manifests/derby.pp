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

class fcrepo::derby {
	$database 		= 'included'
	$driver   		= 'included'
	$driver_class = 'org.apache.derby.jdbc.EmbeddedDriver'
	$jdbc_url     = "jdbc:derby:${config::fedora_home}/derby/fedora3;create=true"
	$db_user      = "UNUSED"
	$db_pass			= "ALSO_UNUSED"
	
	concat::fragment { "fedora-database":
		ensure  => present,
		content => template('fcrepo/fedora_db_properties.erb'),
		target  => $fcrepo::config::propfile
	}
}
