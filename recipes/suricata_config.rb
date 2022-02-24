#
# Cookbook:: nsm
# Recipe:: suricata_config
#
# Copyright:: 2021, The Authors, All Rights Reserved.


if node[:nsm][:interfaces][:sniffing] 

  suricata_cluster_id = 90
  
  homenet_descs = ''
  homenet = []

  af_packet = ''

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
              "/etc/suricata/rules" ]

      dirs.each do |dir|
        directory dir do
          owner 'suricata'
          group 'suricata'
          mode '0750'
          action :create
        end
      end

      # Collect AF Packet settings
      sniff[:suricata]['cluster-id'] = suricata_cluster_id


      
      af_packet << "\n"
      af_packet << "  - interface: #{sniff[:interface]}\n"
      af_packet << "    cluster-id: #{suricata_cluster_id}\n"

      if sniff[:suricata][:af_packet]
        sniff[:suricata][:af_packet].each do |key, val|
          af_packet << "    #{key}: #{val}\n"
        end
      end
      
      # Collect homenets
      if sniff[:homenet]
        sniff[:homenet].each do |net, desc|

          homenet << net

          homenet_descs << "# #{net} - #{desc}\n"
          homenet << net
        end
      end

      suricata_cluster_id += 1

    end
  end

  nsm_logrotate_paths = ['/nsm/suricata/suricata.log',
                        '/nsm/suricata/stats.log',
                        '/nsm/suricata/eve.json',
                        '/var/log/suricata/suricata-start.log']

  logrotate_app "rotate-suricata" do
    path      nsm_logrotate_paths
    frequency 'daily'
    rotate    14
    create    '640 suricata nsm'
    postrotate <<-EOF
    /bin/kill -HUP `cat /var/run/suricata.pid 2>/dev/null` 2>/dev/null || true 
    EOF
  end



  template "/etc/suricata/suricata.yaml" do
    source 'suricata/suricata.yaml.erb'
    owner 'suricata'
    group 'suricata'
    mode '0640'
    variables(
        :homenet => homenet,
        :homenet_descs => homenet_descs,
        :af_packet => af_packet
      )
    notifies :restart, 'service[suricata.service]'
  end

  service 'suricata.service' do
    action :nothing
  end
  
end
