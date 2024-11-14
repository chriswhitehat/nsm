#
# Cookbook:: nsm
# Attributes:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

default[:nsm][:timezone] = 'Etc/UTC'

default[:nsm][:zeek][:enabled] = false
default[:nsm][:zeek][:version] = '7.0.3'

default[:nsm][:suricata][:enabled] = false
default[:nsm][:suricata][:version] = '7.0.7'

# default[:nsm][:go][:version] = '1.17.5'
default[:nsm][:go][:version] = '1.23.2'

default[:nsm][:steno][:enabled] = false
default[:nsm][:steno][:version] = 'v1.0.1'

default[:nsm][:pcapfab][:enabled] = false

default[:nsm][:sensor_region] = 'default_region'
default[:nsm][:sensor_group] = 'default_group'

default[:nsm][:maintenance_mode] = false
