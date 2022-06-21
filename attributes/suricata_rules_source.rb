#
# Cookbook Name:: nsm
# Attribute:: suricata_rules_source
#

default[:nsm][:suricata][:rules][:source][:et_pro][:enabled] = false
default[:nsm][:suricata][:rules][:source][:et_pro][:code] = ''

default[:nsm][:suricata][:rules][:json][:enabled] = false
# Odd
default[:nsm][:suricata][:rules][:json][:cron_day] = '1-31/2'
# Even
#default[:nsm][:suricata][:rules][:cron_day] = '2-30/2'
