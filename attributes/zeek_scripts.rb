#
# Cookbook Name:: nsm
# Attribute:: zeek_scripts
#

##########################
# Disable Base Streams
##########################
# Notes: -Expects the Stream name to disable
#        -setting to false will disable, all other values will ignore the attribute


# Syslog Stream (not disabled by default)
default[:nsm][:zeek][:base_streams][:global]['Syslog::LOG'] = true


##########################
# Load Zeek Intel
##########################
default[:nsm][:zeek][:intel][:global]['/opt/zeek/share/zeek/intel/xsoar_watchlist.txt'] = false

##########################
# Load Zeek Sigs
##########################

# This adds signatures to detect cleartext forward and reverse windows shells.
default[:nsm][:zeek][:sigs][:global]['frameworks/signatures/detect-windows-shells'] = true


##########################
# Load Zeek Scripts
##########################

# This script logs which scripts were loaded during each run.
default[:nsm][:zeek][:scripts][:global]['misc/loaded-scripts'] = true

# Apply the default tuning scripts for common tuning settings.
default[:nsm][:zeek][:scripts][:global]['tuning/defaults'] = true

# Estimate and log capture loss.
default[:nsm][:zeek][:scripts][:global]['misc/capture-loss'] = true

# Enable logging of memory, packet and lag statistics.
default[:nsm][:zeek][:scripts][:global]['misc/stats'] = true

# Load the scan detection script.
default[:nsm][:zeek][:scripts][:global]['misc/scan'] = true

# Detect traceroute being run on the network. This could possibly cause
# performance trouble when there are a lot of traceroutes on your network.
# Enable cautiously.
default[:nsm][:zeek][:scripts][:global]['misc/detect-traceroute'] = false

# Generate notices when vulnerable versions of software are discovered.
# The default is to only monitor software found in the address space defined
# as "local".  Refer to the software framework's documentation for more
# information.
default[:nsm][:zeek][:scripts][:global]['frameworks/software/vulnerable'] = true

# Detect software changing (e.g. attacker installing hacked SSHD).
default[:nsm][:zeek][:scripts][:global]['frameworks/software/version-changes'] = true

# Load all of the scripts that detect software in various protocols.
default[:nsm][:zeek][:scripts][:global]['protocols/ftp/software'] = true
default[:nsm][:zeek][:scripts][:global]['protocols/smtp/software'] = true
default[:nsm][:zeek][:scripts][:global]['protocols/ssh/software'] = true
default[:nsm][:zeek][:scripts][:global]['protocols/http/software'] = true

# The detect-webapps script could possibly cause performance trouble when
# running on live traffic.  Enable it cautiously.
default[:nsm][:zeek][:scripts][:global]['protocols/http/detect-webapps'] = false

# This script detects DNS results pointing toward your Site::local_nets
# where the name is not part of your local DNS zone and is being hosted
# externally.  Requires that the Site::local_zones variable is defined.
default[:nsm][:zeek][:scripts][:global]['protocols/dns/detect-external-names'] = true

# Script to detect various activity in FTP sessions.
default[:nsm][:zeek][:scripts][:global]['protocols/ftp/detect'] = true

# Scripts that do asset tracking.
default[:nsm][:zeek][:scripts][:global]['protocols/conn/known-hosts'] = true
default[:nsm][:zeek][:scripts][:global]['protocols/conn/known-services'] = true
default[:nsm][:zeek][:scripts][:global]['protocols/ssl/known-certs'] = true

# This script enables SSL/TLS certificate validation.
default[:nsm][:zeek][:scripts][:global]['protocols/ssl/validate-certs'] = true

# This script prevents the logging of SSL CA certificates in x509.log
default[:nsm][:zeek][:scripts][:global]['protocols/ssl/log-hostcerts-only'] = true

# Uncomment the following line to check each SSL certificate hash against the ICSI
# certificate notary service; see http://notary.icsi.berkeley.edu .
default[:nsm][:zeek][:scripts][:global]['protocols/ssl/notary'] = false

