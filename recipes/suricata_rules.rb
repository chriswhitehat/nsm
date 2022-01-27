#
# Cookbook:: nsm
# Recipe:: suricata_rules
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

      var_lib_base = "/var/lib/suricata/#{sniff[:sensorname]}"

      dirs = ["/var/lib/suricata",
        "#{var_lib_base}",
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

      if sniff[:suricata][:rule_source][:et_pro][:enabled]
        template "#{var_lib_base}/update/sources/et-pro.yaml" do
          source 'suricata/rules/et-pro.yaml.erb'
          owner 'suricata'
          group 'suricata'
          mode '0640'
          variables(
            :sniff => sniff
          )
        end
      end
      

      etc_base = "/etc/suricata/#{sniff[:sensorname]}"      

      ['disable', 'drop', 'enable', 'modify'].each do |conf|

        if node[:nsm][:suricata][:rules] && node[:nsm][:suricata][:rules][conf]
          if node[:nsm][:suricata][:rules][conf][:global]
            global = node[:nsm][:suricata][:rules][conf][:global]
          else
            global = {}
          end
          if node[:nsm][:suricata][:rules][conf][sniff[:sensor_region]]
            sensor_region = node[:nsm][:suricata][:rules][conf][sniff[:sensor_region]]
          else
            sensor_region = {}
          end
          if node[:nsm][:suricata][:rules][conf][sniff[:sensor_group]]
            sensor_group = node[:nsm][:suricata][:rules][conf][sniff[:sensor_group]]
          else
            sensor_group = {}
          end
          if node[:nsm][:suricata][:rules][conf][node[:fqdn]]
            host = node[:nsm][:suricata][:rules][conf][node[:fqdn]]
          else
            host = {}
          end
          if node[:nsm][:suricata][:rules][conf][sniff[:sensorname]]
            sensor = node[:nsm][:suricata][:rules][conf][sniff[:sensorname]]
          else
            sensor = {}
          end
        else
          global = {}
          sensor_region = {}
          sensor_group = {}
          host = {}
          sensor = {}
        end


        template "#{etc_base}/#{conf}.conf" do
          source "suricata/rules/rule_configs.conf.erb"
          owner 'suricata'
          group 'suricata'
          mode '0640'
          variables({
            :sniff => sniff,
            :global_sigs => global,
            :sensor_region_sigs => sensor_region,
            :sensor_group_sigs => sensor_group,
            :host_sigs => host,
            :sensor_sigs => sensor,
            :rule_conf => conf
          })
          notifies :run, "execute[suricata_update_#{sniff[:sensorname]}]", :delayed
        end
      end


      if node[:nsm][:suricata][:rules][:local]
        if node[:nsm][:suricata][:rules][:local][:global]
          global = node[:nsm][:suricata][:rules][:local][:global]
        else
          global = {}
        end
        if node[:nsm][:suricata][:rules][:local][sniff[:sensor_region]]
          sensor_region = node[:nsm][:suricata][:rules][:local][sniff[:sensor_region]]
        else
          sensor_region = {}
        end
        if node[:nsm][:suricata][:rules][:local][sniff[:sensor_group]]
          sensor_group = node[:nsm][:suricata][:rules][:local][sniff[:sensor_group]]
        else
          sensor_group = {}
        end
        if node[:nsm][:suricata][:rules][:local][node[:fqdn]]
          host = node[:nsm][:suricata][:rules][:local][node[:fqdn]]
        else
          host = {}
        end
        if node[:nsm][:suricata][:rules][:local][sniff[:sensorname]]
          sensor = node[:nsm][:suricata][:rules][:local][sniff[:sensorname]]
        else
          sensor = {}
        end
      else
        global = {}
        sensor_region = {}
        sensor_group = {}
        host = {}
        sensor = {}
      end

      template "#{etc_base}/rules/local.rules" do
        source "suricata/rules/local.rules.erb"
        owner 'suricata'
        group 'suricata'
        mode '0640'
        variables({
          :sniff => sniff,
          :global_sigs => global,
          :sensor_region_sigs => sensor_region,
          :sensor_group_sigs => sensor_group,
          :host_sigs => host,
          :sensor_sigs => sensor
        })
        notifies :run, "execute[suricata_update_#{sniff[:sensorname]}]", :delayed
      end
    

      template "#{etc_base}/threshold.config" do
        source 'suricata/threshold.config.erb'
        owner 'suricata'
        group 'suricata'
        mode '0640'
        variables(
            :sniff => sniff
          )
        notifies :run, "execute[suricata_update_#{sniff[:sensorname]}]", :delayed
      end
    
      template "#{etc_base}/update.yaml" do
        source 'suricata/update.yaml.erb'
        owner 'suricata'
        group 'suricata'
        mode '0640'
        variables(
              :sniff => sniff
            )
        notifies :run, "execute[suricata_update_sources]", :immediately
        notifies :run, "execute[suricata_update_#{sniff[:sensorname]}]", :delayed
      end

      execute 'suricata_update_sources' do
        command "suricata-update update-sources -D #{var_lib_base} -c #{etc_base}/update.yaml"
        user "suricata"
        action :nothing
      end
      
      execute "suricata_update_#{sniff[:sensorname]}" do
        command "suricata-update -D #{var_lib_base} -c #{etc_base}/update.yaml --suricata-conf #{etc_base}/suricata.yaml"
        user "suricata"
        action :nothing
        # notifies :reload, "service[suricata]", :delayed
      end


      # service 'suricata' do
        # supports status: true, restart: true, reload: true
        # action :nothing
      # end

      cron_d "suricata_update_#{sniff[:sensorname]}" do
        action :create
        minute '0'
        hour '10'
        user 'suricata'
        command "/usr/bin/suricata-update -D #{var_lib_base} -c #{etc_base}/update.yaml --suricata-conf #{etc_base}/suricata.yaml"
      end

    end


  end
end



