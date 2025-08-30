Login_SSH_Port=$2
Login_Key=$3
Login_User=$4


rm -rf /tmp/temp_hostfile

echo """
[temp_host]
$(echo $1 |tr ',' '\n')
""" >> /tmp/temp_hostfile

echo """

[all:vars]
ansible_port=${Login_SSH_Port}
ansible_user=${Login_User}
ansible_ssh_private_key_file=/home2/ansible/Loginkeys/${Login_Key}
""" >> /tmp/temp_hostfile 

cat /tmp/temp_hostfile
