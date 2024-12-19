#
# Cookbook:: nsm
# Recipe:: interfaces
#
# Copyright:: 2021, The Authors, All Rights Reserved.

###########
# Network Interfaces Config
###########

package ['ifupdown', 'net-tools', 'ethtool', 'iftop']


if node[:nsm][:interfaces][:mgmt][:configure]

  interface = node[:nsm][:interfaces][:mgmt][:interface]

  template '/etc/network/interfaces' do
    source 'network/interfaces.erb'
    mode '0644'
    owner 'root'
    group 'root'
    notifies :run, "execute[downup_#{interface}]", :immediately
  end

  
  execute "downup_#{interface}" do
    command "sudo ifdown --force #{interface}; sudo ifup #{interface}"
    action :nothing
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
      
      directory '/etc/networkd-dispatcher/configured.d' do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end
      
      template "/etc/networkd-dispatcher/configured.d/10-disable-offloading-#{sniff[:interface]}" do
        source 'network/sensor_iface.erb'
        owner 'root'
        group 'root'
        mode '0644'
        notifies :run, "execute[downup_#{interface}]", :immediately
      end

      template "/etc/networkd-dispatcher/routable.d/10-disable-offloading-#{sniff[:interface]}" do
        source 'network/sensor_iface.erb'
        owner 'root'
        group 'root'
        mode '0644'
        notifies :run, "execute[downup_#{interface}]", :immediately
      end
      
      # template "/etc/network/interfaces.d/#{interface}" do
      #   source 'network/sensor_iface.erb'
      #   mode '0644'
      #   owner 'root'
      #   group 'root'
      #   variables(
      #     :sensor => sniff
      #   )
      #   notifies :run, "execute[downup_#{interface}]", :immediately
      # end

      execute "downup_#{interface}" do
        command "sudo ifdown --force #{interface}; sudo ifup #{interface}"
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
