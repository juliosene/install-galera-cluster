# install-galera-cluster
Debian or Ubuntu install script for MariaDB Galera Cluster

## 1 - Copy install-galera.sh script and execute it.
(logged as root)
```
# wget https://github.com/juliosene/install-galera-cluster/raw/master/install-galera.sh
# chmod 744 install-galera.sh
# ./install-galera.sh
```

## 2 - Change configuration files
```
# nano /etc/mysql/conf.d/cluster.cnf
```
edit line 

\# wsrep_cluster_address="gcomm://node1_ip,node2_ip,node3_ip"

remove the comment mark (\#) and replace node1_ip, node2_ip, node3_ip with the nodes IP addresses. If you have more nodes add separated by comma.
save and exit (<CTRL+x> yes) 
(Do it for all nodes)

## 3 - Adjust servers permission
copy /etc/mysql/debian.cnf from node1 to the same place in other nodes. (you can just edit and copy the same passwords to all nodes)

## 4 - Stops database service in all nodes
```
# service mysql stop
```
(Do it for all nodes)

## 5 - Starts the first node
```
# service mysql start --wsrep-new-cluster
```

## 6 - Starts other nodes
```
# service mysql start
```
(do it for all nodes, except the first one)

## 7 - Test
```
# mysql -u root -e 'SELECT VARIABLE_VALUE as "cluster size" FROM INFORMATION_SCHEMA.GLOBAL_STATUS WHERE VARIABLE_NAME="wsrep_cluster_size"'
```
Output will be like this:
```
+--------------+
| cluster size |
+--------------+
| 3            |
+--------------+
```

(shows the number of nodes connected to the cluster)

## Atention:
Verify if your security rules, like Network security group, in open for this ports:
```
MySQL                   YourSubnet  Any   TCP/3306    Allow
GaleraClusterRep        YourSubnet  Any   Any/4567    Allow
StateSnapshotTransfer   YourSubnet  Any   TCP/4444    Allow
```

(GaleraClusterRep rule needs to be oppened to TCP and UDP transfers!)

