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
      notifies :run, 'execute[zkg_refresh]', :before
      notifies :run, "execute[pin_#{zkg_name}]", :immediately
      action :run
    end

    execute "pin_#{zkg_name}" do
      command "/opt/zeek/bin/zkg pin #{zkg[:path]}"
      action :nothing
      notifies :run, 'execute[deploy_zeek]', :delayed
    end
  
  else

    execute "remove_#{zkg_name}" do
      command "/opt/zeek/bin/zkg remove #{zkg[:path]} --force"
      only_if do ::Dir.exist?("/opt/zeek/var/lib/zkg/clones/package/#{zkg[:install_path]}") end
      action :run
      notifies :run, 'execute[deploy_zeek]', :delayed
    end

  end
    
end


node[:nsm][:zeek][:zkg][:local_package].each do |local_zkg_name, local_zkg|
  
  if local_zkg[:install] == true

    package local_zkg[:apt_deps]

    local_zkg_path = "/opt/zeek/share/zeek/site/#{local_zkg[:name]}"

    directory local_zkg_path do
      owner 'zeek'
      group 'zeek'
      mode '0750'
      action :create
    end

    if local_zkg[:load_template]
      template "#{local_zkg_path}/__load__.zeek" do
        source "zeek/local_packages/__load__.zeek.erb"
        owner 'zeek'
        group 'zeek'
        mode '0640'
        variables ({
          :local_zkg => local_zkg
        })
        notifies :run, 'execute[deploy_zeek]', :delayed
      end
    else
      template "#{local_zkg_path}/__load__.zeek" do
        source "zeek/local_packages/#{local_zkg[:name]}/__load__.zeek.erb"
        owner 'zeek'
        group 'zeek'
        mode '0640'
        variables ({
          :local_zkg => local_zkg
        })
        notifies :run, 'execute[deploy_zeek]', :delayed
      end
    end

    if local_zkg[:script_templates]
      local_zkg[:script_templates].each do |script_template|

        template "#{local_zkg_path}/#{script_template}" do
          source "zeek/local_packages/#{local_zkg[:name]}/#{script_template}.erb"
          owner 'zeek'
          group 'zeek'
          mode '0640'
          variables ({
            :local_zkg => local_zkg
          })
          notifies :run, 'execute[deploy_zeek]', :delayed
        end

      end
    end
  end
end

execute 'deploy_zeek' do
  command "/opt/zeek/bin/zeekctl deploy"
  user 'zeek'
  action :nothing
end
