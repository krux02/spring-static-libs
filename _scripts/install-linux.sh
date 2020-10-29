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
  VER="10"
else
  VER="9"
fi

apt install -y gcc-$VER g++-$VER

apt -y autoremove

update-alternatives \
--install /usr/bin/gcc gcc /usr/bin/gcc-$VER 60 \
--slave /usr/bin/g++ g++ /usr/bin/g++-$VER \
--slave /usr/bin/gcov gcov /usr/bin/gcov-$VER \
--slave /usr/bin/gcov-tool gcov-tool /usr/bin/gcov-tool-$VER \
--slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-$VER \
--slave /usr/bin/gcc-nm gcc-nm /usr/bin/gcc-nm-$VER \
--slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-$VER

update-alternatives \
--install /usr/bin/c++ c++ /usr/bin/gcc-$VER 60

sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list
apt update
