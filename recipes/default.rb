#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

##################################################
#### Creating zabbix user, password and directory 
##################################################

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

#######################################################
#### Retrieving RPM and installing it 
#### NOTE: There are two ways listed to get the RPM on the box
#### Use the best one that's best for you. 
########################################################

remote_file '/tmp/zabbix-agent-3.2.11-1.el7.x86_64.rpm' do #option 1
  source 'github url here or https link here'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

cookbook_file '/tmp/zabbix-agent-3.2.11-1.el7.x86_64.rpm' do #option2
  source 'zabbix-agent-3.2.11-1.el7.x86_64.rpm'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

bash 'installing RPM' do
  code <<-EOH
    cd /tmp/
    rpm -Uvh <zabbixagent>.rpm
    EOH
end

########################
#### Configuration files 
########################
template '/home/zabbix/zabbix_agentd.d/zabbix_agentd.conf' do
  source 'zabbix_agentd.conf.erb'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end

template '/home/zabbix/zabbix_agentd.d/printer.conf' do
  source 'printer.conf.erb'
  owner 'zabbix'
  group 'zabbix'
  mode '0755'
  action :create
end


######################################
#### Configuring zabbix-agents service  
######################################
bash 'changing run level' do
  code <<-EOH
    /sbin/chkconfig --level 345 zabbix-agent on
    EOH
end

service 'zabbix-agent' do
  action [:start, :enable]
  subscribes :reload, 'template[/home/zabbix/zabbix_agentd.d/zabbix_agentd.conf]', :immediately
end


