# -*- mode: ruby -*-
# vi: set ft=ruby :

PRIVATE_IP = ENV["PRIVATE_IP"] || "192.168.33.13"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu14.04"
  config.vm.network :private_network, ip: PRIVATE_IP
  config.vm.provision "shell", path: "provision.sh", args: PRIVATE_IP
end
