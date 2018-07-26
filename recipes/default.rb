#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

user 'zabbix' do
  comment 'Zabbix User t,System Engineering - Linux'
  manage_home true
  home '/home/zabbix'
  shell '/bin/bash'
  password 'randomstuff'
  action :create
end

directory '/home/zabbix/zabbix_agentd.d' do
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

remote_file '/tmp/zabbix-agent-3.2.11-1.el7.x86_64.rpm' do
  source 'github url here or https link here'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

cookbook_file '/tmp/zabbix-agent-3.2.11-1.el7.x86_64.rpm' do
  source 'zabbix-agent-3.2.11-1.el7.x86_64.rpm'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
  only_if { node['os_version'] == '7.*'}
end

bash 'installing RPM' do
  code <<-EOH
    cd /tmp/
    rpm -Uvh <zabbixagent>.rpm
    EOH
end

template '/home/zabbix/zabbix_agentd.d/zabbix_agentd.conf' do
  source 'zabbix_agentd.conf.erb'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

bash 'changing run level' do 
  code <<-EOH
    /sbin/chkconfig --level 345 zabbix-agent on
    EOH
end

template '/home/zabbix/zabbix_agentd.d/printer.conf' do
  source 'printer.conf.erb'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

bash 'changing run level' do 
  code <<-EOH
    /sbin/chkconfig --level 345 zabbix-agent on
    EOH
end

service 'zabbix-agent' do
  action [ :start, :enable]
  subscribes :reload , 'template[/home/zabbix/zabbix_agentd.d/zabbix_agetd.conf]', :immediately
end



