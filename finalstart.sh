#!/bin/bash
sudo cp -rf ~/Downloads/public.zip /home/cordchat/
#edit the location of files accordingly
cd /home/cordchat/
sudo unzip public.zip
sudo cp -rf /usr/local/openresty/nginx/conf/nginx.conf nginx.conforg
sudo rm -rf /usr/local/openresty/nginx/conf/nginx.conf
sudo cp -rf ~/Downloads/nginx.conf /usr/local/openresty/nginx/conf
cd /usr/local/openresty/nginx/
sudo mkdir sites.d
sudo cp -rf ~/Downloads/rajeshcordiant.download /usr/local/openresty/nginx/sites.d/
sudo cp -rf ~/Downloads/lua.zip /usr/local/openresty/
cd /usr/local/openresty/
sudo unzip lua.zip
sudo cp -rf ~/Downloads/cassandra_manager.lua /usr/local/openresty/lualib/
sudo cp -rf ~/Downloads/servers.lua /usr/local/openresty/lualib/
sudo service php7.1-fpm restart
sudo systemctl restart openresty

