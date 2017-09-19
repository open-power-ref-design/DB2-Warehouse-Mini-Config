#!/bin/bash

Logical_drive =$1

systemctl stop docker
rm -fr /var/lib/docker/*

lvremove dockervg/thinpool
lvremove dockervg/thinpoolmeta
vgremove dockervg
pvremove $Logical_drive

pvcreate $Logical_drive
vgcreate dockervg $Logical_drive
lvcreate --wipesignatures y -n thinpool dockervg -l 20%VG
lvcreate --wipesignatures y -n thinpoolmeta dockervg -l 1%VG
lvconvert -y --zero n -c 512K --thinpool dockervg/thinpool --poolmetadata dockervg/thinpoolmeta

mkdir /etc/lvm/profile
cat << EOF > /etc/lvm/profile/dockervg-thinpool.profile
activation {
thin_pool_autoextend_threshold=80
thin_pool_autoextend_percent=20
}
EOF

lvchange --metadataprofile dockervg-thinpool dockervg/thinpool
lvs -o+seg_monitor

mkdir /etc/systemd/system/docker.service.d/
cat << EOF > /etc/systemd/system/docker.service.d/docker.conf
[Service] 
ExecStart=
ExecStart=/usr/bin/dockerd --storage-driver=devicemapper \
--storage-opt=dm.thinpooldev=/dev/mapper/dockervg-thinpool \
--storage-opt dm.use_deferred_deletion=true \
--storage-opt dm.use_deferred_removal=true \
-H 0.0.0.0:5864  \
-H unix:///var/run/docker.sock
EOF

systemctl daemon-reload
systemctl start docker

#    docker swarm join \
#    --token SWMTKN-1-455kh80jfgsqcz74g47bkbuwe4n34dlqx5ri7qkss7yq7usmqm-e6zp5r52w2m46no3bed0i1un8 \
#    11.11.1.7:2377
