#
# Cookbook:: nsm
# Recipe:: nsmsensor
#
# Copyright:: 2021, The Authors, All Rights Reserved.

node.normal[:nsm][:zeek][:enabled] = false
node.normal[:nsm][:suricata][:enabled] = false

node.normal[:nsm][:interfaces][:mgmt][:configure] = false
node.normal[:nsm][:interfaces][:mgmt][:interface] = 'eth0'
node.normal[:nsm][:interfaces][:mgmt][:ipv4] = '192.168.50.11'
node.normal[:nsm][:interfaces][:mgmt][:netmask] = '255.255.255.0'
node.normal[:nsm][:interfaces][:mgmt][:gateway] = '192.168.50.1'
node.normal[:nsm][:interfaces][:mgmt][:nameserver] = '192.168.50.1'
node.normal[:nsm][:interfaces][:mgmt][:domain] = 'example.com'

node.normal[:nsm][:interfaces][:sniffing][:eth2][:enabled] = true
node.normal[:nsm][:interfaces][:sniffing][:eth2][:interface] = "eth2"
node.normal[:nsm][:interfaces][:sniffing][:eth2][:steno][:lb_count] = 2


node.normal[:nsm][:zeek][:zkg][:source][:chriswhitehat] = 'https://github.com/chriswhitehat/zkg'

node.normal[:nsm][:zeek][:scripts][:global]['json-streaming-logs'] = true
node.normal[:nsm][:zeek][:scripts][:global]['zeek-community-id'] = true
node.normal[:nsm][:zeek][:scripts][:global]['ja3'] = true
node.normal[:nsm][:zeek][:scripts][:global]['hassh'] = true
node.normal[:nsm][:zeek][:scripts][:global]['bzar'] = true
node.normal[:nsm][:zeek][:scripts][:global]['zeek-cryptomining'] = true
node.normal[:nsm][:zeek][:scripts][:global]['add-node-names'] = true
node.normal[:nsm][:zeek][:scripts][:global]['detect-ransomware-filenames'] = true
node.normal[:nsm][:zeek][:scripts][:global]['zeek_files_filter'] = false
node.normal[:nsm][:zeek][:scripts][:global]['zeek_pcr'] = true

include_recipe 'nsm::sensor'

