#!/bin/bash
# Consul server config script
# Consul is installed as "consul" SERVER service, the web interface will respond to any IP

sudo useradd consul
sudo mkdir /etc/consul.d
sudo mkdir /var/lib/docker/data/consul
sudo chown consul:consul /var/lib/docker/data/consul
sudo cat > /etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul
Documentation=https://www.consul.io/
[Service]
ExecStart=/usr/local/bin/consul agent -server -ui -bootstrap-expect=1 -data-dir="/var/lib/docker/data/consul" -encrypt="bDhos7P0U+P4Vy3PrB0QNA==" -node=node1 -bind=192.168.50.11 -client=192.168.50.11 -config-dir=/etc/consul.d/
ExecStop=/bin/kill -HUP $MAINPID
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
sudo cat > /etc/consul.d/ui.json <<EOF
{
  "addresses": {
    "http": "0.0.0.0"
  }
}
EOF
sudo systemctl daemon-reload
sudo systemctl start consul.service
sudo systemctl enable consul.service
