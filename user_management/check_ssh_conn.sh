ServerIP=$1
Login_SSH_Port=$2
Login_Key=$3
Login_User=$4
User_to_add=$5
Sudo_Access=$6


ncat  -w 1s -z ${ServerIP} ${Login_SSH_Port}&& echo "able to login "&&exit 0||echo "not able to access server by  ssh port ${Login_SSH_Port} from jenkins"&& exit 1
ssh -o StrictHostKeyChecking=no -i /opt/jenkins-key/${Login_Key} -p ${Login_SSH_Port}  ${Login_User}@${ServerIP} "echo Login_Sucessfull"&& exit 0||echo "failed for ssh connection"&&exit 1
echo "adding user="${User_to_add}" on server="${ServerIP}" with sudo access="${Sudo_Access}"
