#
# Cookbook:: nsm
# Recipe:: nsmsensor
#
# Copyright:: 2021, The Authors, All Rights Reserved.


node.normal[:nsm][:interfaces][:mgmt][:configure] = false
node.normal[:nsm][:interfaces][:mgmt][:interface] = 'eth0'
node.normal[:nsm][:interfaces][:mgmt][:ipv4] = '192.168.50.11'
node.normal[:nsm][:interfaces][:mgmt][:netmask] = '255.255.255.0'
node.normal[:nsm][:interfaces][:mgmt][:gateway] = '192.168.50.1'
node.normal[:nsm][:interfaces][:mgmt][:nameserver] = '192.168.50.1'
node.normal[:nsm][:interfaces][:mgmt][:domain] = 'example.com'

node.normal[:nsm][:interfaces][:sniffing][:eth2][:enabled] = true
node.normal[:nsm][:interfaces][:sniffing][:eth2][:interface] = "eth2"


include_recipe 'nsm::sensor'

