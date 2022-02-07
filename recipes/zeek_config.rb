#
# Cookbook:: nsm
# Recipe:: zeek_config
#
# Copyright:: 2021, The Authors, All Rights Reserved.

directories = ['/opt/zeek/share/zeek/networks']

directories.each do |dir|
  directory dir do
    owner 'zeek'
    group 'zeek'
    mode '0750'
    action :create
  end  
end


if node[:nsm][:interfaces][:sniffing] 

  sniffing_interfaces = []

  node[:nsm][:interfaces][:sniffing].each do |interface, sensor|

    if sensor[:enabled]

      sniff = node[:nsm][:interfaces][:sniffing][:iface].dup
      # Set default sniff options to interface
      sniff.each do |key, val|
        if sensor[key]
          sniff[key] = sensor[key].dup
        else
          sniff[key] = val
        end
      end

      sniffing_interfaces << sniff

    end
  end

  template '/opt/zeek/etc/zeekctl.cfg' do
    source 'zeek/zeekctl.cfg.erb'
    owner 'zeek'
    group 'zeek'
    mode '0644'
    notifies :run, 'execute[deploy_zeek]', :delayed
  end

  template '/opt/zeek/etc/node.cfg' do
    source 'zeek/node.cfg.erb'
    owner 'zeek'
    group 'zeek'
    mode '0644'
    variables(
            :sniffing_interfaces => sniffing_interfaces
          )
    notifies :run, 'execute[deploy_zeek]', :delayed
  end

  #############
  # iface_networks.zeek scripts
  #############

  template "/opt/zeek/share/zeek/networks/__load__.zeek" do
    source 'zeek/networks/__load__.zeek.erb'
    owner 'zeek'
    group 'zeek'
    mode '0640'
    variables(
      :sniffing_interfaces => sniffing_interfaces
      )
    notifies :run, 'execute[deploy_zeek]', :delayed
  end
  
  for sniff in sniffing_interfaces
    template "/opt/zeek/share/zeek/networks/#{sniff[:sensorname]}_networks.zeek" do
      source 'zeek/networks/iface_networks.zeek.erb'
      owner 'zeek'
      group 'zeek'
      mode '0640'
      variables(
        :sniff => sniff)
      notifies :run, 'execute[deploy_zeek]', :delayed
    end
  end

  execute 'deploy_zeek' do
    command "/opt/zeek/bin/zeekctl deploy"
    action :nothing
  end
  
end
