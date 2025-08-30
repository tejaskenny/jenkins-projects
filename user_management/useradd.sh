echo "check if user $1 present on server `hostname -s`"
getent   passwd  $1 > /dev/null&& echo "user present exiting code"&& exit 1 ||echo "user not present"

echo "create user"
useradd -m  -s /bin/bash $1

echo "create users ssh directory ,authorized_keys file and give proper permissions  "
mkdir /home/$1/.ssh
touch /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1
chmod 700 /home/$1/.ssh
chmod 600 /home/$1/.ssh/authorized_keys
echo `cat /tmp/key.pub` >/home/$1/.ssh/authorized_keys

if $2
then
echo "provide sudo access"
echo "%$1 ALL=(ALL)       NOPASSWD: ALL"  > /etc/sudoers.d/$1
fi
