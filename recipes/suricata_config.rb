#
# Cookbook:: nsm
# Recipe:: suricata_config
#
# Copyright:: 2021, The Authors, All Rights Reserved.


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

      dirs = ["/etc/suricata/",
              "/etc/suricata/#{sniff[:sensorname]}",
              "/etc/suricata/#{sniff[:sensorname]}/rules" ]

      dirs.each do |dir|
        directory dir do
          owner 'suricata'
          group 'suricata'
          mode '0750'
          action :create
        end
      end


      template "/etc/suricata/#{sniff[:sensorname]}/suricata.yaml" do
        source 'suricata/suricata.yaml.erb'
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
