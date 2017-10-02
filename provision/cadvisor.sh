#!/bin/bash
# Cadvisor config and run

sudo mkdir /etc/cadvisor.d
sudo cat > /etc/cadvisor.d/cadvisor.nomad <<EOF
job "cadvisor" {
  region = "global"

  datacenters = ["dc1"]

  type = "system"

  group "infra" {
    task "cadvisor" {
      driver = "docker"
      config {
        image = "google/cadvisor"
        port_map {
          cadvisor = 8080
        }
      }
      service {
        port = "cadvisor"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }
      env {
        DEMO_NAME = "devops-challenge"
      }
      resources {
        cpu = 100
        memory = 32
        network {
          mbits = 100
          port "cadvisor" {
          }
        }
      }
    }
  }
}
EOF
# The sleep is necessary to allow Nomad time to finish negotiating the cluster
sleep 10
nomad run -address="http://192.168.50.11:4646" /etc/cadvisor.d/cadvisor.nomad
