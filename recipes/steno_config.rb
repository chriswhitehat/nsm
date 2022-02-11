#
# Cookbook:: nsm
# Recipe:: steno_install
#
# Copyright:: 2021, The Authors, All Rights Reserved. 


template '/etc/security/limits.d/stenographer.conf' do
  source 'steno/limits.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

if node[:nsm][:interfaces][:sniffing] 

  local_port = 15140
  grpc_port = 8443

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

      if sniff[:steno][:grpc]

        rpc_dirs = ["/nsm/steno/#{sniff[:sensorname]}", 
                    "/nsm/steno/#{sniff[:sensorname]}/rpc"]

        rpc_dirs.each do |dir|

          directory dir do
            owner 'stenographer'
            group 'stenographer'
            mode '0750'
            action :create
          end
        end
      end

      (1..sniff[:steno][:lb_count]).each do | thread |

        dirs = ["/nsm/steno/thread#{thread}", 
                "/nsm/steno/thread#{thread}/packets",
                "/nsm/steno/thread#{thread}/index"]

        dirs.each do |dir|
          directory dir do
            owner 'stenographer'
            group 'stenographer'
            mode '0750'
            action :create
          end
        end
      end

      #############
      # Unused config needed for stenokeys
      #############
      
      template "/etc/stenographer/config" do
        source 'steno/steno.conf.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
            :sniff => sniff,
            :local_port => local_port,
            :grpc_port => grpc_port
          )
        not_if do ::File.exist?("/etc/stenographer/config") end
      end

      template "/etc/stenographer/config_#{sniff[:sensorname]}" do
        source 'steno/steno.conf.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
            :sniff => sniff,
            :local_port => local_port,
            :grpc_port => grpc_port
          )
        notifies :enable, "service[stenographer_service_#{sniff[:sensorname]}]", :immediately
        notifies :start, "service[stenographer_service_#{sniff[:sensorname]}]", :delayed
      end

      service "stenographer_service_#{sniff[:sensorname]}" do
        service_name "stenographer@#{sniff[:sensorname]}.service"
        action :nothing
      end

      local_port += 1
      grpc_port += 1

    end
  end
end

execute 'generate_stenokeys' do
  command '/usr/bin/stenokeys.sh stenographer stenographer'
  not_if do ::File.exist?("/etc/stenographer/certs/ca_cert.pem") end
end

directory '/etc/stenographer/certs' do
  owner 'stenographer'
  group 'stenographer'
  mode '0750'
  action :create
end