# If you have libGeoIP support built in, do some geographic detections and
# logging for SSH traffic.
default[:nsm][:zeek][:scripts][:global]['protocols/ssh/geo-data'] = true
# Detect hosts doing SSH bruteforce attacks.
default[:nsm][:zeek][:scripts][:global]['protocols/ssh/detect-bruteforcing'] = true
# Detect logins using "interesting" hostnames.
default[:nsm][:zeek][:scripts][:global]['protocols/ssh/interesting-hostnames'] = true

# Detect SQL injection attacks.
default[:nsm][:zeek][:scripts][:global]['protocols/http/detect-sqli'] = true

#### Network File Handling ####

# Enable MD5 and SHA1 hashing for all files.
default[:nsm][:zeek][:scripts][:global]['frameworks/files/hash-all-files'] = true

# Detect SHA1 sums in Team Cymru's Malware Hash Registry.
default[:nsm][:zeek][:scripts][:global]['frameworks/files/detect-MHR'] = true

# Extend email alerting to include hostnames
default[:nsm][:zeek][:scripts][:global]['policy/frameworks/notice/extend-email/hostnames'] = true

# Uncomment the following line to enable logging of connection VLANs. Enabling
# this adds two VLAN fields to the conn.log file.
default[:nsm][:zeek][:scripts][:global]['policy/protocols/conn/vlan-logging'] = false

# Uncomment the following line to enable logging of link-layer addresses. Enabling
# this adds the link-layer address for each connection endpoint to the conn.log file.
default[:nsm][:zeek][:scripts][:global]['policy/protocols/conn/mac-logging'] = false


##############
# Zkg
##############

# json-streaming-logs to include streaming json logs alongside regular logs.
default[:nsm][:zeek][:scripts][:global]['json-streaming-logs'] = false

# Adds community id to zeek conn logs
default[:nsm][:zeek][:scripts][:global]['zeek-community-id'] = false

# Add ssl handshake ja3 hash fingerprint to ssl log
default[:nsm][:zeek][:scripts][:global]['ja3'] = false

# Add ssh handshake ja3 hash fingerprint to ssh log
default[:nsm][:zeek][:scripts][:global]['hassh'] = false

# Add the bzar data to various zeek logs
default[:nsm][:zeek][:scripts][:global]['bzar'] = false

# Add notice for cryptomining traffic
default[:nsm][:zeek][:scripts][:global]['zeek-cryptomining'] = false

# Add node names to logs
default[:nsm][:zeek][:scripts][:global]['add-node-names'] = false

# Check for and create notice entries on known ransomware extensions
default[:nsm][:zeek][:scripts][:global]['detect-ransomware-filenames'] = false

# Add the ability to filter out noisey files log events by mime-type (SSL file)
default[:nsm][:zeek][:scripts][:global]['zeek_files_filter'] = false

# Add producer consumer ratio PCR to the conn log
default[:nsm][:zeek][:scripts][:global]['zeek_pcr'] = false

# Add node name to the conn log
default[:nsm][:zeek][:scripts][:global]['zeek_add_node_name'] = false

# Add node name to the conn log
default[:nsm][:zeek][:scripts][:global]['zeek_filter_hooks'] = false

# File Extractions
default[:nsm][:zeek][:scripts][:global]['file-extraction'] = false


# TODO: 
# You can load your own intel into:
# /opt/zeek/share/zeek/intel/
default[:nsm][:zeek][:scripts][:global]['intel'] = false



###############
# Custom
###############

# Add the base streams disable script
default[:nsm][:zeek][:scripts][:global]['base_streams'] = false

# Load Certificate Authorities to improve certificate validation
default[:nsm][:zeek][:scripts][:global]['cert_authorities']  = false

# Extract high value file types
default[:nsm][:zeek][:scripts][:global]['extractions'] = false

# Change default zeek config for Scan script
default[:nsm][:zeek][:scripts][:global]['scan_conf'] = false


