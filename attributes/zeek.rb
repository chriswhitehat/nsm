#
# Cookbook:: nsm
# Attributes:: zeek
#
# Copyright:: 2021, The Authors, All Rights Reserved.

# Zeekctl
default[:nsm][:zeek][:config][:mail_to] = 'root@localhost'

default[:nsm][:zeek][:config][:log_dir] = '/nsm/zeek/logs'
default[:nsm][:zeek][:config][:spool_dir] = '/nsm/zeek/spool'
default[:nsm][:zeek][:config][:broker_db_dir] = '/nsm/zeek/spool/brokerstore'


###############
# Zeek Packages
###############
default[:nsm][:zeek][:zkg][:package][:af_packet][:install] = true
default[:nsm][:zeek][:zkg][:package][:af_packet][:apt_deps] = ['cmake', 'build-essential',  'linux-headers-generic', "linux-headers-#{node[:kernel][:release]}"]
default[:nsm][:zeek][:zkg][:package][:af_packet][:path] = 'zeek/j-gras/zeek-af_packet-plugin'
default[:nsm][:zeek][:zkg][:package][:af_packet][:install_path] = 'zeek-af_packet-plugin'

default[:nsm][:zeek][:zkg][:package][:ja3][:install] = true
default[:nsm][:zeek][:zkg][:package][:ja3][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:ja3][:path] = 'ja3'
default[:nsm][:zeek][:zkg][:package][:ja3][:install_path] = 'ja3'

default[:nsm][:zeek][:zkg][:package][:hassh][:install] = true
default[:nsm][:zeek][:zkg][:package][:hassh][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:hassh][:path] = 'salesforce/hassh'
default[:nsm][:zeek][:zkg][:package][:hassh][:install_path] = 'hassh'

default[:nsm][:zeek][:zkg][:package][:add_node_names][:install] = true
default[:nsm][:zeek][:zkg][:package][:add_node_names][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:add_node_names][:path] = 'zeek/j-gras/add-node-names'
default[:nsm][:zeek][:zkg][:package][:add_node_names][:install_path] = 'add-node-names'

default[:nsm][:zeek][:zkg][:package][:bzar][:install] = true
default[:nsm][:zeek][:zkg][:package][:bzar][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:bzar][:path] = 'mitre-attack/bzar'
default[:nsm][:zeek][:zkg][:package][:bzar][:install_path] = 'bzar'

default[:nsm][:zeek][:zkg][:package][:cryptomining][:install] = true
default[:nsm][:zeek][:zkg][:package][:cryptomining][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:cryptomining][:path] = 'jsiwek/zeek-cryptomining'
default[:nsm][:zeek][:zkg][:package][:cryptomining][:install_path] = 'zeek-cryptomining'

default[:nsm][:zeek][:zkg][:package][:community_id][:install] = true
default[:nsm][:zeek][:zkg][:package][:community_id][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:community_id][:path] = 'zeek-community-id'
default[:nsm][:zeek][:zkg][:package][:community_id][:install_path] = 'zeek-community-id'

default[:nsm][:zeek][:zkg][:package][:json_streaming_logs][:install] = true
default[:nsm][:zeek][:zkg][:package][:json_streaming_logs][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package][:json_streaming_logs][:path] = 'json-streaming-logs'
default[:nsm][:zeek][:zkg][:package][:json_streaming_logs][:install_path] = 'json-streaming-logs'



