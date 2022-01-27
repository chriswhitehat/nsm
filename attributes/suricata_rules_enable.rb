#
# Cookbook Name:: nsm
# Attribute:: suricata_rules
#

##########################
# Suricata-Update formatting
##########################


# Example of enabling a rule by signature ID (gid is optional).
# 1:2019401
# 2019401

# Example of enabling a rule by regular expression.
# - All regular expression matches are case insensitive.
# re:heartbleed
# re:MS(0[7-9]|10)-\d+

# Example of enabling a group of rules.
# group:emerging-icmp.rules
# group:emerging-dos
# group:emerging*


##########################
# Global
##########################

# Example
#default[:nsm][:suricata][:rules][:enable][:global]['re:ET CNC'] = true

##########################
# Sensor Region
##########################

# Example
#default[:nsm][:suricata][:rules][:enable]['default_region']['1:220'] = true

##########################
# Sensor Group
##########################

# Example
#default[:nsm][:suricata][:rules][:enable]['default_group']['1:123'] = true

##########################
# Host Chef FQDN
##########################

# Example
#default[:nsm][:suricata][:rules][:enable]['nsmsensor']['re:MS(0[7-9]|10)-\d+'] = true

##########################
# Sensor 
##########################

# Example
#default[:nsm][:suricata][:rules][:enable]['sensorname']['1:1034'] = true
