#
# Cookbook:: nsm
# Recipe:: sensor
#
# Copyright:: 2021, The Authors, All Rights Reserved.

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
end


if node[:nsm][:steno][:enabled]
  include_recipe 'nsm::steno_install'
  include_recipe 'nsm::steno_rpc'
  # include_recipe 'nsm::steno_package'
  include_recipe 'nsm::steno_config'
end
