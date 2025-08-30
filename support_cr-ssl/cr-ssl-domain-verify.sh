IP=`dig $1 | grep -Eo "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b"`
if [[ $IP == '52.203.60.100'  ]]
  then
    echo "Domain verification Passed"
else
    echo "Domain verification Failed"
    exit 1 
fi
