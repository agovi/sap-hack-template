#!/bin/bash
#Author : Karthik Venkatraman
set -x
hostname=${host}
cluster_restart () {
    echo "Stopping cluster"
    crm cluster stop
    echo "Start Cluster"
    crm cluster start
    echo "Status of cluster"
    crm cluster status
}

cluster_maintmode () {
    echo "removing maintenance mode"
    ## Wait for cluster services to start before removing maintenance mode
    sleep 10
    crm configure property maintenance-mode=false
    ## Wait for cluster resources to start
    sleep 10
    crm status
    ##if [ $hostname == "tst-xscs-vm-1"];then
    ##    echo "cleanup any errors in ERS resource"       
    ##   crm resource cleanup rsc_sap_TST_ERS02
    ##fi
}

app_start () {
echo "Starting SAP app server"
sleep 30
mount -a
echo "Check if /sapmnt is mounted"
if [ ! -f "/sapmnt/TST/profile/DEFAULT.PFL" ];then
retry=0
    until [ $retry -ge 5 ]
    do
    echo "Waiting for /sapmnt to be available"
    sleep 5
       if [ -f "/sapmnt/TST/profile/DEFAULT.PFL" ];then
       break
       fi
    retry=$retry + 1
    done
else 
  echo "sapmnt is available"
fi

echo "Check if R3trans is working"
rcount=$(su - tstadm -c "R3trans -d | grep -i 0000 | wc -l")
if [ "$rcount" != 1 ];then
retry=0
    until [ "$retry" -ge 5 ]
    do
    echo "Waiting for R3trans to be available"
    sleep 10
       rcount=$(su - tstadm -c "R3trans -d | grep -i 0000 | wc -l")
       if [ "$rcount" == 1 ];then
       break
       fi
    retry=$retry + 1
    done
else 
  echo "R3trans is working"
fi
su - tstadm -c "/usr/sap/TST/D00/exe/sapcontrol -nr 00 -function StartService TST"
sleep 5
su - tstadm -c "/usr/sap/TST/D00/exe/sapcontrol -nr 00 -function Start"
sleep 5
pcount=$(ps -ef | grep -i dw | wc -l)
    if [ "$pcount" -gt 5 ];then
    echo "SAP applications started"
    exit
    fi
echo "SAP couldn't be started. Please check logs"        
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




        