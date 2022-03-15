#
# Cookbook:: nsm
# Attributes:: zeek
#
# Copyright:: 2021, The Authors, All Rights Reserved.

# Zeekctl
default[:nsm][:zeek][:config][:mail_to] = 'root@localhost'

default[:nsm][:zeek][:config][:log_dir] = '/nsm/zeek/logs'
default[:nsm][:zeek][:config][:extracted_dir] = '/nsm/zeek/extracted'
default[:nsm][:zeek][:config][:spool_dir] = '/nsm/zeek/spool'
default[:nsm][:zeek][:config][:broker_db_dir] = '/nsm/zeek/spool/brokerstore'
#default[:nsm][:zeek][:config][:log_expire_interval] = '7 days'
default[:nsm][:zeek][:config][:log_expire_days] = '0'


###############
# Zkg Sources
###############
default[:nsm][:zeek][:zkg][:source][:zeek] = 'https://github.com/zeek/packages'

###############
# Zkg Packages
###############
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:apt_deps] = ['cmake', 'build-essential',  'linux-headers-generic', "linux-headers-#{node[:kernel][:release]}"]
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:path] = 'zeek/j-gras/zeek-af_packet-plugin'
default[:nsm][:zeek][:zkg][:package]['zeek-af_packet-plugin'][:install_path] = 'zeek-af_packet-plugin'

default[:nsm][:zeek][:zkg][:package]['json-streaming-logs'][:install] = false
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

default[:nsm][:zeek][:zkg][:package]['file-extraction'][:install] = true
default[:nsm][:zeek][:zkg][:package]['file-extraction'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['file-extraction'][:path] = 'zeek/hosom/file-extraction'
default[:nsm][:zeek][:zkg][:package]['file-extraction'][:install_path] = 'file-extraction'


# TODO: Add download script/cron for fsrm 
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:install] = true
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:path] = 'corelight/detect-ransomware-filenames'
default[:nsm][:zeek][:zkg][:package]['detect-ransomware-filenames'][:install_path] = 'detect-ransomware-filenames'

default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:install] = false
default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:path] = 'zeek_files_filter'
default[:nsm][:zeek][:zkg][:package]['zeek_files_filter'][:install_path] = 'zeek_files_filter'

default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:install] = true
default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:path] = 'zeek_pcr'
default[:nsm][:zeek][:zkg][:package]['zeek_pcr'][:install_path] = 'zeek_pcr'


#####################
# Zkg Local Packages
#####################

default[:nsm][:zeek][:zkg][:local_package]['base_streams'][:install] = true
default[:nsm][:zeek][:zkg][:local_package]['base_streams'][:name] = 'base_streams'
default[:nsm][:zeek][:zkg][:local_package]['base_streams'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:local_package]['base_streams'][:load_template] = true
default[:nsm][:zeek][:zkg][:local_package]['base_streams'][:script_templates] = ['base_streams.zeek']
default[:nsm][:zeek][:zkg][:local_package]['base_streams'][:disable]['Syslog::LOG'] = true


default[:nsm][:zeek][:zkg][:local_package]['cert_authorities'][:install] = true
default[:nsm][:zeek][:zkg][:local_package]['cert_authorities'][:name] = 'cert_authorities'
default[:nsm][:zeek][:zkg][:local_package]['cert_authorities'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:local_package]['cert_authorities'][:load_template] = true
default[:nsm][:zeek][:zkg][:local_package]['cert_authorities'][:script_templates] = ['cert_authorities.zeek',
																					 'gen_certs.py']


default[:nsm][:zeek][:zkg][:local_package]['extractions'][:install] = true
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:name] = 'extractions'
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:load_template] = true
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:script_templates] = ['extractions.zeek']
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/x-dosexec"] = "exe"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/x-java-applet"] = "class"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/x-java-archive"] = "jar"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/zip"] = "zip"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/pdf"] = "pdf"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/x-rar"] = "rar"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/vnd.openxmlformats-officedocument.wordprocessingml.document"] = "docx"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["text/rtf"] = "rtf" 
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/vnd.openxmlformats-officedocument.presentationml.presentation"] = "pptx"
default[:nsm][:zeek][:zkg][:local_package]['extractions'][:mimetypes]["application/vnd.openxmlformats-officedocument"]  = "pptx"


default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:install] = true
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:name] = 'scan_conf'
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:apt_deps] = []
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:load_template] = true
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:script_templates] = ['scan_conf.zeek']
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:confs][:addr_scan_interval] = '5min'
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:confs][:addr_scan_threshold] = '25.0'
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:confs][:port_scan_interval] = '5min'
default[:nsm][:zeek][:zkg][:local_package]['scan_conf'][:confs][:port_scan_threshold] = '15.0'
