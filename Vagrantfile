# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # config.vm.box = "estalk-precise-vbox"
  config.vm.box = "trusty64"

  # Use this if connecting locally from the Spantree network
  # config.vm.box_url = "http://10.0.1.54/estalk-precise-vbox-x86_64.box"

  # Use this if connecting from the outside internet
  # config.vm.box_url = "http://spantree-vagrant.s3.amazonaws.com/estalk-precise-vbox-x86_64.box"

  config.vm.box_url = "http://spantree-vagrant.s3.amazonaws.com/estalk-precise-vbox-x86_64.box"

  config.vm.synced_folder ".", "/usr/src/elasticsearch-talk", :create => "true"
  config.vm.synced_folder "visualizations", "/var/www/visualizations", :create => "true"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.hostname = "esdemo.local"

  config.vm.provider :virtualbox do |v, override|
    override.vm.network :private_network, ip: "192.168.80.100"
    v.customize ["modifyvm", :id, "--memory", 4096]
  end

  config.vm.provision :shell, :path => "shell/initial-setup.sh"
  config.vm.provision :shell, :path => "shell/update-puppet.sh"
  config.vm.provision :shell, :path => "shell/librarian-puppet-vagrant.sh"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.options = [
      "--verbose",
      "--debug",
      "--modulepath=/etc/puppet/modules:/usr/src/elasticsearch-talk/puppet/modules"
    ]
    puppet.facter = {
      "host_environment" => "Vagrant",
      "vm_type" => "vagrant",
      "enable_marvel_agent" => false
    }
  end
end
