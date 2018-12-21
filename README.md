#Script cho QTATHTM
##Bài: CẤU HÌNH MOD_REQUIRE_TIMEOUT 
###Yêu cầu hệ thống:
- Centos 6.5 32bit
###Run
```
chmod 755 reqtimeout.sh
sh reqtimeout.sh
```
###Test
- phía máy kali thực hiện tấn công slowloris vào ip server
- thực hiện truy cập website server

##Bài: CẤU HÌNH MODSECURITY 
###Yêu cầu hệ thống:
- Centos 6.5 32bit (nếu là 64bit cần chuyển i386 về x86_64)
###Run
```
chmod 755 mod_security.sh
sh mod_security.sh
```
###Test
- Tấn công sqli và XSS
- http://ipserver/raovat/index.php?mod=baiviet&id=-6 union select 1,2,unhex(hex(group_concat(table_name))),4,5,6 from information_schema.tables where table_schema=database()-- -

##Bài: Cài đặt Suricata
###Yêu cầu hệ thống:
- Ubuntu 14 or ubuntu 16
###Run
```
chmod 755 suricata*
sh suricata_ubuntu14.sh or sh suricata_ubuntu16.sh
```
###Test
- ping và sửa luật chặn ping
