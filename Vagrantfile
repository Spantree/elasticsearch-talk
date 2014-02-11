# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-precise12042-x64-vbox43"
  config.vm.box_url = "http://box.puphpet.com/ubuntu-precise12042-x64-vbox43.box"

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
  config.vm.provision :hostmanager
  config.vm.provision :shell, :path => "shell/initial-setup.sh"
  config.vm.provision :shell, :path => "shell/update-puppet.sh"
  config.vm.provision :shell, :path => "shell/librarian-puppet-vagrant.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
    puppet.manifest_file  = "site.pp"
    puppet.facter = { "productname" => "Vagrant"}
    puppet.options = ["--verbose --debug"]
  end


  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 9200, 9200

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.share_folder "scripts", "/home/vagrant/scripts", "./scripts"
  config.vm.share_folder "data", "/home/vagrant/data", "./data"
  config.vm.share_folder "requests", "/home/vagrant/requests", "./requests"
end
