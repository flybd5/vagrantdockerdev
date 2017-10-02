#!/bin/bash
# Nomad combo server/client config script
# Nomad is installed as "nomad" service in dev mode, both client *and* server

sudo mkdir /etc/nomad.d
sudo mkdir /var/lib/docker/data/nomad
sudo mkdir /var/lib/docker/data/nomad/server
sudo mkdir /var/lib/docker/data/nomad/client
sudo cat > /etc/systemd/system/nomad.service <<EOF
Description=Nomad Server
Documentation=https://www.nomadproject.io
[Service]
ExecStart=/usr/local/bin/nomad agent -dev -dc="dc1" -servers=["192.168.50.11:4646"] -bind="192.168.50.11" -data-dir=/var/lib/docker/data/nomad/server
ExecStop=/bin/kill -HUP $MAINPID
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start nomad.service
sudo systemctl enable nomad.service
