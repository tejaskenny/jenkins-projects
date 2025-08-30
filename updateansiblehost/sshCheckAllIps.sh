#!/bin/bash

## Loop for Centos User
touch /tmp/temp_hostname
echo "[allVms]" > /tmp/temp_hostfile
#SSH_IPS=(`cat /tmp/node_inventory/data/all-data.txt | grep -Eo "192.168.[0-9]{2}.[0-9]{1,3}"|tr ' ' '\n'`)
SSH_IPS=(`cat /tmp/node_inventory/data/all-data.txt | grep -Eo "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"|tr ' ' '\n'`)
SSH_PORTS=(7559 6559 22)
SSH_USERS=('centos' 'vrtzadmin')
for SSH_IP in ${SSH_IPS[@]}
do
    for SSH_PORT in ${SSH_PORTS[@]}
    do
        if ncat  -w 1s -z $SSH_IP $SSH_PORT
        then
            for SSH_USER in ${SSH_USERS[@]}
            do
                if  ssh -o StrictHostKeyChecking=no  -o BatchMode=yes -i  /home2/ansible/Loginkeys/livekey -p $SSH_PORT $SSH_USER@$SSH_IP "hostname -s"> /tmp/temp_hostname 2>&1
                then
                   # echo "yes"
                     echo "$SSH_IP ansible_user=$SSH_USER ansible_port=$SSH_PORT ansible_ssh_private_key_file=/home2/ansible/Loginkeys/livekey inventory_hostname_short=`cat /tmp/temp_hostname`" >> /tmp/temp_hostfile
                     break
                elif ssh -o StrictHostKeyChecking=no  -o BatchMode=yes -i  /home2/ansible/Loginkeys/beta -p $SSH_PORT $SSH_USER@$SSH_IP "hostname -s"> /dev/null 2>&1
                then
                     echo "$SSH_IP ansible_user=$SSH_USER ansible_port=$SSH_PORT ansible_ssh_private_key_file=/home2/ansible/Loginkeys/beta" >> /tmp/temp_hostfile
                     break
#                   echo "issue for $SSH_IP $SSH_USER $SSH_PORT"
                fi
            done
        fi
    done
done