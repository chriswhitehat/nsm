#
# Cookbook:: nsm
# Attributes:: interfaces
#
# Copyright:: 2021, The Authors, All Rights Reserved.

################################
# Management Interface
################################
# MGMT_INTERFACE
# Which network interface should be the management interface?
# The management interface has an IP address and is NOT used for sniffing.
# We recommend that you always make this eth0 if possible for consistency.
default[:nsm][:interfaces][:mgmt][:configure] = true
default[:nsm][:interfaces][:mgmt][:interface] = 'eth0'
default[:nsm][:interfaces][:mgmt][:ipv4] = '127.0.0.1'
default[:nsm][:interfaces][:mgmt][:netmask] = '255.255.255.0'
default[:nsm][:interfaces][:mgmt][:gateway] = '127.0.0.1'
default[:nsm][:interfaces][:mgmt][:nameserver] = '127.0.0.1'
default[:nsm][:interfaces][:mgmt][:domain] = 'example.com'
