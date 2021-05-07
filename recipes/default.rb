#
# Cookbook:: nsm
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

install_temp = '/root/installtmp'

directory install_temp do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


