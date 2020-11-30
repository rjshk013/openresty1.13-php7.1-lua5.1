

#!/bin/bash
sudo apt-get update 
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.1
sudo apt-get install -y g++ git make cmake clang libssl-dev libgmp-dev php7.1-cgi php7.1-fpm  php7.1-dev openssl libpcre3-dev
wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.23.0/libuv1-dev_1.23.0-1_amd64.deb
wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.23.0/libuv1_1.23.0-1_amd64.deb
wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.10.0/cassandra-cpp-driver-dev_2.10.0-1_amd64.deb
wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.10.0/cassandra-cpp-driver_2.10.0-1_amd64.deb
sudo dpkg -i libuv1_1.23.0-1_amd64.deb libuv1-dev_1.23.0-1_amd64.deb  cassandra-cpp-driver_2.10.0-1_amd64.deb cassandra-cpp-driver-dev_2.10.0-1_amd64.deb 
git clone https://github.com/datastax/php-driver.git
cd php-driver/                                                                                     
cd ext
phpize
./configure
sudo make
sudo make install
cd ~

