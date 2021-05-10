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
# Zkg Sources
###############
default[:nsm][:zeek][:zkg][:source][:zeek] = 'https://github.com/zeek/packages'

###############
# Zeek Packages
###############
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:apt_deps] = ['cmake', 'build-essential',  'linux-headers-generic', "linux-headers-#{node[:kernel][:release]}"]
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:path] = 'zeek/j-gras/zeek-af_packet-plugin'
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:install_path] = 'zeek-af_packet-plugin'

default[:nsm][:zeek][:zkg][:package]['json-streaming-logs'][:install] = true
default[:nsm][:zeek][:zkg][:package]['json-streaming-logs'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['json-streaming-logs'][:path] = 'json-streaming-logs'
default[:nsm][:zeek][:zkg][:package]['json-streaming-logs'][:install_path] = 'json-streaming-logs'

default[:nsm][:zeek][:zkg][:package]['zeek-community-id'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek-community-id'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['zeek-community-id'][:path] = 'zeek-community-id'
default[:nsm][:zeek][:zkg][:package]['zeek-community-id'][:install_path] = 'zeek-community-id'

default[:nsm][:zeek][:zkg][:package]['ja3'][:install] = true
default[:nsm][:zeek][:zkg][:package]['ja3'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['ja3'][:path] = 'ja3'
default[:nsm][:zeek][:zkg][:package]['ja3'][:install_path] = 'ja3'

default[:nsm][:zeek][:zkg][:package]['hassh'][:install] = true
default[:nsm][:zeek][:zkg][:package]['hassh'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['hassh'][:path] = 'salesforce/hassh'
default[:nsm][:zeek][:zkg][:package]['hassh'][:install_path] = 'hassh'

default[:nsm][:zeek][:zkg][:package]['bzar'][:install] = true
default[:nsm][:zeek][:zkg][:package]['bzar'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['bzar'][:path] = 'mitre-attack/bzar'
default[:nsm][:zeek][:zkg][:package]['bzar'][:install_path] = 'bzar'

default[:nsm][:zeek][:zkg][:package]['zeek-cryptomining'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek-cryptomining'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['zeek-cryptomining'][:path] = 'jsiwek/zeek-cryptomining'
default[:nsm][:zeek][:zkg][:package]['zeek-cryptomining'][:install_path] = 'zeek-cryptomining'

default[:nsm][:zeek][:zkg][:package]['add-node-names'][:install] = true
default[:nsm][:zeek][:zkg][:package]['add-node-names'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['add-node-names'][:path] = 'zeek/j-gras/add-node-names'
default[:nsm][:zeek][:zkg][:package]['add-node-names'][:install_path] = 'add-node-names'

# TODO: Add download script/cron for fsrm 
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:install] = true
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:path] = 'corelight/detect-ransomware-filenames'
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:install_path] = 'detect-ransomware-filenames'

default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:path] = 'zeek_files_filter'
default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:install_path] = 'zeek_files_filter'

default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:path] = 'zeek_pcr'
default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:install_path] = 'zeek_pcr'
