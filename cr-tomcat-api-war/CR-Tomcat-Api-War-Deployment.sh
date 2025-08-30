#!/bin/bash

function deployment {
bash  /home2/tomcat/bin/shutdown.sh
# wait for 1 sec
sleep 1
# check if service is running or not, kill forcefully if it is running
TOMCAT_PID=`pgrep -f tomcat`
if [ -z $TOMCAT_PID ]
then
echo "tomcat killed sucessfully"
else
kill -9 $TOMCAT_PID
sleep 1
fi
ps -ef | grep tomcat
rm -rf /home2/tomcat/webapps/ConnectReseller*
cp /tmp/ConnectReseller.war /home2/tomcat/webapps/ConnectReseller.war
md5sum /tmp/ConnectReseller.war /home2/tomcat/webapps/ConnectReseller.war
bash  /home2/tomcat/bin/startup.sh
}

function check_catout_logs {

#Display Tomcat logs for 2 mins
echo "Tomcat Catalina  Log Output"
timeout 60s tail -f /home2/tomcat/logs/catalina.out
exit 0
}

function backup {
var1=$(date '+%Y-%m-%d-%H_%M')
sudo cp /home2/tomcat/webapps/ConnectReseller.war /home2/backup/ConnectReseller.war_$var1
ls /home2/backup/ConnectReseller.war_$var1
if [ $? -ne 0 ]; then
		echo "backup failed!"
                exit 1
else
       echo "Backup created!"
       md5sum /home2/tomcat/webapps/ConnectReseller.war /home2/backup/ConnectReseller.war_$var1
fi       
}

function checkstatus {
while true
do
AWS_EC2_STATUS=`/usr/local/bin/aws --profile=devops-cr --region=us-east-1  elb describe-instance-health  --load-balancer-name lbapi --instances $1 --query InstanceStates[*].State[]| grep -Eo "[a-zA-Z-]+*"`
if  [[ $AWS_EC2_STATUS == "InService"  ]]
then
echo "Ec2 is in service now"
exit 0
else
echo "Ec2  NOT in Service"
fi 
done
}


$1 $2
