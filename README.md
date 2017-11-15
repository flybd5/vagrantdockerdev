This project is used to implement an example clustered Docker development environment using Vagrant and Virtualbox. 

This project implements the creation of a monitored local development environment simulating a cluster of Docker hosts with additional configuration to enable persistent storage of the container workload data and cross-host communication among the various Docker containers running on the hosts. It also sets up a container scheduler across the Docker hosts to manage container workloads.

In detail:

- The project assumes Vagrant and Virtualbox are already installed.
- Creates a three-node Vagrant machine cluster based on Ubuntu 16.04
- For each node attaches two new “block devices” (the same devices on all nodes) to create pools of persistent storage across hosts. This is only done if the block devices do not already exist.
- Installs the Docker daemon (17.06.1-ce) across all the nodes
- Sets up a software defined networking layer across the Docker hosts to enable cross-host container communication
- Sets up a persistent storage solution across the Docker hosts to make sure data is never lost in the event of container failures or cross-host rescheduling.
- Sets up a Consul cluster (0.9.2) across the three docker hosts
- Sets up the Nomad container scheduler (0.6.0) across the three docker hosts
- Uses the Nomad scheduler to schedule the Cadvisor container monitor across the Docker hosts

Run the "challenge" script for instructions on how to manage this project.
