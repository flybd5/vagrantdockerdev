#!/bin/bash
# Nomad client config
# Nomad is installed as "nomad" service

sudo mkdir /etc/nomad.d
sudo mkdir /var/lib/docker/data/nomad
sudo mkdir /var/lib/docker/data/nomad/client
sudo cat > /etc/nomad.d/nomadclient.hcl <<EOF
consul {
  address = "192.168.50.12:8500"
}
EOF
sudo cat > /etc/systemd/system/nomad.service <<EOF
Description=Nomad Client
Documentation=https://www.nomadproject.io
[Service]
ExecStart=/usr/local/bin/nomad agent -client -dc="dc1" -config=/etc/nomad.d/nomadclient.hcl -data-dir=/var/lib/docker/data/nomad/client -servers=[192.168.50.11:4647] 
ExecStop=/bin/kill -HUP $MAINPID
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start nomad.service
sudo systemctl enable nomad.service
