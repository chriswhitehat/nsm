#
# Cookbook:: nsm
# Recipe:: suricata_rules
#
# Copyright:: 2021, The Authors, All Rights Reserved.


var_lib_base = "/var/lib/suricata"

etc_base = "/etc/suricata"

dirs = [var_lib_base,
        "#{var_lib_base}/rules",
        "#{var_lib_base}/update",
        "#{var_lib_base}/update/sources",
        "#{var_lib_base}/update/cache"]

dirs.each do |dir|
  directory dir do
    owner 'suricata'
    group 'suricata'
    mode '0750'
    action :create
  end
end      
      

['disable', 'drop', 'enable', 'modify'].each do |conf|

  if node[:nsm][:suricata][:rules] && node[:nsm][:suricata][:rules][conf]
    if node[:nsm][:suricata][:rules][conf][:global]
      global = node[:nsm][:suricata][:rules][conf][:global]
    else
      global = {}
    end
    if node[:nsm][:suricata][:rules][conf][node[:nsm][:sensor_region]]
      sensor_region = node[:nsm][:suricata][:rules][conf][node[:nsm][:sensor_region]]
    else
      sensor_region = {}
    end
    if node[:nsm][:suricata][:rules][conf][node[:nsm][:sensor_group]]
      sensor_group = node[:nsm][:suricata][:rules][conf][node[:nsm][:sensor_group]]
    else
      sensor_group = {}
    end
    if node[:nsm][:suricata][:rules][conf][node[:fqdn]]
      host = node[:nsm][:suricata][:rules][conf][node[:fqdn]]
    else
      host = {}
    end
  else
    global = {}
    sensor_region = {}
    sensor_group = {}
    host = {}
  end


  template "#{etc_base}/#{conf}.conf" do
    source "suricata/rules/rule_configs.conf.erb"
    owner 'suricata'
    group 'suricata'
    mode '0640'
    variables({
      :global_sigs => global,
      :sensor_region_sigs => sensor_region,
      :sensor_group_sigs => sensor_group,
      :host_sigs => host,
      :rule_conf => conf
    })
    notifies :run, "execute[suricata_update]", :delayed
  end
end


if node[:nsm][:suricata][:rules] && node[:nsm][:suricata][:rules][:local]
  if node[:nsm][:suricata][:rules][:local][:global]
    global = node[:nsm][:suricata][:rules][:local][:global]
  else
    global = {}
  end
  if node[:nsm][:suricata][:rules][:local][node[:nsm][:sensor_region]]
    sensor_region = node[:nsm][:suricata][:rules][:local][node[:nsm][:sensor_region]]
  else
    sensor_region = {}
  end
  if node[:nsm][:suricata][:rules][:local][node[:nsm][:sensor_group]]
    sensor_group = node[:nsm][:suricata][:rules][:local][node[:nsm][:sensor_group]]
  else
    sensor_group = {}
  end
  if node[:nsm][:suricata][:rules][:local][node[:fqdn]]
    host = node[:nsm][:suricata][:rules][:local][node[:fqdn]]
  else
    host = {}
  end
else
  global = {}
  sensor_region = {}
  sensor_group = {}
  host = {}
end


template "#{etc_base}/rules/local.rules" do
  source "suricata/rules/local.rules.erb"
  owner 'suricata'
  group 'suricata'
  mode '0640'
  variables({
    :global_sigs => global,
    :sensor_region_sigs => sensor_region,
    :sensor_group_sigs => sensor_group,
    :host_sigs => host
  })
  notifies :run, "execute[suricata_update]", :delayed
end
    

template "#{etc_base}/threshold.config" do
  source 'suricata/threshold.config.erb'
  owner 'suricata'
  group 'suricata'
  mode '0640'
  notifies :run, "execute[suricata_update]", :delayed
end


##################
# Suricata-Update
##################

template "#{etc_base}/update.yaml" do
  source 'suricata/update.yaml.erb'
  owner 'suricata'
  group 'suricata'
  mode '0640'
  notifies :run, "execute[suricata_update_sources]", :immediately
  notifies :run, "execute[suricata_update]", :delayed
end


if node[:nsm][:suricata][:rules][:source][:et_pro][:enabled]
  template "#{var_lib_base}/update/sources/et-pro.yaml" do
    source 'suricata/rules/et-pro.yaml.erb'
    owner 'suricata'
    group 'suricata'
    mode '0640'
    notifies :run, "execute[suricata_update_sources]", :immediately
    notifies :run, "execute[suricata_update]", :delayed
  end
else
  file "#{var_lib_base}/update/sources/et-pro.yaml" do
    action :delete
    notifies :run, "execute[suricata_update_sources]", :immediately
    notifies :run, "execute[suricata_update]", :delayed
  end
end


execute 'suricata_update_sources' do
  command "suricata-update update-sources -D #{var_lib_base} -c #{etc_base}/update.yaml"
  user "suricata"
  action :nothing
end


execute "suricata_update" do
  command "suricata-update -D #{var_lib_base} -c #{etc_base}/update.yaml --suricata-conf #{etc_base}/suricata.yaml"
  user "suricata"
  action :nothing
  notifies :run, 'execute[surciata_reload]', :delayed
end


execute 'surciata_reload' do
   command '/usr/sbin/suricata-reload'
   action :nothing
 end


cron_d "cron_suricata_update" do
  action :create
  minute '0'
  hour '10'
  user 'suricata'
  command "/usr/bin/suricata-update -D #{var_lib_base} -c #{etc_base}/update.yaml --suricata-conf #{etc_base}/suricata.yaml && /usr/sbin/suricata-reload"
end




