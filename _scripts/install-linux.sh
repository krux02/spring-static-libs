#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh

apt update
apt -y install make cmake p7zip-full ninja-build \
	libxmu-dev libxi-dev \
	libopenal-dev libvorbis-dev \
	libogg-dev libsdl2-dev libfreetype6-dev libfontconfig1-dev \
	freeglut3-dev libgif-dev \
	pwgen \
	autossh \
	libboost-test-dev \
	chrpath \
	wget \
	vim \
	dpkg-dev \
	apt-utils


apt-get install -y build-essential software-properties-common

apt remove -y snapd || true
apt remove -y $(apt list --installed | cut -d'/' -f1 | grep -e "gcc-[0-9]*$")
apt remove -y $(apt list --installed | cut -d'/' -f1 | grep -e "g\+\+-[0-9]*$")

add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt update -y

#apt install -y gcc-snapshot
if (( $UBUNTU_MAJORVER > 16 )); then
  GCC="gcc-10"
  GPP="g++-10"
else
  GCC="gcc-9"
  GPP="g++-9"
fi

apt install -y $GCC $GPP

apt -y autoremove

if [ ! -f /usr/bin/gcc ]; then
  ln -s /usr/bin/$GCC /usr/bin/gcc
fi
if [ ! -f /usr/bin/g++ ]; then
  ln -s /usr/bin/$GPP /usr/bin/g++
fi

sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list
apt update
