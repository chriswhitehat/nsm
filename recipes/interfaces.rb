#
# Cookbook:: nsm
# Recipe:: interfaces
#
# Copyright:: 2021, The Authors, All Rights Reserved.

###########
# Network Interfaces Config
###########

package ['net-tools', 'ethtool', 'iftop']


# if node[:nsm][:interfaces][:mgmt][:configure]

#   interface = node[:nsm][:interfaces][:mgmt][:interface]

#   template '/etc/network/interfaces' do
#     source 'network/interfaces.erb'
#     mode '0644'
#     owner 'root'
#     group 'root'
#     notifies :run, "execute[downup_#{interface}]", :immediately
#   end

  
#   execute "downup_#{interface}" do
#     command "sudo ifdown --force #{interface}; sudo ifup #{interface}"
#     action :nothing
#   end
  
# end

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
      
      directory '/etc/networkd-dispatcher/configured.d' do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end
      
      template "/etc/networkd-dispatcher/configured.d/10-disable-offloading-#{interface}" do
        source 'network/sensor_iface.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          :sensor => sniff
        )
        notifies :run, "execute[downup_#{interface}]", :immediately
      end

      template "/etc/networkd-dispatcher/routable.d/10-disable-offloading-#{interface}" do
        source 'network/sensor_iface.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          :sensor => sniff
        )
        notifies :run, "execute[downup_#{interface}]", :immediately
      end

      execute "downup_#{interface}" do
        command "ip link set dev #{interface} down; ip addr set dev #{interface} up"
        action :nothing
      end

      template "/etc/systemd/system/sniffing-interface-#{interface}.service" do
        source 'network/sniffing-interface.service.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          :interface => interface
        )
        notifies [:start, :enable], "service[sniffing-interface-#{interface}.service]", :immediately
      end
      
      service "sniffing-interface-#{interface}.service" do
        action :nothing
      end
    end
  end
end


package 'cloud-init' do
  action :remove
  notifies :delete, 'directory[etc_cloud]', :immediately
end


directory 'etc_cloud' do
  path '/etc/cloud'
  action :nothing
  recursive true
end
