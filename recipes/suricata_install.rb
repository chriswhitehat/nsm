#
# Cookbook:: nsm
# Recipe:: suricata_install
#
# Copyright:: 2021, The Authors, All Rights Reserved.

user 'suricata' do
   action :create
   comment 'Suricata User'
   home '/home/suricata'
   system true
end 

group 'suricata' do
  action :create
  members ['suricata']
  system true
end


directory '/home/suricata' do
  owner 'suricata'
  group 'suricata'
  mode '0750'
  action :create
end


directory '/nsm/suricata' do
  owner 'suricata'
  group 'suricata'
  mode '0750'
  recursive true
  action :create
end


apt_repository 'suricata-stable' do
  uri 'ppa:oisf/suricata-stable'
  notifies :update, 'apt_update[update_suricata]', :immediately
end


apt_update 'update_suricata' do
  action :nothing
end


package ['suricata', 'jq']

execute 'setcap_suricata' do
  command 'setcap cap_net_raw=eip /usr/bin/suricata'
  user 'root'
  action :nothing
end



# directory '/opt/suricata' do
#   owner 'suricata'
#   group 'suricata'
#   mode '0750'
#   recursive true
#   action :create
# end


# package ['rustc', 'cargo', 'make', 'libpcre3', 'libpcre3-dbg', 'libpcre3-dev', 'build-essential', 
# 'autoconf', 'automake', 'libtool', 'libpcap-dev', 'libnet1-dev', 'libyaml-0-2', 'libyaml-dev', 
# 'zlib1g', 'zlib1g-dev', 'libcap-ng-dev', 'libcap-ng0', 'make', 'libmagic-dev', 'libjansson-dev', 
# 'libjansson4', 'pkg-config', 'python3-pip']


# execute 'install_suricata_update' do
#   command 'pip3 install --upgrade suricata-update'
#   not_if do ::Dir.exists?('/usr/local/bin/suricata-update') end
#   action :run
# end


# # https://www.openinfosecfoundation.org/download/
# remote_file "/tmp/suricata-#{node[:nsm][:suricata][:version]}.tar.gz" do
#   owner 'suricata'
#   group 'suricata'
#   mode '0644'
#   source "https://www.openinfosecfoundation.org/download/suricata-#{node[:nsm][:suricata][:version]}.tar.gz"
#   # not_if do ::File.exist?("/opt/suricata/suricata-#{node[:nsm][:suricata][:version]}.installed") end
#   notifies :run, "execute[extract_suricata]"
# end

# execute "extract_suricata" do
#   user 'suricata'
#   cwd '/tmp/'
#   command "tar -xzvf /tmp/suricata-#{node[:nsm][:suricata][:version]}.tar.gz"
#   action :nothing
#   notifies :run, 'execute[configure_suricata]'
# end


# execute 'configure_suricata' do
#   user 'suricata'
#   cwd "/tmp/suricata-#{node[:nsm][:suricata][:version]}"
#   command './configure --enable-nfqueue --prefix=/usr --sysconfdir=/etc --localstatedir=/var'
#   action :nothing
#   notifies :run, 'execute[make_suricata]'
# end

# execute 'make_suricata' do
#   user 'suricata'
#   cwd "/tmp/suricata-#{node[:nsm][:suricata][:version]}"
#   # command "make && make install-full && touch /opt/suricata/suricata-#{node[:nsm][:suricata][:version]}.installed"
#   command "make && make install-full"
#   # creates "/opt/suricata/suricata-#{node[:nsm][:suricata][:version]}.installed"
#   action :nothing
#   # notifies :run, 'execute[chown_chmod_suricata]', :immediately
#   # notifies :run, 'execute[setcap_suricata]', :immediately
# end
