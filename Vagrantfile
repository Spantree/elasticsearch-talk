# -*- mode: ruby -*-
# vi: set ft=ruby :

PUPPET_OPTIONS = [
  "--verbose",
  "--debug",
  "--modulepath=/etc/puppet/modules:/usr/src/elasticsearch-talk/puppet/modules"
]

PUPPET_FACTS = {
  "vm_type" => "vagrant",
  "enable_marvel_agent" => true,
  "ssh_username" => "vagrant"
}

DO_REINDEX = ENV['DO_REINDEX']
CLUSTER = ENV['CLUSTER']
HOST_HOME_DIR = ENV['HOME']

if CLUSTER == 'true'
  ES1_FACTS = PUPPET_FACTS
  ES2_FACTS = PUPPET_FACTS.merge({
    :do_reindex => ENV['DO_REINDEX']
  })
else
  ES1_FACTS = PUPPET_FACTS.merge({
    :do_reindex => ENV['DO_REINDEX']
  })
end

Vagrant.configure("2") do |config|
  # For regular use
  config.vm.box = "spantree/elasticsearch-talk"
  config.vm.box_version = "1.0.4"
  
  # For testing "from scratch" provisioning
  # config.vm.box = "hashicorp/precise64"
  
  # For testing local Packer builds
  # config.vm.box = "elasticsearch-talk"
  # config.vm.box_url = "file:///#{HOST_HOME_DIR}/src/spantree/elasticsearch-talk/elasticsearch-talk-trusty64-1.0.2-virtualbox.box"

  # Use this if connecting locally from the Spantree network
  # config.vm.box_url = "http://10.0.1.54/estalk-precise-vbox-x86_64.box"

  # Use this if connecting from the outside internet
  # config.vm.box_url = "http://spantree-vagrant.s3.amazonaws.com/estalk-precise-vbox-x86_64.box"

  # config.vm.box_url = "http://spantree-vagrant.s3.amazonaws.com/estalk-precise-vbox-x86_64.box"

  config.vm.synced_folder ".", "/usr/src/elasticsearch-talk", :create => "true"
  config.vm.synced_folder "visualizations", "/var/www/visualizations", :create => "true"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.provision :shell, :path => "shell/initial-setup.sh"
  config.vm.provision :shell, :path => "shell/update-ruby.sh"
  config.vm.provision :shell, :path => "shell/update-puppet.sh"
  config.vm.provision :shell, :path => "shell/librarian-puppet-vagrant.sh"

  # This first node only has Elasticsearch installed.
  config.vm.define "es1" do |es1|
    es1.vm.hostname = "es1.local"
    
    es1.vm.provider :virtualbox do |v, override|
      override.vm.network :private_network, ip: "192.168.80.100"
      v.customize ["modifyvm", :id, "--memory", 1536]
    end

    es1.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.options = PUPPET_OPTIONS
      puppet.facter = ES1_FACTS
    end
  end

  if CLUSTER == 'true'  
    # The second node has Elasticsearch and our presentation assets.
    # It also does bulk indexing of sample data (distributed to the cluster).
    config.vm.define "es2" do |es2|
      es2.vm.hostname = "es2.local"
      es2.hostmanager.aliases = %w(esdemo.local)
      es2.vm.provider :virtualbox do |v, override|
        override.vm.network :private_network, ip: "192.168.80.101"
        v.customize ["modifyvm", :id, "--memory", 1536]
      end

      es2.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.options = PUPPET_OPTIONS
        puppet.facter = ES2_FACTS
      end
    end
  end
end
