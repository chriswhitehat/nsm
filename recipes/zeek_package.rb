#
# Cookbook:: nsm
# Recipe:: zeek_package
#
# Copyright:: 2021, The Authors, All Rights Reserved.


directory '/opt/zeek/etc/zkg/' do
  owner 'zeek'
  group 'zeek'
  mode '0750'
  recursive true
  action :create
end


template '/opt/zeek/etc/zkg/config' do
  source 'zeek/zkg/config.erb'
  owner 'zeek'
  group 'zeek'
  mode '0644'
  notifies :run, 'execute[zkg_refresh]', :immediately
end

execute 'zkg_refresh' do
  command '/opt/zeek/bin/zkg refresh'
  action :nothing
end



node[:nsm][:zeek][:zkg][:package].each do |zkg_name, zkg|
  
  if zkg[:install] == true

    package zkg[:apt_deps]

    execute "install_#{zkg_name}" do
      command "/opt/zeek/bin/zkg install #{zkg[:path]} --force"
      not_if do ::Dir.exist?("/opt/zeek/var/lib/zkg/clones/package/#{zkg[:install_path]}") end
      notifies :run, "execute[pin_#{zkg_name}]", :immediately
      action :run
    end

    execute "pin_#{zkg_name}" do
      command "/opt/zeek/bin/zkg pin #{zkg[:path]}"
      action :nothing
    end
  
  else

    execute "remove_#{zkg_name}" do
      command "/opt/zeek/bin/zkg remove #{zkg[:path]} --force"
      only_if do ::Dir.exist?("/opt/zeek/var/lib/zkg/clones/package/#{zkg[:install_path]}") end
      action :run
    end

  end
    
end
