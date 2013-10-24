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

def add_fedora_facts
  doc = REXML::Document.new(File.read('/usr/local/fedora/server/config/fedora.fcfg'))
  uri = REXML::XPath.match(doc,'/server/datastore[@id="localMySQLPool"]/param[@name="jdbcURL"]/@value').first.value

  Facter.add("fcrepo_mysql_user") do
    setcode do
      begin
        REXML::XPath.match(doc,'/server/datastore[@id="localMySQLPool"]/param[@name="dbUsername"]/@value').first.value
      rescue
        'vagrant_fc_user'
      end
    end
  end

  Facter.add("fcrepo_mysql_password") do
    setcode do
      begin
        REXML::XPath.match(doc,'/server/datastore[@id="localMySQLPool"]/param[@name="dbPassword"]/@value').first.value
      rescue
        'vagrant_fc_pwd'
      end
    end
  end

  Facter.add("fcrepo_mysql_host") do
    setcode do
      begin
        uri.split(%r{[/?]})[2]
      rescue
        'localhost'
      end
    end
  end

  Facter.add("fcrepo_mysql_database") do
    setcode do
      begin
        uri.split(%r{[/?]})[3]
      rescue
        'localhost'
      end
    end
  end
end

add_fedora_facts