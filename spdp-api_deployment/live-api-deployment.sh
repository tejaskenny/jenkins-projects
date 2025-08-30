#!/bin/bash


#step: check md5sum 
echo " md5sum  = `md5sum /tmp/vertoz-spdp-0.0.1-SNAPSHOT.jar` "

#############################################

#step: maintaince page
echo "Showing maintenance page on screen"
cp -r /var/www/white-labels-console/index.html /var/www/white-labels-console/index.html_bkp
cp  -r /home/centos/maintenance/index.html /var/www/white-labels-console/index.html
cp  -r /home/centos/maintenance/site-maintenance-980x628.jpg /var/www/white-labels-console/
echo "done"
#############################################


#step: kill process vertoz

VAR=`ps -ef |grep /home/centos/vertoz | grep -v grep | awk '{print $2}'`

if  [[ -z  $VAR ]] ;then
echo "jar process not running "
else
echo "vertoz process pid : $VAR"
echo "killing the vertoz process "
kill -9 $VAR
fi

#############################################
#step: backup log file and truncate
tar -zcvf /home2/backup/vertoz-spdp-log-$(date "+%Y_%m_%d_%H_%M").tgz -C /home/centos vertoz-spdp.log
> /home/centos/vertoz-spdp.log
#############################################

#step6: api file replace
rm -rf /home/centos/vertoz-spdp.jar
echo "coping the jar from tmp folder to /home/centos"
cp -r /tmp/vertoz-spdp-0.0.1-SNAPSHOT.jar /home/centos/vertoz-spdp.jar


#############################################

#step7: check md5sum is proper

echo " md5sum  = `md5sum /home/centos/vertoz-spdp.jar` "


#############################################

#step8: run java jar
echo "running the java process"
java -jar /home/centos/vertoz-spdp.jar --spring.config.location=file:///var/tomcat7/application-prod.properties >>/home/centos/vertoz-spdp.log &
#java -jar /home/centos/vertoz-spdp-0.0.1-SNAPSHOT.jar --spring.config.location=file:///var/tomcat7/application-beta.properties >> /home/centos/test.log &


HOUR1=`date | awk '{print $4}' | awk -F ":" '{print $1":"$2}'| sed '$ s/.$//'`


#############################################

#steps9: check vertoz process is running 

PID=`ps -ef |grep /home/centos/vertoz | grep -v grep | awk '{print $2}'`
#echo $PID
if  [[ -z $PID  ]];then
echo "jar process not running "
else
echo "process has started"
echo " process id : $PID"
fi

#############################################

runtime="2 minute"
endtime=$(date -ud "$runtime" +%s)
echo "checking logs.......and fetching Tomcat started log"
DATE2=$(date "+%Y-%m-%d")
while [[ -z $VAR2  ]] && [[ $(date -u +%s) -le $endtime  ]]
do
echo "waiting for success output........."
sleep 10
#VAR2=`cat   /home/centos/test.log  |grep "${DATE2}" | date +%k:%M | sed '$ s/.$//' | grep "Tomcat started on port(s): 8081"`
VAR2=`cat   /home/centos/vertoz-spdp.log  |grep "${DATE2}" |grep -A 1000000 "${HOUR1}" | grep "${PID}"|  grep "Tomcat started on port(s): 8081"`


done

if [[ -z $VAR2 ]]
then
echo "jar didnt run sucessfully"
exit 1
fi
echo "jar started sucessfully"
echo $VAR2

#step10 : cp original index.html
echo "removing maintainance page and adding original page"
mv -f /var/www/white-labels-console/index.html_bkp /var/www/white-labels-console/index.html
echo "done"

#############################################


#step11: update mysql db

#mysql -u root -p''  spdp_db "UPDATE tbl_user_auth SET expired_time = now()  WHERE expired_time > now();"



#############################################

