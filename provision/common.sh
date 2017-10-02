#!/bin/bash
# Common provisioning script for all nodes

#-----
# Update and upgrade all around.
#-----
      sudo apt-get update
      sudo apt-get upgrade -y
#-----
# Install Docker stable & dependencies
#-----
      sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get update
      sudo apt-get install -y docker-ce unzip
#-----
# Modify the hosts file to make the nodes visible to teach other
#-----
      sudo echo "192.168.50.11 node1" >> /etc/hosts
      sudo echo "192.168.50.12 node2" >> /etc/hosts
      sudo echo "192.168.50.13 node3" >> /etc/hosts
#-----
# Go get the Nomad and Consul install files, unzip and install in /usr/local/bin
#-----
      wget https://releases.hashicorp.com/consul/0.9.3/consul_0.9.3_linux_amd64.zip
      wget https://releases.hashicorp.com/nomad/0.6.0/nomad_0.6.0_linux_amd64.zip
      sudo unzip consul_0.9.3_linux_amd64.zip -d /usr/local/bin
      sudo unzip nomad_0.6.0_linux_amd64.zip -d /usr/local/bin
      sudo rm consul_0.9.3_linux_amd64.zip nomad_0.6.0_linux_amd64.zip
#-----
# Mount the host file systems as persistent storage in /var/lib/docker and /var/lib/docker/data
#-----
      sudo systemctl stop docker
      if ! (sudo mount /dev/sdc /var/lib/docker); then sudo mkfs.ext4 /dev/sdc; sudo mount /dev/sdc /var/lib/docker; fi
      if [ ! -d /var/lib/docker/data ]; then sudo mkdir /var/lib/docker/data; fi
      if ! (sudo mount /dev/sdd /var/lib/docker/data); then sudo mkfs.ext4 /dev/sdd; sudo mount /dev/sdd /var/lib/docker/data; fi
      sudo systemctl start docker
