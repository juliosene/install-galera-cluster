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

echo -e '[mysqld]
#mysql settings
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
query_cache_size=0
query_cache_type=0
bind-address=0.0.0.0
#galera settings
wsrep_provider=/usr/lib/galera/libgalera_smm.so
wsrep_cluster_name="my_wsrep_cluster"
# wsrep_cluster_address="gcomm://node1_ip,node2_ip,node3_ip"
wsrep_sst_method=rsync' > /etc/mysql/conf.d/cluster.cnf
