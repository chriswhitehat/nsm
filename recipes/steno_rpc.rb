#
# Cookbook:: nsm
# Recipe:: steno_install
#
# Copyright:: 2021, The Authors, All Rights Reserved. 

dirs = ['/nsm/steno/rpc',
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

git '/home/stenographer/certstrap' do
  user 'stenographer'
  repository 'https://github.com/square/certstrap'
  revision 'master'
  action :sync
  not_if do ::File.exist?("/home/stenographer/certstrap") end
  notifies :run, 'execute[go_build_certstrap]', :immediately
end

execute 'go_build_certstrap' do
  user 'stenographer'
  cwd '/home/stenographer/certstrap'
  environment ({'GOPATH' => '/home/stenographer/go',
                'GOCACHE' => '/home/stenographer/go/.cache'})
  command '/usr/local/go/bin/go build'
  action :nothing
end

execute 'create_steno_rpc_ca' do
  user 'stenographer'
  command '/home/stenographer/certstrap/certstrap --depot-path /etc/stenographer/certs/rpc init --common-name "StenoCA" --passphrase ""'
  not_if do ::File.exist?("/etc/stenographer/certs/rpc/StenoCA.key") end
  action :run
end

execute 'create_steno_rpc_req' do
  user 'stenographer'
  command '/home/stenographer/certstrap/certstrap --depot-path /etc/stenographer/certs/rpc request-cert --common-name "Steno" --passphrase ""'
  not_if do ::File.exist?("/etc/stenographer/certs/rpc/Steno.key") end
  action :run
end

execute 'create_steno_rpc_crt' do
  user 'stenographer'
  command '/home/stenographer/certstrap/certstrap --depot-path /etc/stenographer/certs/rpc sign Steno --CA StenoCA --passphrase ""'
  not_if do ::File.exist?("/etc/stenographer/certs/rpc/Steno.crt") end
  action :run
end
