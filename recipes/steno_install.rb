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

directory '/home/stenographer' do
  owner 'stenographer'
  group 'stenographer'
  mode '0750'
  action :create
end

package ['golang', 'libaio-dev', 'libleveldb-dev', 'libsnappy-dev', 'g++', 'libcap2-bin', 'libseccomp-dev', 'tcpreplay']

execute 'go_install' do
  cwd '/home/stenographer'
  user 'stenographer'
  group 'stenographer'
  environment ({'GOPATH' => '/home/stenographer/go',
                'GOCACHE' => '/home/stenographer/go/.cache'})
  command 'go get github.com/google/stenographer'
  not_if do ::File.exist?("/home/stenographer/go/bin/stenographer") end
  action :run
  notifies :run, 'execute[make_stenotype]'
end

execute 'make_stenotype' do
  cwd '/home/stenographer/go/src/github.com/google/stenographer/stenotype/'
  user 'stenographer'
  group 'stenographer'
  command 'make && cp stenotype /home/stenographer/go/bin/'
  not_if do ::File.exist?("/home/stenographer/go/bin/stenotype") end
  action :nothing
  notifies :run, 'execute[setcap_steno]', :immediate
end

execute 'setcap_steno' do
  command 'setcap cap_net_raw=eip /home/stenographer/go/bin/stenographer && setcap cap_net_raw=eip /home/stenographer/go/bin/stenotype'
  user 'root'
  action :nothing
end

directory '/nsm/stenographer' do
  owner 'stenographer'
  group 'stenographer'
  mode '0750'
  recursive true
  action :create
end


