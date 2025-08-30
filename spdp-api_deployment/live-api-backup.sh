#!/bin/bash

#step3: backup api package
DATE1=$(date "+%Y_%m_%d_%H_%M")

cp  -r /home/centos/vertoz-spdp.jar /home2/backup/vertoz-spdp_${DATE1}.jar

#step 2: check the backup

if ! [[ -f /home2/backup/vertoz-spdp_${DATE1}.jar ]]
then
echo "backup not created"
exit 1
fi
echo "backup cerated  "
echo "`ls -l /home2/backup/vertoz-spdp_${DATE1}.jar`"

#############################################

