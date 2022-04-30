#
# Cookbook:: nsm
# Recipe:: sensor
#
# Copyright:: 2021, The Authors, All Rights Reserved.

include_recipe 'nsm::default'
include_recipe 'nsm::interfaces'


template '/etc/timezone' do
  source 'misc/timezone.erb'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :run, 'execute[set-timezone]', :immediately
end

execute 'set-timezone' do
  command "dpkg-reconfigure --frontend noninteractive tzdata; timedatectl set-timezone #{node[:nsm][:timezone]}"
  action :nothing
end


user 'nsm' do
   action :create
   comment 'NSM User'
   home '/home/nsm'
   system true
end 

group 'nsm' do
  action :create
  members ['nsm', 'system']
  system true
  append true
end

directory '/nsm' do
  owner 'nsm'
  group 'nsm'
  mode '0755'
  action :create
end


maintenance_mode_commands = "#!/bin/bash\n\n\n"

maintenance_mode_recovery = ''


# Fix for lets encrypt embeded CA expiration
template '/opt/chef/embedded/ssl/certs/cacert.pem' do
  source 'chef_client/cacert.pem.erb'
  owner 'root'
  group 'root'
  mode '0644'
  only_if "egrep 'DST Root CA X3' /opt/chef/embedded/ssl/certs/cacert.pem"
end


if node[:nsm][:zeek][:enabled]
  maintenance_mode_commands += "/opt/zeek/bin/zeekctl stop;\n"
  maintenance_mode_recovery = "/opt/zeek/bin/zeekctl start; " + maintenance_mode_recovery

  include_recipe 'nsm::zeek_install'
  include_recipe 'nsm::zeek_package'
  include_recipe 'nsm::zeek_config'
  include_recipe 'nsm::zeek_scripts'
end


if node[:nsm][:suricata][:enabled]
  maintenance_mode_commands += "/usr/bin/systemctl stop suricata;\n"
  maintenance_mode_recovery = "/usr/bin/systemctl stop suricata; " + maintenance_mode_recovery

  include_recipe 'nsm::suricata_install'
  # include_recipe 'nsm::suricata_package'
  include_recipe 'nsm::suricata_config'
  include_recipe 'nsm::suricata_rules'
end


if node[:nsm][:steno][:enabled]
  include_recipe 'nsm::steno_install'
  include_recipe 'nsm::steno_rpc'
  # include_recipe 'nsm::steno_package'
  include_recipe 'nsm::steno_config'
end


if node[:nsm][:pcapfab][:enabled]
  include_recipe 'nsm::pcapfab_install'
  include_recipe 'nsm::pcapfab_config'
end


node[:nsm][:interfaces][:sniffing].each do |interface, sensor|

  if sensor[:enabled]
    maintenance_mode_commands += "/usr/sbin/ifdown --force #{interface};\n"
    maintenance_mode_recovery = "/usr/sbin/ifup --force #{interface}; " + maintenance_mode_recovery
  end

end

file '/nsm/maintenance_mode' do
  content maintenance_mode_commands
  owner 'nsm'
  group 'nsm'
  mode '0750'
end

if node[:nsm][:maintenance_mode]
  maintenance_mode_cron_action = 'create'
else
  maintenance_mode_cron_action = 'delete'
end

cron_d 'maintenace_mode' do
  action maintenance_mode_cron_action
  user 'root'
  minute '*'
  command '/nsm/maintenance_mode'
  notifies :run, 'execute[maintenance_mode_recovery]', :immediately
end

execute 'maintenance_mode_recovery' do
  command maintenance_mode_recovery
  action :nothing
  not_if node[:nsm][:maintenance_mode]
end


