# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "magento"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network :private_network, ip: "192.168.50.4"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 3306, host: 3306

  # Make it so that network access from the vagrant guest is able to
  # use SSH private keys that are present on the host without copying
  # them into the VM.
  config.ssh.forward_agent = true

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  config.vm.synced_folder ".", "/vagrant", nfs: nfs_setting

  config.vm.provider :virtualbox do |vb|
    # Give the VM 4GB of RAM instead of the default 348MB.
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # This setting makes it so that network access from inside the vagrant
    # guest is able to resolve DNS using the hosts VPN connection.
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "git"
    chef.add_recipe "curl"
    chef.add_recipe "apache2"
    chef.add_recipe "mysql"
    chef.add_recipe "php"
  end

  # config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "base.pp"
  # end

end
