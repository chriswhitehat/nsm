#
# Cookbook:: nsm
# Recipe:: suricata_rules
#
# Copyright:: 2021, The Authors, All Rights Reserved.

dirs = ['/var/lib/suricata',
        '/var/lib/suricata/rules',
        '/var/lib/suricata/update',
        '/var/lib/suricata/update/cache']

dirs.each do |dir|
  directory dir do
    owner 'suricata'
    group 'suricata'
    mode '0750'
    action :create
  end
end

if node[:nsm][:interfaces][:sniffing] 

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

      template "/etc/suricata/threshold_#{interface}.config" do
        source 'suricata/rules/threshold.config.erb'
        owner 'suricata'
        group 'suricata'
        mode '0640'
        variables(
            :sniff => sniff
          )
      end
    end
  end
end


execute 'suricata_update' do
  command 'suricata-update'
  action :nothing
end
