#!/bin/bash
echo ECS_CLUSTER=${ECS_ENV} > /etc/ecs/ecs.config
yum update -y
yum install -y jq nfs-utils python27 python27-pip awscli
pip install --upgrade awscli
DIR_TGT="/data"
mkdir $DIR_TGT
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,soft,timeo=600,retrans=2 "${EFS_DNS}:/" "$DIR_TGT"
cp -p "/etc/fstab" "/etc/fstab.back-$(date +%F)"
echo -e "${EFS_DNS}:/ \t\t $DIR_TGT \t\t nfs \t\t nfsvers=4.1,rsize=1048576,wsize=1048576,soft,timeo=600,retrans=2 \t\t 0 \t\t 0" | tee -a /etc/fstab
stop ecs
/etc/init.d/docker restart
start ecs

# Set hostname
## Generating a random in 1000-9999 range to compose hostname (Zabbix needed)
NUM=$(echo $(( RANDOM % (9999 - 1000 + 1 ) + 1000 )))

HNAME="${ECS_ENV}_$NUM"
echo "$HNAME" > /etc/hostname
sed -i "s/localhost.localdomain/$HNAME/g" /etc/sysconfig/network
hostname $HNAME

# Zabbix install
yum install wget gcc pcre-devel -y
wget https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.12/zabbix-3.4.12.tar.gz
tar xzvf zabbix-3.4.12.tar.gz
groupadd --system zabbix
useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix
mkdir -m u=rwx,g=rwx,o= -p /usr/lib/zabbix
chown zabbix:zabbix /usr/lib/zabbix
cd zabbix-3.4.12
./configure --enable-agent
make install
mkdir /var/log/zabbix/ && chown zabbix:zabbix /var/log/zabbix/
cat > /usr/local/etc/zabbix_agentd.conf <<EOF
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
DebugLevel=3
ListenPort=10050
Server=monitoramento.estabil.is
ServerActive=monitoramento.estabil.is
StartAgents=2
BufferSend=20
Timeout=30
Include=/usr/local/etc/zabbix_agentd.conf.d
EOF
# Start agent
/usr/local/sbin/zabbix_agentd

# Instalando o cAdvisor
docker run \
--volume=/:/rootfs:ro \
--volume=/var/run:/var/run:rw \
--volume=/sys:/sys:ro \
--volume=/var/lib/docker/:/var/lib/docker:ro \
--volume=/dev/disk/:/dev/disk:ro \
--volume=/cgroup:/sys/fs/cgroup:ro \
--publish=8989:8080 \
--detach=true \
--name=cadvisor \
google/cadvisor:latest

# Netdata install
bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait

#### Instalando node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz
tar xvzf node_exporter-0.16.0.linux-amd64.tar.gz
cp node_exporter-0.16.0.linux-amd64/node_exporter /usr/local/bin
useradd node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Start Node export
/usr/local/bin/node_exporter
