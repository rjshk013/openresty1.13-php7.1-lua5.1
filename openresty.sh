#!/bin/bash
sudo apt-get install -y build-essential unzip
sudo apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl

sudo apt install -y zlib1g-dev zlib1g
wget https://openresty.org/download/openresty-1.13.6.2.tar.gz 
tar -xvf openresty-1.13.6.2.tar.gz

cd openresty-1.13.6.2/
./configure -j2

make -j2
sudo make install
sudo service apache2 stop

sudo rm -rf /usr/sbin/apache2 /usr/lib/apache2 /etc/apache2 /usr/share/apache2 /usr/share/man/man8/apache2.8.gz

