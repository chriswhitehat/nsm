#
# Cookbook:: nsm
# Attributes:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

default[:nsm][:timezone] = 'Etc/UTC'

default[:nsm][:zeek][:enabled] = false
default[:nsm][:zeek][:version] = '4.0.1'

default[:nsm][:suricata][:enabled] = false
default[:nsm][:suricata][:version] = '5.0.3'

default[:nsm][:go][:version] = '1.17.5'

default[:nsm][:steno][:enabled] = false
default[:nsm][:steno][:version] = 'v1.0.1'

default[:nsm][:pcapfab][:enabled] = false

default[:nsm][:sensor_region] = 'default_region'
default[:nsm][:sensor_group] = 'default_group'
