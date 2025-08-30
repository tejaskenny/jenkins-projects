#!/bin/bash
smtp-cli  --server=zimbra.vertoz.com --port 587  --user=csv-monitor@zimbra.vertoz.local --pass=7e5WG4nQV2c6JG24 --missing-modules-ok --subject="Domain history $1"     --auth --from='Team CR<support@connectreseller.com>' --to='devops@vertoz.com' --to='cr-internal@connectreseller.com'  --to='dev@connectreseller.com' --to='rohit.shelke@vertoz.com' --body-plain "

Hello Team,

Please find the  file attached  below.

Thank You
System Team" --attach=domainhistory.zip
