sed -i "s|LoadModule version_module modules/mod_version.so|LoadModule version_module modules/mod_version.so\nLoadModule reqtimeout_module modules/mod_reqtimeout.so\n|" /etc/httpd/conf/httpd.conf
sed -i "s|<IfModule mod_userdir.c>|<IfModule reqtimeout_module>\n\tRequestReadTimeout header=20-40,MinRate=500 body=20,MinRate=500\n</IfModule>\n<IfModule mod_userdir.c>\n|" /etc/httpd/conf/httpd.conf
echo "127.0.0.1 $(hostname)" >> /etc/hosts
service httpd restart
