#!/bin/bash
domain=$1
rm -rf /var/lib/mysql-files/domainhistory.csv /tmp/domainhistory.zip /tmp/domainhistory.csv
mysql -u root -po]2R#P8qr/63 << EOF
SELECT * FROM ConnectReseller.DomainHistory WHERE DomainName IN ('$domain') INTO OUTFILE '/var/lib/mysql-files/domainhistory.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
EOF
cp /var/lib/mysql-files/domainhistory.csv /tmp
cd /tmp
zip domainhistory.zip domainhistory.csv
