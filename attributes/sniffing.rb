#
# Cookbook:: nsm
# Attributes:: sniffing
#
# Copyright:: 2021, The Authors, All Rights Reserved.

#####################
# Sniffing Defaults
#####################
default[:nsm][:interfaces][:sniffing][:iface][:enabled] = false
default[:nsm][:interfaces][:sniffing][:iface][:interface] = 'eth1'
default[:nsm][:interfaces][:sniffing][:iface][:mtu] = 9060
# Ensure sensorname is directory safe.
default[:nsm][:interfaces][:sniffing][:iface][:sensorname] = 'sensorname'
# Region or broader locations
default[:nsm][:interfaces][:sniffing][:iface][:sensor_region] = 'default_region'
# Specific group of sensors within a region
default[:nsm][:interfaces][:sniffing][:iface][:sensor_group] = 'default_group'
default[:nsm][:interfaces][:sniffing][:iface][:nic_offloading] = 'rx tx sg tso ufo gso gro lro'

# Sensor net group, should be same as sensorname unless breaking down individual services per server.
#default[:nsm][:interfaces][:sniffing][:iface][:sensor_net_group] = 'sensorname'
# homenet definition
default[:nsm][:interfaces][:sniffing][:iface][:homenet]['192.168.0.0/16'] = 'rfc1918 IP Space'
default[:nsm][:interfaces][:sniffing][:iface][:homenet]['10.0.0.0/8'] = 'rfc1918 IP Space'
default[:nsm][:interfaces][:sniffing][:iface][:homenet]['172.16.0.0/12'] = 'rfc1918 IP Space'

##############
# Suricata
##############
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:enabled] = true
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['threads'] = 5
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['cluster-type'] = 'cluster_flow'
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['defrag'] = 'yes'
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['use-mmap'] = 'yes'
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['mmap-locked'] = 'no'
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['tpacket-v3'] = 'yes'
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['ring-size'] = 400000
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['block-size'] = 1048576
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['block-timeout'] = 10
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['use-emergency-flush'] = 'no'
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['buffer-size'] = 262144
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['disable-promisc'] = 'no'
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['checksum-checks'] = 'kernel'
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['bpf-filter'] = 'port 80 or udp'
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['copy-mode'] = 'ips'
#default[:nsm][:interfaces][:sniffing][:iface][:suricata][:af_packet]['copy-iface'] = 'eth1'



##############
# Zeek
##############
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:enabled] = true
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:lb_count] = 5
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:extract_files] = false


##############
# Stenographer
##############

default[:nsm][:interfaces][:sniffing][:iface][:steno][:enabled] = true
default[:nsm][:interfaces][:sniffing][:iface][:steno][:lb_count] = 1
default[:nsm][:interfaces][:sniffing][:iface][:steno][:max_directory_files] = 750000
default[:nsm][:interfaces][:sniffing][:iface][:steno][:disk_free_percentage] = 5
default[:nsm][:interfaces][:sniffing][:iface][:steno][:host] = '127.0.0.1'
# Set reserved memory (default: 8GB)
# Set file reallocate for xfs (default: 4GB)
default[:nsm][:interfaces][:sniffing][:iface][:steno][:flags] = ["-v", "--blocks=8192", "--preallocate_file_mb=4096"]
default[:nsm][:interfaces][:sniffing][:iface][:steno][:grpc] = true
default[:nsm][:interfaces][:sniffing][:iface][:steno][:bpf] = ''



################
# NUMA Affinity
################

# interface NUMA node
default[:nsm][:interfaces][:sniffing][:iface][:numa_node] = 0

# enable Suricata Numa and CPU affinity
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:numa_tune] = false
# NUMA CPU affinity mode (numa|increment|range)
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:numa_cpu_mode] = "increment"
# IDS NUMA pyhsical cpu start 
#    zero based beginning of range to ping lb procs
#    ignored if mode is numa 
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:numa_cpu] = 0
# IDS NUMA pyhsical cpu step 
#    negative to go in reverse (20,19,...)
#    ignored if mode is numa or range
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:numa_cpu_step] = 1
# enable squil agent to send ids alerts to server (applies to snort and suricata)


# enable zeek Numa and CPU affinity
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:numa_tune] = false
# zeek NUMA pyhsical cpu start 
#    zero based beginning of range to pin lb procs
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:numa_cpu] = 0


# enable pcap Numa and CPU affinity
default[:nsm][:interfaces][:sniffing][:iface][:stenographer][:numa_tune] = false
# pcap NUMA pyhsical cpu single cpu
default[:nsm][:interfaces][:sniffing][:iface][:stenographer][:numa_cpu] = 2
