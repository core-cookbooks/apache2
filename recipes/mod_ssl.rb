#
# Cookbook Name:: apache2
# Recipe:: ssl
#
# Copyright 2015, Cloudenablers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
unless node['apache2']['listen_ports'].include?('443')
  node.set['apache2']['listen_ports'] = node['apache2']['listen_ports'] + ['443']
end

if platform_family?('rhel', 'fedora', 'suse')
  package 'mod_ssl' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end

  file "#{node['apache2']['dir']}/conf.d/ssl.conf" do
    action :delete
    backup false
  end
end

template "#{node['apache2']['dir']}/ports.conf" do
  source    'ports.conf.erb'
  mode      '0644'
  notifies  :restart, 'service[apache2]'
end

apache_module 'ssl' do
  conf true
end
