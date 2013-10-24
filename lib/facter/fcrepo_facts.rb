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

require 'etc'
require 'rexml/document'
require 'securerandom'

def add_fedora_facts
  config = {
    'user' => 'vagrant_fc_user',
    'password' => SecureRandom.hex,
    'host' => 'localhost',
    'database' => 'fedora3'
  }

  begin
    config_file = '/usr/local/fedora/server/config/fedora.fcfg'
    if File.exists?(config_file)
      doc = REXML::Document.new(File.read(config_file))
      config['user'] = REXML::XPath.match(doc,'/server/datastore[@id="localMySQLPool"]/param[@name="dbUsername"]/@value').first.value
      config['password'] = REXML::XPath.match(doc,'/server/datastore[@id="localMySQLPool"]/param[@name="dbPassword"]/@value').first.value

      uri = REXML::XPath.match(doc,'/server/datastore[@id="localMySQLPool"]/param[@name="jdbcURL"]/@value').first.value
      parts = uri.split(%r{[/?]})
      config['host'] = parts[2]
      config['database'] = parts[3]
    end
  end

  config.each_pair do |key,value|
    Facter.add("fcrepo_mysql_#{key}") do
      setcode { value }
    end
  end
end

add_fedora_facts