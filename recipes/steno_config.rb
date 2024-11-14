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

template '/etc/rsyslog.d/rsyslog_steno.conf' do
  source 'steno/rsyslog_steno.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[rsyslog.service]'
end

service 'rsyslog.service' do
  action :nothing
end

nsm_logrotate_paths = ['/var/log/stenographer.log']

logrotate_app "rotate-stenographer" do
  path      nsm_logrotate_paths
  frequency 'daily'
  rotate    14
  create    '640 syslog stenographer'
  postrotate '/usr/bin/systemctl kill -s HUP rsyslog.service >/dev/null 2>&1 || true'
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
            group 'nsm'
            mode '0750'
            action :create
          end
        end
      end

      (1..sniff[:steno][:lb_count]).each do | thread |

        dirs = ["/nsm/steno/#{sniff[:sensorname]}",
                "/nsm/steno/#{sniff[:sensorname]}/thread#{thread}", 
                "/nsm/steno/#{sniff[:sensorname]}/thread#{thread}/packets",
                "/nsm/steno/#{sniff[:sensorname]}/thread#{thread}/index"]

        dirs.each do |dir|
          directory dir do
            owner 'stenographer'
            group 'nsm'
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


      # This is ugly, sorry
      if sniff[:steno][:bpf]
        file '/etc/stenographer/bpf.txt' do
          action :create
          owner 'stenographer'
          group 'stenographer'
          mode '0640'
          content sniff[:steno][:bpf].strip
          notifies :run, "execute[steno_bpf_compile]", :immediately
        end

        execute 'steno_bpf_compile' do
          command "/usr/bin/compile_bpf.sh #{sniff[:interface]} \"#{sniff[:steno][:bpf]}\" > /etc/stenographer/bpf_compiled.txt"
          action :nothing
        end

      else
        file '/etc/stenographer/bpf.txt' do
          action :delete
        end

        file '/etc/stenographer/bpf_compiled.txt' do
          action :create
          content ''
        end

      end
      
      
      if sniff[:steno][:flags]
        flags = '"' + sniff[:steno][:flags].join('", "') + '"'
      else
        flags = ''
      end

      template "/etc/stenographer/config_#{sniff[:sensorname]}" do
        source 'steno/steno.conf.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
            :sniff => sniff,
            :local_port => local_port,
            :grpc_port => grpc_port,
            :flags => flags,
            :bpf => lazy { ::File.read("/etc/stenographer/bpf_compiled.txt").strip }
            # :bpf => lazy { shell_out!("/usr/bin/compile_bpf.sh #{sniff[:interface]} '#{sniff[:steno][:bpf]}'").stdout.strip }
          )
        notifies :enable, "service[stenographer_service_#{sniff[:sensorname]}]", :immediately
        notifies :restart, "service[stenographer_service_#{sniff[:sensorname]}]", :delayed
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

file '/var/log/stenographer.log' do
  action :create
  owner 'syslog'
  group 'stenographer'
  mode '0640'
end


cron_d 'steno_chmod_cron' do
  user 'stenoghrapher'
  minute '*'
  command 'chmod g+r -R /nsm/steno/'
end
