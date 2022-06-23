#!/bin/bash
cd $(cd $(dirname $0); pwd)
install(){
sudo apt update -y
sudo apt install lua5.3 -y
sudo apt-get install liblua5.3-dev -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt upgrade -y
sudo apt install zip -y
sudo apt install build-essential checkinstall zlib1g-dev -y
sudo apt install g++-4.7 c++-4.7 -y
sudo apt install gcc-4.9 -y
sudo apt upgrade libstdc++6 -y
sudo apt install libreadline-dev libconfig-dev libssl-dev lua5.3 liblua5.3-dev lua-socket lua-sec lua-expat libevent-dev make unzip git redis-server autoconf g++ libjansson-dev libpython-dev expat libexpat1-dev -y
sudo apt install screen -y
sudo apt install libnotify-dev -y
sudo apt install libconfig++9v5 libstdc++6 -y
sudo apt install libconfig++8-dev -y
sudo apt install lua-lgi -y
sudo apt install build-essential checkinstall zlib1g-dev -y
mkdir tmp
cd tmp
git clone https://github.com/george0884/lua-curl-error && cd lua-curl-error && tar -xzvf curl.tar.gz && sudo cp curl -r /usr/include/ && cd .. && sudo rm -Rf lua-curl-error
sudo  wget https://luarocks.org/releases/luarocks-2.4.3.tar.gz
sudo  tar zxpf luarocks-2.4.3.tar.gz
cd luarocks-2.4.3
./configure && make && sudo make install -y
sudo luarocks install luarocks -y
sudo luarocks install luasec -y
sudo luarocks install luasocket -y
sudo luarocks install redis-lua q-y
sudo luarocks install lua-term -y
sudo luarocks install serpent -y
sudo luarocks install dkjson -y
sudo luarocks install Lua-cURL -y
cd ../..
rm -rf tmp
}
if [ "$1" = "run" ]; then
sudo lua5.3 setup.lua
fi
if [ "$1" = "ins" ]; then
install
cd ..
cd aa
rm -rf luarocks*
screen -S start && sudo lua5.3 setup.lua
fi
