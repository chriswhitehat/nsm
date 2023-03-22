#
# Cookbook:: nsm
# Attributes:: suricata
#
# Copyright:: 2021, The Authors, All Rights Reserved.

# http libhtp settings

default[:nsm][:suricata][:config]['app-layer']['protocols']['http']['libhtp']['request-body-limit'] = '100kb'
default[:nsm][:suricata][:config]['app-layer']['protocols']['http']['libhtp']['response-body-limit'] = '100kb'

# Filestore
default[:nsm][:suricata][:config][:filestore][:enabled] = 'no'
default[:nsm][:suricata][:config][:filestore][:dir] = '/nsm/suricata/filestore'
default[:nsm][:suricata][:config][:filestore][:write_fileinfo] = 'yes'
# Stream Depth in MB
default[:nsm][:suricata][:config][:filestore][:stream_depth] = '5'
default[:nsm][:suricata][:config][:filestore][:force_hash] = '[sha256, md5]'
default[:nsm][:suricata][:config][:filestore][:force_magic] = 'no'

# Filestore prune (#s/#m/#h/#d)
default[:nsm][:suricata][:config][:filestore][:prune][:retention] = '14d'
# Make empty string to disable verbose logging
default[:nsm][:suricata][:config][:filestore][:prune][:verbose_log] = '-v'
