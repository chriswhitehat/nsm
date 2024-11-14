#
# Cookbook:: pcapfab_install
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.



apt_update

package ['python3-dev', 'python3-pip', 'zip', 'unzip', 'wireshark-common'] do
  action :install
end

user 'pcapfab' do
  action :create
  system true
  home '/home/pcapfab'
  manage_home true
end

group 'pcapfab' do
  action :create
  append true
  members ['pcapfab', node[:chef_splunk][:splunk_user]]
end

user 'nsm' do
  action :create
  system true
end

group 'stenographer' do
  action :create
  append true
  members ['pcapfab']
end

group 'zeek' do
  action :create
  append true
  members ['pcapfab']
end

group 'nsm' do
  action :create
  append true
  members ['pcapfab']
end

group 'suricata' do
  action :create
  append true
  members ['pcapfab']
end

directory '/opt/pcapfab' do
  owner 'pcapfab'
  group 'pcapfab'
  mode '0750'
  action :create
end

execute 'create_python_venv' do
  command '/usr/bin/python3 -m venv /opt/pcapfab/.venv'
  user 'pcapfab'
  creates '/opt/pcapfab/.venv'
  action :run
end

execute 'install_ipython' do
  command '/opt/pcapfab/.venv/bin/pip3 install ipython'
  user 'pcapfab'
  login true
  action :run
  creates '/opt/pcapfab/.venv/bin/ipython'
  # not_if do ::File.exists?('/opt/pcapfab/.venv/bin/ipython') end
end

# execute 'install_pyminizip' do
#   command '/opt/pcapfab/.venv/bin/pip3 install pyminizip'
#   user 'pcapfab'
#   login true
#   action :run
#   only_if do ::Dir.glob('/opt/pcapfab/.venv/lib/python3.12/site-packages/pyminizip*').empty? end
# end

directory '/nsm' do
  owner 'nsm'
  group 'nsm'
  mode '0755'
  action :create
end

directories = ['/nsm/pcapfab',
               '/nsm/pcapfab/pending',
               '/nsm/pcapfab/finished',
               '/nsm/pcapfab/pcaps',
               '/nsm/pcapfab/files']

directories.each do |dir|
  directory dir do
    owner 'pcapfab'
    group 'nsm'
    mode '0750'
    action :create
  end
end

pip_packages = ['wheel', 'requests', 'pyminizip', 'fastapi', 'pydantic', 'uvicorn', 'gunicorn', 'python-dateutil']


pip_packages.each do |pip_pkg|

  execute "pip_#{pip_pkg}" do
    command "/opt/pcapfab/.venv/bin/pip3 install #{pip_pkg} && touch /opt/pcapfab/.venv/pip_dep_#{pip_pkg}_installed"
    user 'pcapfab'
    login true
    action :run
    creates "/opt/pcapfab/.venv/pip_dep_#{pip_pkg}_installed"
    # not_if do ::File.exists?("/opt/pcapfab/.venv/pip_dep_#{pip_pkg}_installed") end
  end

end


execute 'generate_certs' do
  command 'openssl req -newkey rsa:4096 -new -nodes -x509 -days 1826 -keyout /opt/pcapfab/key.pem -out /opt/pcapfab/cert.pem -subj "/C=US/ST=Washington/L=Seattle/O=KP/CN=pcapfab.com"'
  user 'pcapfab'
  action :run
  creates '/opt/pcapfab/key.pem'
  # not_if do ::File.exists?('/opt/pcapfab/key.pem') end
end


file '/var/log/pcapfab.log' do
  action :touch
  owner 'pcapfab'
  group 'pcapfab'
  mode '0644'
  not_if do ::File.exists?('/var/log/pcapfab.log') end
end


template '/etc/systemd/system/pcapfab.service' do
  source 'pcapfab/pcapfab.service.erb'
  owner 'root'
  group 'root'
  mode '0640'
  notifies :run, 'execute[systemctl_reload]', :immediately
  notifies :restart, 'systemd_unit[pcapfab.service]'
end


execute 'systemctl_reload' do
  command 'systemctl daemon-reload'
  action :nothing
end


template '/opt/pcapfab/pcapfab.py' do
  source 'pcapfab/pcapfab.py.erb'
  owner 'pcapfab'
  group 'pcapfab'
  mode '0640'
  notifies :restart, 'systemd_unit[pcapfab.service]'
end


template '/opt/pcapfab/pcapfab_extract.zeek' do
  source 'pcapfab/pcapfab_extract.zeek.erb'
  owner 'pcapfab'
  group 'pcapfab'
  mode '0640'
end


systemd_unit 'pcapfab.service' do
  action :enable
end


systemd_unit 'pcapfab.service' do
  action :start
end

# PCAP Fab Stats
cron_d 'pcapfab_stats_file' do
  user 'pcapfab'
  minute '*'
  command '/opt/pcapfab/.venv/bin/python3 /opt/pcapfab/pcapfab.py'
end

