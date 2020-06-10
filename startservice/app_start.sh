#!/bin/bash
#Author : Karthik Venkatraman
set -x
hostname=${host}
cluster_restart () {
    echo "Stopping cluster"
    crm cluster stop
    echo "Start Cluster"
    crm cluster start
    if [ $? != 0 ];then
        echo "Cluster could not be started. Check logs"
        exit 1
    fi
    echo "Status of cluster"
    crm cluster status
}

cluster_maintmode () {
    echo "removing maintenance mode"
    ## Wait for cluster services to start before removing maintenance mode
    sleep 10
    crm configure property maintenance-mode=false
    if [ $? != 0 ];then
        echo "Cluster could not be taken out of maintenance mode. Check logs"
        exit 1
    fi
    ## Wait for cluster resources to start
    echo "Waiting for cluster resoures to start"
    sleep 10
    crm status
    flag=0
    retry=0
    until [ "$retry" -ge 10 ]
    do
    status=$(crm status | grep -i stopped | wc -l)
    if [ "$status" == 0 ];then
        flag=1
        break
    else
        echo "Waiting for cluster resources to start"
        sleep 5
    fi
    retry=$(($retry+1))
    done
    if [ $flag == 1 ];then
    echo "Cluster resources started"
    else
    echo "Cluster resources are in stopped state. Check logs"
    exit 1
    fi
}

app_start () {
echo "Starting SAP app server"
sleep 30
mount -a

echo "Check if /sapmnt is mounted"
flag=0
retry=0
until [ $retry -ge 5 ]
do
    if [ -f "/sapmnt/TST/profile/DEFAULT.PFL" ];then
      flag=1
      break
    else
      echo "Waiting for /sapmnt to be available"
      sleep 5
    fi
retry=$(($retry+1))
done
if [ $flag == 1 ];then
echo "sapmnt is available"
else
echo "Sapmnt is not available. Check logs"
exit 1
fi

echo "Check if ASCS connectivity is working"
flag=0
retry=0
until [ "$retry" -ge 5 ]
do
    nc -z -v -w5 tstascs 3600
    if [ "$?" == 0 ];then
        flag=1
        break
    else
        echo "Waiting for ASCS to connection to be available"
        sleep 5
    fi
retry=$(($retry+1))
done
if [ $flag == 1 ];then
echo "ASCS connectivity is working"
else
echo "ASCS connectivity is working is failing. Check logs"
exit 1
fi

echo "Check if R3trans is working"
flag=0
retry=0
until [ "$retry" -ge 60 ]
do
    rcount=$(su - tstadm -c "R3trans -d | grep -i 0000 | wc -l")
    if [ "$rcount" == 1 ];then
        flag=1
        break
    else
        echo "Waiting for R3trans to be available"
        sleep 5
    fi
retry=$(($retry+1))
done
if [ $flag == 1 ];then
echo "R3trans is working"
else
echo "R3trans connectivity to databse is failing. Check logs"
exit 1
fi

su - tstadm -c "/usr/sap/TST/D00/exe/sapcontrol -nr 00 -function StartService TST"
sleep 5
su - tstadm -c "/usr/sap/TST/D00/exe/sapcontrol -nr 00 -function Start"
flag=0
retry=0
until [ "$retry" -ge 10 ]
do
    pcount=$(ps -ef | grep -i dw | wc -l)
    if [ "$pcount" -gt 10 ];then
        flag=1
        break
    else
        echo "Waiting for SAP to to be available"
        sleep 5
    fi
retry=$(($retry+1))
done

if [ $flag == 1 ];then
echo "SAP started successfully"
else
echo "SAP could not be started. Check logs"
exit 1
fi
    
}

##Main program##
##hostname=$(echo hostname | tr '[:upper:]' '[:lower:]')

echo "VM name is $hostname"
case $hostname in
    *"app"*)
    app_start
    ;;
    "tst"*"0")
    cluster_restart
    ;;
    "tst"*"1")
    cluster_restart
    cluster_maintmode
    ;;

esac




        
