#!/bin/bash
# Consul Agent 1 config
# Consul is installed as "consul" service

sudo useradd consul
sudo mkdir /var/lib/docker/data/consul
sudo chown consul:consul /var/lib/docker/data/consul
sudo cat > /etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul
Documentation=https://www.consul.io/
[Service]
ExecStart=/usr/local/bin/consul agent -server -data-dir="/var/lib/docker/data/consul" -encrypt="bDhos7P0U+P4Vy3PrB0QNA==" -node=node3 -bind=192.168.50.13 -client=192.168.50.13 -retry-join "192.168.50.11"
ExecStop=/bin/kill -HUP $MAINPID
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start consul.service
sudo systemctl enable consul.service
