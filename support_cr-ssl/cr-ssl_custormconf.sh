
OLD_FILE=`grep -l $1 /etc/httpd/conf.d/*`
if ! [ -z $OLD_FILE ]
then

	mv -f $OLD_FILE /home2/backups/
fi

echo "Copy Certificate files"

cp -r /tmp/ssl-${1}/domain-crt /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//').crt
cp -r /tmp/ssl-${1}/domain-key /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//').key
cp -r /tmp/ssl-${1}/domain-ca /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//')-bundle.crt



echo """
Creating custorm host 
file name: '$(echo $1 | sed -r 's/\.[^.]+$//').conf' 
location: '/etc/httpd/conf.d '"
echo """
 <VirtualHost *:443>
 ServerName ${1}
 ServerAlias ${1}
 SSLEngine on
 SSLCertificateFile /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//').crt
 SSLCertificateKeyFile /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//').key
 SSLCertificateChainFile /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//')-bundle.crt

 DocumentRoot "/var/www/html"

 <Directory "/var/www/html">
 Options +Indexes +FollowSymLinks +MultiViews
 AllowOverride All
 Order allow,deny
 Allow from all
 </Directory>

 LogLevel debug
 ErrorLog  /var/log/httpd/$(echo $1 | sed -r 's/\.[^.]+$//')-error.log
 CustomLog /var/log/httpd/$(echo $1 | sed -r 's/\.[^.]+$//')-access.log combined
 </VirtualHost>
""" > /etc/httpd/conf.d/$(echo $1 | sed -r 's/\.[^.]+$//').conf




echo "SSL Files:"
echo ""
ls /home/ssl/$(echo $1 | sed -r 's/\.[^.]+$//')*
echo ""
echo "================================================================================"
echo ""
echo "$1 httpd conf file:"
echo ""
cat /etc/httpd/conf.d/$(echo $1 | sed -r 's/\.[^.]+$//').conf

