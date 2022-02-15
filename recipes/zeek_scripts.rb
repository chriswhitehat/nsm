#
# Cookbook:: nsm
# Recipe:: zeek_scripts
#
# Copyright:: 2021, The Authors, All Rights Reserved.


if node[:nsm][:zeek][:sigs]
  if node[:nsm][:zeek][:sigs][:global]
    global_sigs = node[:nsm][:zeek][:sigs][:global]
  else
    global_sigs = {}
  end
  if node[:nsm][:zeek][:sigs][:regional]
    regional_sigs = node[:nsm][:zeek][:sigs][:regional]
  else
    regional_sigs = {}
  end
  if node[:nsm][:zeek][:sigs][node[:nsm][:sensor_group]]
    sensor_group_sigs = node[:nsm][:zeek][:sigs][node[:nsm][:sensor_group]]
  else
    sensor_group_sigs = {}
  end
  if node[:nsm][:zeek][:sigs][node[:fqdn]]
    host_sigs = node[:nsm][:zeek][:sigs][node[:fqdn]]
  else
    host_sigs = {}
  end
else
  global_sigs = {}
  regional_sigs = {}
  sensor_group_sigs = {}
  host_sigs = {}
end

if node[:nsm][:zeek][:scripts]
  if node[:nsm][:zeek][:scripts][:global]
    global = node[:nsm][:zeek][:scripts][:global]
  else
    global = {}
  end
  if node[:nsm][:zeek][:scripts][:regional]
    regional = node[:nsm][:zeek][:scripts][:regional]
  else
    regional = {}
  end
  if node[:nsm][:zeek][:scripts][node[:nsm][:sensor_group]]
    sensor_group = node[:nsm][:zeek][:scripts][node[:nsm][:sensor_group]]
  else
    sensor_group = {}
  end
  if node[:nsm][:zeek][:scripts][node[:fqdn]]
    host = node[:nsm][:zeek][:scripts][node[:fqdn]]
  else
    host = {}
  end
else
  global = {}
  regional = {}
  sensor_group = {}
  host = {}
end

template '/opt/zeek/share/zeek/site/local.zeek' do
  source 'zeek/local.zeek.erb'
  owner 'zeek'
  group 'zeek'
  mode '0644'
  manage_symlink_source true
  variables({
    :global_sigs => global_sigs,
    :regional_sigs => regional_sigs,
    :sensor_group_sigs => sensor_group_sigs,
    :host_sigs => host_sigs,
    :global => global,
    :regional => regional,
    :sensor_group => sensor_group,
    :host => host
  })
  notifies :run, 'execute[deploy_zeek]', :delayed
end

execute 'deploy_zeek' do
  command "/opt/zeek/bin/zeekctl deploy"
  user 'zeek'
  action :nothing
end
