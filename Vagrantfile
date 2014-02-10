# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "puppet-precise-virtualbox"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  config.vm.synced_folder "./scripts", "/home/vagrant/scripts"
  config.vm.synced_folder "./data", "/home/vagrant/data"
  config.vm.synced_folder "./requests", "/home/vagrant/requests"
  config.vm.synced_folder ".", "/usr/src/elasticsearch-talk"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.hostname = "esdemo.local"

  config.vm.provider :virtualbox do |v, override|
    override.vm.network :private_network, ip: "192.168.80.100"
    v.customize ["modifyvm", :id, "--memory", 1536]
  end

  config.vm.provision :shell, :path => "shell/initial-setup.sh"
  config.vm.provision :shell, :path => "shell/update-puppet.sh"
  config.vm.provision :shell, :path => "shell/librarian-puppet-vagrant.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
    puppet.facter = {
      "productname" => "Vagrant"
    }
    puppet.options = "--verbose --debug"
  end
end
