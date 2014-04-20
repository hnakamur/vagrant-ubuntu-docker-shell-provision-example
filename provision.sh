#!/bin/bash
private_ip=$1
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo docker.io build -t hnakamur/redis /vagrant/redis
sudo docker.io build -t hnakamur/ngx_mruby /vagrant/ngx_mruby
sudo docker.io run -d -p 6379:6379 --name redis hnakamur/redis
sudo docker.io run -d -p 80:80 --link redis:redis hnakamur/ngx_mruby
sudo iptables -A FORWARD -d $private_ip/32 ! -i docker0 -o docker0 -p tcp -m tcp --dport 80 -j ACCEPT
