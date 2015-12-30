#!/bin/bash
# Install MariaDB Galera Cluster
cd ~
apt-get update
apt-get -fy dist-upgrade
apt-get -fy upgrade
apt-get install lsb-release bc
REL=`lsb_release -sc`
DISTRO=`lsb_release -is | tr [:upper:] [:lower:]`
NCORES=` cat /proc/cpuinfo | grep cores | wc -l`
WORKER=`bc -l <<< "4*$NCORES"`

apt-get install python-software-properties
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
add-apt-repository "deb http://mirror.edatel.net.co/mariadb/repo/5.5/$DISTRO $REL main"

apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y rsync galera mariadb-galera-server
