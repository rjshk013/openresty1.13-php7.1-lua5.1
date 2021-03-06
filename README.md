# openresty1.13-php7.1-lua5.1

Openresty full setup on ubuntu 18.04 for quick setup
--------------------------------------------------------------------

1.Install cassandra driver for php & dependencies 

ubuntu 18.04 

a.Install php 7.1 

sudo apt-get update 
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php7.1

Php will automatically install apache also.so stop the service before openresty installation 

b.install dependencies for php cassandra driver 

sudo apt-get install -y g++ git make cmake clang libssl-dev libgmp-dev php7.1-cgi php7.1-fpm  php7.1-dev openssl libpcre3-dev

c.Download cassandra drivers and libuv dependencies 

reference :https://github.com/datastax/cpp-driver

main link : https://downloads.datastax.com/cpp-driver/ubuntu/

wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.23.0/libuv1-dev_1.23.0-1_amd64.deb

wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/dependencies/libuv/v1.23.0/libuv1_1.23.0-1_amd64.deb

wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.10.0/cassandra-cpp-driver-dev_2.10.0-1_amd64.deb

wget http://downloads.datastax.com/cpp-driver/ubuntu/18.04/cassandra/v2.10.0/cassandra-cpp-driver_2.10.0-1_amd64.deb

d.install the downloaded 4 packages

 sudo dpkg -i libuv1_1.23.0-1_amd64.deb libuv1-dev_1.23.0-1_amd64.deb                                                                                         cassandra-cpp-driver_2.10.0-1_amd64.deb cassandra-cpp-driver-dev_2.10.0-1_amd64.deb

e.Install for build php driver  & extension

reference : https://docs.datastax.com/en/developer/php-driver/1.3/building/
git clone https://github.com/datastax/php-driver.git
 cd php-driver/ext
phpize
./configure
 sudo make
sudo make install


to confirm extension is loaded go to cd /usr/lib/php/20131226/ and you can see cassandra.so

ADD extension=cassandra.so at the end of the file  

Open nano editor --> press  Ctrl+W, Ctrl+V to get the last line of the file 

1./etc/php/7.1/cli/php.ini
2./etc/php/7.1/fpm/php.ini at the end of the file and save .

check cassandra module status:

php -i | grep -A 10 "^cassandra$"  or 

php -m

Install openresty 1.15 from source 
-------------------------------------------------------

reference : https://www.digitalocean.com/community/tutorials/how-to-use-the-openresty-web-framework-for-nginx-on-ubuntu-16-04

Install necessary packages for openresty
-----------------------------------------

sudo apt-get install build-essential unzip

sudo apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl

sudo apt install -y zlib1g-dev zlib1g
-----------------------------------------

wget https://openresty.org/download/openresty-1.13.6.2.tar.gz 

tar -xvf openresty-1.13.6.2.tar.gz

cd openresty-1.13.6.2/

./configure -j2

make -j2
sudo make install
----------------------------------
start openresty service 
------------------------
Note:Since php7.1 will install apache2,you can see apache2 is already running on port 80.It is better to stop the apache2 service and completely uninstall before starting openresty.

sudo service apache2 stop
whereis apache2
sudo rm -rf /usr/sbin/apache2 /usr/lib/apache2 /etc/apache2 /usr/share/apache2 /usr/share/man/man8/apache2.8.gz

start openresty:
sudo /usr/local/openresty/bin/openresty


stop the OpenResty server:
sudo /usr/local/openresty/bin/openresty -s quit

sudo nano /etc/systemd/system/openresty.service

and add below contents to the file 

# Stop dance for OpenResty
# A modification of the Nginx systemd script
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the Nginx process.
# If, after 5s (--retry QUIT/5) OpenResty is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if OpenResty is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# Nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A dynamic web platform based on Nginx and LuaJIT.
After=network.target

[Service]
Type=forking
PIDFile=/usr/local/openresty/nginx/logs/nginx.pid
ExecStartPre=/usr/local/openresty/bin/openresty -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/local/openresty/bin/openresty -g 'daemon on; master_process on;'
ExecReload=/usr/local/openresty/bin/openresty -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /usr/local/openresty/nginx/logs/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target


Install lua version 5.1 only
---------------------------------------

reference : https://github.com/luarocks/luarocks/wiki/installation-instructions-for-unix

sudo apt install -y build-essential libreadline-dev unzip curl
curl -R -O http://www.lua.org/ftp/lua-5.1.5.tar.gz
tar -zxf lua-5.1.5.tar.gz
cd lua-5.1.5
make linux test
sudo make install
------------------------------------------------
Install luarocks
---------------------------------------------------
wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
tar zxpf luarocks-3.3.1.tar.gz
cd luarocks-3.3.1
./configure --with-lua-include=/usr/local/include


make

sudo make install
-----------------------------------------------------

Install lua-cassandra module 
-----------------------------------

This command must run on the home directory ,note within luarocks 

sudo luarocks install lua-cassandra


additional changes & files added 
1.replaced default nginx.conf file from our custom one and edited username as ubuntu
2.copied cassandra_manager.lua,servers.lua from our local /usr/local/openresty/lualib folder(It is recommended to copy entire lualib folder ,lua folder from the local system)
Bydefaulut there will be no lua folder,need to be created only lualib & luajit folder is generated.We have to replace the default lualib folder with our custom one (location : /usr/local/openresty) 
Note:If you forget to put luafolder & lualib ,application will not work

3.created sites.d folder under nginx folder and created custom file named rajeshlocal.download (custom file ,only changed the location of public folder from fastcgi_param SCRIPT_FILENAME,root  )

4.Found latest openrsty version is giving error.so installed openresty-1.13.6.2.tar.gz 15 & 17 not compatible
Start fpm & openresty 
---------------------
sudo service php7.1-fpm restart
sudo systemctl start openresty
sudo systemctl status openresty
check they are running properly:

Installation setup
------------------
php7.1
Lua 5.1.5
luarocks-3.3.1
openresty-1.13.6.2/build/nginx-1.13.6
luajit-2.1.0-beta3
php cassandra driver: php-driver/1.3
cassandra driver : v2.10.0
libuv1-dev_1.23.0-1
