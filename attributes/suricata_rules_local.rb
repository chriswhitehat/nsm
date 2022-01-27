##########################
# Global
##########################

# Example
# default[:nsm][:suricata][:rules][:local]['sensor_region']["ET POLICY Office Document Containing Workbook_Open Macro Via smtp"] = 'alert tcp $EXTERNAL_NET any -> $SMTP_SERVERS [25,587] '\
#                                                                                                                                   '(msg:"ET POLICY Office Document Containing Workbook_Open Macro Via smtp"; '\
#                                                                                                                                   'flow:established,to_server; '\
#                                                                                                                                   'content:"VwBvcmtib29rXwBPcGVu"; '\
#                                                                                                                                   'reference:url,support.microsoft.com/kb/286310,http://www.mrexcel.com/forum/excel-questions/7471-autoexec-macro-question.html; '\
#                                                                                                                                   'classtype:policy-violation; '\
#                                                                                                                                   'sid:1000047; '\
#                                                                                                                                   'rev:2;)'                                                                                                                           'rev:2;)'
 
##########################
# Sensor Region
##########################

# Example
# default[:nsm][:suricata][:rules][:local]['sensor_region']["ET POLICY Office Document Containing Workbook_Open Macro Via smtp"] = 'alert tcp $EXTERNAL_NET any -> $SMTP_SERVERS [25,587] '\
#                                                                                                                                   '(msg:"ET POLICY Office Document Containing Workbook_Open Macro Via smtp"; '\
#                                                                                                                                   'flow:established,to_server; '\
#                                                                                                                                   'content:"VwBvcmtib29rXwBPcGVu"; '\
#                                                                                                                                   'reference:url,support.microsoft.com/kb/286310,http://www.mrexcel.com/forum/excel-questions/7471-autoexec-macro-question.html; '\
#                                                                                                                                   'classtype:policy-violation; '\
#                                                                                                                                   'sid:1000047; '\
#                                                                                                                                   'rev:2;)'

##########################
# Sensor Group
##########################

# Example
# default[:nsm][:suricata][:rules][:local]['sensor_group']["ET POLICY Office Document Containing Workbook_Open Macro Via smtp"] = 'alert tcp $EXTERNAL_NET any -> $SMTP_SERVERS [25,587] '\
#                                                                                                                                   '(msg:"ET POLICY Office Document Containing Workbook_Open Macro Via smtp"; '\
#                                                                                                                                   'flow:established,to_server; '\
#                                                                                                                                   'content:"VwBvcmtib29rXwBPcGVu"; '\
#                                                                                                                                   'reference:url,support.microsoft.com/kb/286310,http://www.mrexcel.com/forum/excel-questions/7471-autoexec-macro-question.html; '\
#                                                                                                                                   'classtype:policy-violation; '\
#                                                                                                                                   'sid:1000047; '\
#                                                                                                                                   'rev:2;)'

##########################
# Host Chef FQDN
##########################

# Example
# default[:nsm][:suricata][:rules][:local]['sosensor']["ET POLICY Office Document Containing Workbook_Open Macro Via smtp"] = 'alert tcp $EXTERNAL_NET any -> $SMTP_SERVERS [25,587] '\
#                                                                                                                                   '(msg:"ET POLICY Office Document Containing Workbook_Open Macro Via smtp"; '\
#                                                                                                                                   'flow:established,to_server; '\
#                                                                                                                                   'content:"VwBvcmtib29rXwBPcGVu"; '\
#                                                                                                                                   'reference:url,support.microsoft.com/kb/286310,http://www.mrexcel.com/forum/excel-questions/7471-autoexec-macro-question.html; '\
#                                                                                                                                   'classtype:policy-violation; '\
#                                                                                                                                   'sid:1000047; '\
#                                                                                                                                   

##########################
# Sensor 
##########################

# Example
# default[:nsm][:suricata][:rules][:local]['sensorname']["ET POLICY Office Document Containing Workbook_Open Macro Via smtp"] = 'alert tcp $EXTERNAL_NET any -> $SMTP_SERVERS [25,587] '\
#                                                                                                                                   '(msg:"ET POLICY Office Document Containing Workbook_Open Macro Via smtp"; '\
#                                                                                                                                   'flow:established,to_server; '\
#                                                                                                                                   'content:"VwBvcmtib29rXwBPcGVu"; '\
#                                                                                                                                   'reference:url,support.microsoft.com/kb/286310,http://www.mrexcel.com/forum/excel-questions/7471-autoexec-macro-question.html; '\
#                                                                                                                                   'classtype:policy-violation; '\
#                                                                                                                                   'sid:1000047; '\
