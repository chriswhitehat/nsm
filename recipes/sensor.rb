#
# Cookbook:: nsm
# Recipe:: sensor
#
# Copyright:: 2021, The Authors, All Rights Reserved.

include_recipe 'nsm::default'
include_recipe 'nsm::interfaces'

user 'nsm' do
   action :create
   comment 'NSM User'
   home '/home/nsm'
   system true
end 

group 'nsm' do
  action :create
  members ['nsm']
  system true
end

directory '/nsm' do
  owner 'nsm'
  group 'nsm'
  mode '0755'
  action :create
end


file '/usr/share/ca-certificates/mozilla/DST_Root_CA_X3.crt' do
  action :delete
  notifies :run, 'execute[update_ca]', :immediately
end


execute 'update_ca' do
  command 'update-ca-certificates'
  action :nothing
end



if node[:nsm][:zeek][:enabled]
  include_recipe 'nsm::zeek_install'
  include_recipe 'nsm::zeek_package'
  include_recipe 'nsm::zeek_config'
  include_recipe 'nsm::zeek_scripts'  
end


if node[:nsm][:suricata][:enabled]
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
