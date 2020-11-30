#!/bin/bash
sudo apt install -y build-essential libreadline-dev unzip curl
curl -R -O http://www.lua.org/ftp/lua-5.1.5.tar.gz
tar -zxf lua-5.1.5.tar.gz
cd lua-5.1.5
make linux test
sudo make install
cd ~
wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
tar zxpf luarocks-3.3.1.tar.gz
cd luarocks-3.3.1
./configure --with-lua-include=/usr/local/include
make
sudo make install
cd ~
sudo luarocks install lua-cassandra

