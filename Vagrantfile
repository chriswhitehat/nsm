# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  # config.vm.box_download_insecure = true
  

  config.vm.define "nsmmanager" do |nsmmanager|
    nsmmanager.vm.box = "bento/ubuntu-20.04"
    nsmmanager.vm.hostname = "nsmmanager"
    nsmmanager.vm.network :private_network, ip: "192.168.50.10", virtualbox__intnet: "vagrant_network"
    config.vm.provider :virtualbox do |vb|
      vb.linked_clone = true
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ['modifyvm', :id, '--natnet1', '192.168.222.0/24']
      vb.customize ['modifyvm', :id, "--natdnshostresolver1", "off"]
    end

    nsmmanager.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      chef.install = false
      chef.arguments = "--chef-license accept"
      chef.cookbooks_path = ".."
      chef.data_bags_path = ".."
      chef.nodes_path = "../.."
      chef.roles_path = "../.."

      # Add a recipe
      chef.add_recipe "nsm::manager"

    end

  end

  config.vm.define "nsmsensor" do |nsmsensor|
    nsmsensor.vm.box = "bento/ubuntu-20.04"
    nsmsensor.vm.hostname = "nsmsensor"
    nsmsensor.vm.network :private_network, ip: "192.168.50.11", virtualbox__intnet: "vagrant_network"
    nsmsensor.vm.network :private_network, ip: '1.1.1.1', auto_network: true
    config.vm.provider :virtualbox do |vb|
      vb.linked_clone = true
      vb.cpus = 4
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ['modifyvm', :id, '--natnet1', '192.168.222.0/24']
      vb.customize ['modifyvm', :id, "--natdnshostresolver1", "off"]
    end

    nsmsensor.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      # chef.install = false
      chef.version = '16.13.16'
      chef.arguments = "--chef-license accept"
      chef.cookbooks_path = ".."
      chef.data_bags_path = ".."
      chef.nodes_path = "../.."
      chef.roles_path = "../.."

      # Add a recipe
      chef.add_recipe "nsm::nsmsensor"
      chef.add_recipe "vagrant"


    end

  end
end
