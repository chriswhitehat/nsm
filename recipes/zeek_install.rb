#
# Cookbook:: nsm
# Recipe:: zeek_install
#
# Copyright:: 2021, The Authors, All Rights Reserved. 

user 'zeek' do
   action :create
   comment 'Zeek User'
   home '/home/zeek'
   system true
end 

group 'zeek' do
  action :create
  members ['zeek']
  system true
end

directory '/home/zeek' do
  owner 'zeek'
  group 'zeek'
  mode '0750'
  action :create
end

directory '/opt/zeek' do
  owner 'zeek'
  group 'zeek'
  mode '0750'
  recursive true
  action :create
end


apt_repository 'security:zeek' do
  uri "http://download.opensuse.org/repositories/security:/zeek/xUbuntu_#{node[:lsb][:release]}/"
  distribution "/"
  key "https://download.opensuse.org/repositories/security:zeek/xUbuntu_#{node[:lsb][:release]}/Release.key"
  notifies :update, 'apt_update[zeek_update]',  :immediately
end

apt_update 'zeek_update' do
  action :nothing
end


package 'gdb'


package 'zeek' do
  action :install
  notifies :run, 'execute[chown_chmod_zeek]', :immediately
end

execute 'chown_chmod_zeek' do
  command 'chown -R zeek:zeek /opt/zeek'
  action :nothing
  notifies :run, 'execute[setcap_zeek]', :immediately
end

execute 'setcap_zeek' do
  command 'setcap cap_net_raw=eip /opt/zeek/bin/zeek; setcap cap_net_raw=eip /opt/zeek/bin/capstats'
  user 'root'
  action :nothing
end

zeek_bins = ['zeek',
            'zeek-archiver',
            'zeek-config',
            'zeekctl',
            'zeek-cut',
            'zeek-wrapper']

zeek_bins.each do |zbin|
  link "/usr/bin/#{zbin}" do
    to "/opt/zeek/bin/#{zbin}"
  end
end

# Zeek Cron Monitoring
cron_d 'zeekctl_cron' do
  user 'zeek'
  minute '*/5'
  command '/opt/zeek/bin/zeekctl cron'
end

zeek_dirs = ['/nsm/zeek', node[:nsm][:zeek][:config][:log_dir], node[:nsm][:zeek][:config][:spool_dir],
            node[:nsm][:zeek][:config][:broker_db_dir]]

zeek_dirs.each do |zeek_dir|

  directory zeek_dir do
    owner 'zeek'
    group 'zeek'
    mode '0750'
    action :create
    recursive true
  end
  
end


# package ["cmake", "make", "gcc", "g++", "flex", "bison", "libpcap-dev", "libjemalloc2", "libjemalloc-dev",
         # "libssl-dev", "python3", "python3-dev", "swig", "zlib1g-dev", "python3-git", "python3-semantic-version"]


# if node[:nsm][:sensor][:enable_geoip]:
#   Install the libmaxminddb development library.
#   sudo yum install libmaxminddb-devel
#   Sign up for a free Maxmind account.  This is required as of December 2019.
#   Download and untar the GeoLite2 database.
#   tar xzvf GeoLite2-City.tar.gz
#   Move the GeoLite2-City.mmdb file in the extracted GeoLite2-City_YYYYMMDD directory to /usr/share/GeoIP.
#   sudo mv GeoLite2-City_YYYYMMDD/GeoLite2-City.mmdb /usr/share/GeoIP/GeoLite2-City.mmdb
# end





# # https://zeek.org/get-zeek/
# remote_file "/tmp/zeek-#{node[:nsm][:zeek][:version]}.tar.gz" do
#   owner 'zeek'
#   group 'zeek'
#   mode '0644'
#   source "https://download.zeek.org/zeek-#{node[:nsm][:zeek][:version]}.tar.gz"
#   not_if do ::File.exist?("/opt/zeek/zeek-#{node[:nsm][:zeek][:version]}.installed") end
#   notifies :run, "execute[extract_zeek]", :immediately
# end

# execute "extract_zeek" do
#   user 'zeek'
#   cwd '/tmp/'
#   command "tar -xzvf /tmp/zeek-#{node[:nsm][:zeek][:version]}.tar.gz"
#   action :nothing
#   notifies :run, 'execute[configure_zeek]', :immediately
# end


# execute 'configure_zeek' do
#   user 'zeek'
#   cwd "/tmp/zeek-#{node[:nsm][:zeek][:version]}"
#   command './configure --prefix=/opt/zeek --enable-jemalloc'
#   action :nothing
#   notifies :run, 'execute[make_zeek]', :immediately
# end

# execute 'make_zeek' do
#   cwd "/tmp/zeek-#{node[:nsm][:zeek][:version]}"
#   command "make && make install && touch /opt/zeek/zeek-#{node[:nsm][:zeek][:version]}.installed"
#   creates "/opt/zeek/zeek-#{node[:nsm][:zeek][:version]}.installed"
#   action :nothing
#   notifies :run, 'execute[chown_chmod_zeek]', :immediately
#   notifies :run, 'execute[setcap_zeek]', :immediately
# end

# # Add zeek to path
# # /opt/zeek/bin

# reboot 'zeek_dependencies' do
#   action :nothing
# end
