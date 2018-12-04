# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Use a ubuntu 16.04 box
  config.vm.box = "ubuntu/xenial64"
  # Forward the host 8080 port to the VMs 80 port
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.provision "shell", inline: <<-SHELL
    export RANDOMLY_ENV=dev
    /vagrant/bootstrap/startup.sh
 SHELL
end
