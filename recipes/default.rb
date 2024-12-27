#
# Cookbook:: nsm
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

package ['cron', 'rsyslog']

install_temp = '/root/installtmp'

directory install_temp do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


directory '/home/system/dpkgs/' do
  owner 'system'
  mode '0755'
  action :create
end


if node[:nsm][:dpkg_packages]

  node[:nsm][:dpkg_packages].each do |pkg|

    cookbook_file "/home/system/dpkgs/#{pkg}" do
      source pkg
      owner 'system'
      mode '0644'
      notifies :install, "dpkg_package[#{pkg}]", :immediately
    end
    
    dpkg_package pkg do
      source "/home/system/dpkgs/#{pkg}"
      action :nothing
    end
    
  end  

end

apt_repository 'rsyslog' do
  uri 'ppa:adiscon/v8-stable'
  notifies :run, 'execute[upgrade_rsyslog]', :immediately
end

execute 'upgrade_rsyslog' do
  command 'apt-get update && apt-get upgrade rsyslog'
  action :nothing
  notifies :restart, 'service[rsyslog.service]', :immediately
end


service 'rsyslog.service' do
  action [:start, :enable]
end
