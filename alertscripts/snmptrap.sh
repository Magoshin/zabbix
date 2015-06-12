#!/bin/bash

# CONFIGURATION
ZABBIX_SERVER="127.0.0.1";
ZABBIX_PORT="10051";
ZABBIX_SENDER="/usr/bin/zabbix_sender";

DEBUG_MODE=0

# SnmpTrap Parameter
str="0"

read hostname

read org_ip
ipaddress=`echo ${org_ip} | cut -f2 -d'[' | cut -f1 -d']'`

hostname=`/usr/bin/mysql -N -s --user=root zabbix -e "SELECT distinct host FROM hosts,interface WHERE hosts.hostid = interface.hostid AND ip = '${ipaddress}'"`

read uptime
uptime=`echo ${uptime} | cut -f2 -d' '`

read org_oid
oid=`echo ${org_oid} | cut -f2 -d' '`

if [ ${DEBUG_MODE} = 1 ];then
    echo `date `"IP=$ipaddress" >> /var/log/snmptrapd.log
    echo `date `"HOST=$hostname" >> /var/log/snmptrapd.log
    echo `date `"OID=$oid" >> /var/log/snmptrapd.log
    echo `date `"ORG_OID=$org_ip" >> /var/log/snmptrapd.log
fi

i=0
varbind_arrray=()

while read now_value
do
    varbind_arrray[$i]=`echo ${now_value} | cut -d" " -f2-`
    let ++i

    if [ ${DEBUG_MODE} = 1 ];then
        echo `date `" varbind_arrray["$i"]="$varbind_arrray[$i] >> /var/log/snmptrapd.log
    fi
done

BACKUPIFS=$IFS
IFS=$'\n'

# それぞれの要素は2つまでにしかならない為、最初の_で区切り処理を行う
ip_replace_num=`expr $i - 2`
j=1
for data in ${varbind_arrray[@]}
do
    realdata=`echo $data`

    if [ ${DEBUG_MODE} = 1 ];then
        echo `date `" data="$data >> /var/log/snmptrapd.log
        echo `date `" oid="$oid >> /var/log/snmptrapd.log
        echo `date `" j="$j $community_num >> /var/log/snmptrapd.log
        echo `date `" realdata="$realdata >> /var/log/snmptrapd.log
    fi

    str=${str}","`echo "varbind"$j"="$realdata`
    let ++j
done

realstr=`echo ${str} | sed -e 's/_*$//g' -e 's/^0,//g'`

if [ ${realstr} = '' ];then
    realstr="0"
fi

# それぞれの要素は2つまでにしかならない為、最初の_で区切り処理を行う

HOST=`echo ${hostname}`
KEY=`snmptranslate -On ${oid}`
if [ ${DEBUG_MODE} = 1 ];then
    echo `date `" HOST="${HOST} >> /var/log/snmptrapd.log
    echo `date `" KEY="${KEY} >> /var/log/snmptrapd.log
    echo `date `"$ZABBIX_SENDER -z $ZABBIX_SERVER -p $ZABBIX_PORT -s $HOST -k $KEY -o $realstr" >> /var/log/snmptrapd.log
fi

# Output
$ZABBIX_SENDER -z $ZABBIX_SERVER -p $ZABBIX_PORT -s $HOST -k $KEY -o $realstr
