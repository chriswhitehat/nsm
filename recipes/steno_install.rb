#
# Cookbook:: nsm
# Recipe:: steno_install
#
# Copyright:: 2021, The Authors, All Rights Reserved. 

user 'stenographer' do
   action :create
   comment 'Stenographer User'
   home '/home/stenographer'
   system true
end 

group 'stenographer' do
  action :create
  members ['stenographer']
  system true
end

directory '/etc/stenographer' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

dirs = ['/home/stenographer', 
        '/nsm/steno/', 
        '/nsm/steno/rpc',
        '/etc/stenographer/certs',
        '/etc/stenographer/certs/rpc',
        '/etc/stenographer/certs/rpc/ca']

dirs.each do |dir|
  directory dir do
    owner 'stenographer'
    group 'stenographer'
    mode '0750'
    recursive true
    action :create
  end
end


package ['build-essential', 'libaio-dev', 'libleveldb-dev', 'libsnappy-dev', 'g++', 
  'libcap2-bin', 'libseccomp-dev', 'tcpreplay', 'jq', 'libjq1', 'libonig5', 'openssl']


remote_file "/root/installtmp/go#{node[:nsm][:go][:version]}.linux-amd64.tar.gz" do
  owner 'root'
  group 'root'
  mode '0644'
  source "https://go.dev/dl/go#{node[:nsm][:go][:version]}.linux-amd64.tar.gz"
  notifies :run, 'execute[extract_golang]', :immediately
end

execute 'extract_golang' do
  command "rm -rf /usr/local/go && tar -C /usr/local -xzf /root/installtmp/go#{node[:nsm][:go][:version]}.linux-amd64.tar.gz"
  action :nothing
end


execute 'go_install_stenographer' do
  cwd '/home/stenographer'
  user 'stenographer'
  group 'stenographer'
  environment ({'GOPATH' => '/home/stenographer/go',
                'GOCACHE' => '/home/stenographer/go/.cache'})
  command "/usr/local/go/bin/go install github.com/google/stenographer@#{node[:nsm][:steno][:version]}"
  not_if do ::File.exist?("/home/stenographer/go/pkg/mod/github.com/google/stenographer@#{node[:nsm][:steno][:version]}") end
  action :run
  notifies :run, 'execute[make_stenotype]', :immediately
end


execute 'make_stenotype' do
  cwd "/home/stenographer/go/pkg/mod/github.com/google/stenographer@#{node[:nsm][:steno][:version]}/stenotype"
  environment ({'GOPATH' => '/home/stenographer/go',
                'GOCACHE' => '/home/stenographer/go/.cache'})
  command 'make'
  action :nothing
end


remote_file "copy_stenographer_file" do 
    path "/home/stenographer/go/pkg/mod/github.com/google/stenographer@#{node[:nsm][:steno][:version]}/stenographer" 
    source "file:///home/stenographer/go/bin/stenographer"
    mode 0700
    owner 'stenographer'
    group 'root'
  end

bins = [['stenographer', 'stenographer', 0700, 'stenographer', 'root'], 
        ['stenotype/stenotype', 'stenotype', 0500, 'stenographer', 'root'], 
        ['stenoread', 'stenoread', 0755, 'root', 'root'], 
        ['stenocurl', 'stenocurl', 0755, 'root', 'root'],
        ['stenokeys.sh', 'stenokeys.sh', 0750, 'stenographer', 'root']
      ]

bins.each do |steno_bin_src,  steno_bin_dest, steno_bin_perms, steno_bin_user, steno_bin_group|
  remote_file "copy_steno_file_#{steno_bin_dest}" do 
    path "/usr/bin/#{steno_bin_dest}" 
    source "file:///home/stenographer/go/pkg/mod/github.com/google/stenographer@#{node[:nsm][:steno][:version]}/#{steno_bin_src}"
    mode steno_bin_perms
    owner steno_bin_user
    group steno_bin_group
  end
end

template '/lib/systemd/system/stenographer.service' do
  source 'steno/stenographer.service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[setcap_steno]', :immediately
  notifies :run, 'execute[systemctl_reload]', :immediately
  notifies :enable, 'service[stenographer.service]', :immediately
  notifies :start, 'service[stenographer.service]', :delayed
end

execute 'setcap_steno' do
  command 'setcap cap_net_raw,cap_net_admin,cap_ipc_lock+eip /usr/bin/stenotype'
  user 'root'
  action :nothing
end

execute 'systemctl_reload' do
  command 'sudo systemctl daemon-reload'
  action :nothing
end

service 'stenographer.service' do
  action :nothing
end



