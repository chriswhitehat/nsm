#
# Cookbook:: nsm
# Recipe:: pcapfab_config
#
# Copyright:: 2022, The Authors, All Rights Reserved. 

nsm_logrotate_paths = ['/var/log/pcapfab.log']

logrotate_app "rotate-pcapfab" do
  path      nsm_logrotate_paths
  frequency 'daily'
  rotate    14
  create    '640 pcapfab pcapfab'
end
