wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm 
yum install -y mod_security 
sed -i "s|SecRuleEngine Off|SecRuleEngine On|" /etc/httpd/conf.d/mod_security.conf
cat > /etc/httpd/conf.d/rule.conf <<\EOF
SecRule REQUEST_COOKIES|!REQUEST_COOKIES:/__utm/|!REQUEST_COOKIES:/_pk_ref/|REQUEST_COOKIES_NAMES|ARGS_NAMES|ARGS|XML:/* "(/\*!?|\*/|[';]--|--[\s\r\n\v\f]|(?:--[^-]*?-)|([^\-&])#.*?[\s\r\n\v\f]|;?\\x00)" "phase:2,deny,status:403,id:'1',msg:'SQL Inject',log"
SecRule ARGS "(?i)(<script[^>]*>[\s\S]*?<\/script[^>]*>|<script[^>]*>[\s\S]*?<\/script[[\s\S]]*[\ s\S]|<script[^>]*>[\s\S]*?<\/script[\s]*[\s]|<script[^>]*>[\s\S]*?<\/script|<script[^ >]*>[\s\S]*?)" "phase:2,deny,status:403,id:'2',msg:'XSS Filter',log"
EOF
echo "127.0.0.1 $(hostname)" >> /etc/hosts
service httpd restart
ip=$(/sbin/ifconfig eth1 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
echo "Test sqli
-  http://$ip/raovat//index.php?mod=baiviet&id=6 order by 7-- - 
- http://$ip/raovat//index.php?mod=baiviet&id=-6 union select 1,2,3,4,5,6-- - 
- http://$ip/raovat/index.php?mod=baiviet&id=-6 union select 1,2,unhex(hex(group_concat(table_name))),4,5,6 from information_schema.tables where table_schema=database()-- -
- http://$ip/raovat/index.php?mod=baiviet&id=-6 union select 1,2,unhex(hex(group_concat(table_name))),4,5,6 from information_schema.tables where table_schema=database()-- -
Code secrule: SecRule VARIABLES OPERATOR [ACTIONS]
"