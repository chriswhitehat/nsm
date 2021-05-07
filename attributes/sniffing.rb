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
default[:nsm][:interfaces][:sniffing][:iface][:sensorname] = 'sensorname'
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
default[:nsm][:interfaces][:sniffing][:iface][:suricata][:lb_procs] = 1


##############
# Zeek
##############
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:enabled] = true
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:lb_procs] = 1
default[:nsm][:interfaces][:sniffing][:iface][:zeek][:extract_files] = false


##############
# Stenographer
##############

default[:nsm][:interfaces][:sniffing][:iface][:stenographer][:enabled] = true






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
