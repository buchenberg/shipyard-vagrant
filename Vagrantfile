# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Require a recent version of vagrant otherwise some have reported errors setting host names on boxes
Vagrant.require_version ">= 1.6.2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The number of minions to provision
  num_minion = 1

  # ip configuration
  master_ip = "10.245.1.2"
  minion_ip_base = "10.245.1."
  minion_ip_test = "10.245.1.10"
  minion_ips = num_minion.times.collect { |n| minion_ip_base + "#{n+2}" }
  minion_ips_str = minion_ips.join(",")

  # Docker hosts
  num_minion.times do |n|
    config.vm.define "docker1" do |minion|
      minion_index = n+1
      minion_ip = minion_ips[n]
      minion.vm.provider "virtualbox" do |vb|
        vb.name = "docker1"
        vb.memory = "512"
      end
      minion.vm.box = "ubuntu/trusty64"
      minion.vm.network "private_network", ip: "#{minion_ip_test}"
      minion.vm.hostname = "docker1"
      minion.vm.provision "docker", type: "shell", path: "provision_docker.sh"
      #minion.vm.provision "Host Provisions", type: "shell", path: "provision_hosts.sh"
    end
  end

  # Shipyard server
  config.vm.define "shipyard" do |shipyard|
    shipyard.vm.provider "virtualbox" do |vb|
      vb.name = "shipyard"
      vb.memory = "512"
    end
    shipyard.vm.box = "ubuntu/trusty64"
    shipyard.vm.network "private_network", ip: "#{master_ip}"
    shipyard.vm.network "forwarded_port", guest: 8080, host: 8181, auto_correct: true
    shipyard.vm.hostname = "shipyard"
    shipyard.vm.provision "docker", type: "shell", path: "provision_docker.sh"
    shipyard.vm.provision "shell", path: "provision_shipyard.sh"
  end
end
