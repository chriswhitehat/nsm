#
# Cookbook:: nsm
# Attributes:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

default[:nsm][:zeek][:enabled] = false
default[:nsm][:zeek][:version] = '4.0.1'

default[:nsm][:suricata][:enabled] = false
default[:nsm][:suricata][:version] = '5.0.3'

default[:nsm][:steno][:enabled] = true

default[:nsm][:sensor_group] = 'default_group'
