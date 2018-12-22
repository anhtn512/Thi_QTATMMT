# Script cho QTATHTM

## Get code về máy:
```
git clone https://github.com/anhtn512/Thi_QTATMMT
cd Thi_QTATMMT
```

## Bài: CẤU HÌNH MOD__REQUIRE_TIMEOUT 
### Yêu cầu hệ thống:
- Centos 6.5 32bit

### Run
```
chmod 755 reqtimeout.sh
sh reqtimeout.sh
```

### Test
- phía máy kali thực hiện tấn công slowloris vào ip server
- thực hiện truy cập website server

## Bài: CẤU HÌNH MODSECURITY 
### Yêu cầu hệ thống:
- Centos 6.5 32bit (nếu là 64bit cần chuyển i386 về x86_64)

### Run
```
chmod 755 mod_security.sh
sh mod_security.sh
```

### Test
- Tấn công sqli và XSS

## Bài: Cài đặt Suricata
### Yêu cầu hệ thống:
- Ubuntu 14 or ubuntu 16

### Run
Tùy vào phiên bản ubuntu mà chạy 14 or 16
```
chmod 755 suricata*
sh suricata_ubuntu14.sh or sh suricata_ubuntu16.sh
```

### Test
- ping và sửa luật chặn ping
