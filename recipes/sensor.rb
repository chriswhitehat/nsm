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


if node[:nsm][:maintenance_mode]

  file '/nsm/maintenance_mode' do
    action :create
    owner 'nsm'
    group 'nsm'
    mode '0644'
  end

else

  file '/nsm/maintenance_mode' do
    action :delete
    notifies :reboot_now, 'reboot[leaving_maintenance_mode]', :immediately
  end

  reboot 'leaving_maintenance_mode' do
    action :nothing
  end

end

maintenance_mode_cron = '/usr/bin/test -f /nsm/maintenance_mode && '


# Fix for lets encrypt embeded CA expiration
template '/opt/chef/embedded/ssl/certs/cacert.pem' do
  source 'chef_client/cacert.pem.erb'
  owner 'root'
  group 'root'
  mode '0644'
  only_if "egrep 'DST Root CA X3' /opt/chef/embedded/ssl/certs/cacert.pem"
end


if node[:nsm][:zeek][:enabled]
  maintenance_mode_cron += "/opt/zeek/bin/zeekctl stop; "
  include_recipe 'nsm::zeek_install'
  include_recipe 'nsm::zeek_package'
  include_recipe 'nsm::zeek_config'
  include_recipe 'nsm::zeek_scripts'  
end


if node[:nsm][:suricata][:enabled]
  maintenance_mode_cron += "systemctl stop suricata; "
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
    maintenance_mode_cron += "/usr/sbin/ifdown --force #{interface}; "
  end

end


cron_d 'maintenace_mode' do
  user 'root'
  minute '*'
  command maintenance_mode_cron
end
