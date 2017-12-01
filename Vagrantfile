# -*- mode: ruby -*-
# vi: set ft=ruby :

# -------
# Systems Engineer Challenge
# Juan Jimenez, October 2017
#
# Goals:
#
#   - Done: Install vagrant (1.9.8) and virtualbox (5.1.26) (Assumes already installed)
#   - Done: Create a 3-node vagrant machine cluster based on ubuntu 16.04
#   - Done: For each node make sure you attach 2 new “block devices” as this will be needed for
#     creating pools of persistent storage across hosts
#   - Done: Install the docker daemon (17.06.1-ce) across all the nodes
#   - Done: Setup a software defined networking layer across the docker hosts to enable
#     cross-host container communication
#   - Done: Setup a persistent storage solution across the docker hosts to make sure data is
#     never lost in the event of container failures or cross-host rescheduling.
#   - Done: Setup a consul cluster (0.9.2) across the 3 docker hosts
#   - Done: Setup the Nomad container scheduler (0.6.0) across the 3 docker hosts
#   - Done: Use the Nomad scheduler to schedule the cadvisor container monitor across the docker hosts
# 
# Caveats: This vagrantfile is designed to work with the ubuntu/xenial64 box. If you change the box, there
# are steps that will likely fail! Read carefully before making changes! If you have any questions, ask your
# DevOps team for help. :)
#
# Related shell scripts are in ./provision
# The "challenge" script makes it a bit easier to run this, with no arguments it tells you what it can do.
# -------
Vagrant.configure("2") do |config|
#------
# Spin up three VM's, set hostnames and assign IP's.
#------
(1..3).each do |i|
  config.vm.define "node#{i}" do |node|
    node.vm.box = "ubuntu/xenial64"
    node.vm.hostname = "node#{i}"
    node.vm.network "private_network", ip: "192.168.50.1#{i}"
#-----
# Each VM needs to have two block devices. 1GB local storage each
# for the purpose of this exercise, and attached to the VM's.
#-----
    node.vm.provider "virtualbox" do |vb|
#-----
# If disks don't already exist, create them.
#-----
      unless FileTest.exist?("node#{i}_disk1.vdi")
       vb.customize ['createhd', '--filename', "node#{i}_disk1.vdi", '--variant', 'Fixed', '--size', 1 * 1024]
      end
      unless FileTest.exist?("node#{i}_disk2.vdi")
       vb.customize ['createhd', '--filename', "node#{i}_disk2.vdi", '--variant', 'Fixed', '--size', 1 * 1024]
      end
#-----
# Attach the drives to the SCSI controller.
#-----
# !! NOTE: This step is specific to the ubuntu/xenial64 box.
# !!       If you change the box, these next two commands will likely fail!
# !!       (Extra credit if you can figure out *why* they will likely fail.)
#-----
      vb.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', "node#{i}_disk1.vdi"]
      vb.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', "node#{i}_disk2.vdi"]
    end
#-----
# Do all the common configuration work
#-----
    node.vm.provision "shell", path: "./provision/common.sh"
#-----
# Configure and setup the Consul and Nomad clusters
#-----
    case i
      when 1
        node.vm.provision "shell", path: "./provision/consulserver.sh"
        node.vm.provision "shell", path: "./provision/nomadserver.sh"
      when 2
        node.vm.provision "shell", path: "./provision/consulagent1.sh" 
        node.vm.provision "shell", path: "./provision/nomadclient1.sh"
      when 3
        node.vm.provision "shell", path: "./provision/consulagent2.sh"
        node.vm.provision "shell", path: "./provision/nomadclient2.sh"
    end
#----
# Configure and run cadvisor with Nomad
#----
    node.vm.provision "shell", path: "./provision/cadvisor.sh"
  end
end
end
