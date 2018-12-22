echo "INSTALL SURICATA FORM APT"

apt-get install -y libpcre3-dbg libpcre3-dev autoconf automake libtool libpcap-dev libnet1-dev libyaml-dev libjansson4 libcap-ng-dev libmagic-dev libjansson-dev zlib1g-dev

apt-get install -y libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev

add-apt-repository ppa:oisf/suricata-stable -y

apt-get update -y

apt-get install suricata suricata-dbg -y

echo "TURN OFF GRO"

ethtool -K ens33 gro off

echo "CREATE TEST.RULES"

cat > /etc/suricata/rules/test.rules <<\EOF
alert icmp any any -> $HOME_NET any (msg:"ICMP connection attempt"; sid:1000002; rev:1;) 
alert tcp any any -> $HOME_NET 23 (msg:"TELNET connection attempt"; sid:1000003; rev:1;)
alert tcp any any -> $HOME_NET any (msg: "NMAP TCP Scan"; threshold: type both, track by_src, count 10, seconds 60; sid:10000005; rev:2; )
alert tcp any any -> $HOME_NET any (msg:"Nmap XMAS Tree Scan"; flags:FPU; threshold: type both, track by_src, count 10, seconds 60; sid:1000006; rev:1; )
alert tcp any any -> $HOME_NET any (msg:"Nmap FIN Scan"; flags:F; threshold: type both, track by_src, count 10, seconds 60; sid:1000008; rev:1;)
alert tcp any any -> $HOME_NET any (msg:"Nmap NULL Scan"; flags:0; threshold: type both, track by_src, count 10, seconds 60; sid:1000009; rev:1; )
alert udp any any -> $HOME_NET any ( msg:"Nmap UDP Scan"; threshold: type both, track by_src, count 10, seconds 60; sid:1000010; rev:1; )
EOF

sed -i "s|default-rule-path: /var/lib/suricata/rules|default-rule-path: /etc/suricata/rules|" /etc/suricata/suricata.yaml
sed -i "s| - suricata.rules| - test.rules|" /etc/suricata/suricata.yaml
ip=$(/sbin/ifconfig ens33 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
sed -i "s| HOME_NET:| HOME_NET:  \"[$ip]\"\n #HOME_NET:|" /etc/suricata/suricata.yaml

echo "EDIT CONFIG FLOW"
echo "chinh sua file /etc/suricata/suricata.yaml:
- HOME_NET: IP cua may
- default-rule-path: /etc/suricata/rules
- rule-files: - test.rules
Chay chuong trinh: (rm -rf /var/run/suricata.pid) /usr/bin/suricata -D -c /etc/suricata/suricata.yaml -i  ens33
Xem log: tail -50f /var/log/suricata/fast.log
* test voi nmap:
- nmap -sP $ip --disable-arp-ping
- NMAP TCP Scan: nmap -sT -p 1-65535 $ip
- NMAP XMAS Scan (lay flag: FIN, PSH, URG): nmap -sX -p 1-65535 $ip
- NMAP FIN Scan (lay flag FIN): nmap -sF -p 1-65535 $ip
- NMAP NULL Scan (TCP khong chua flag): nmap -sN -p 1-65535 $ip
- NMAP UDP Scan: nmap -sU -p 1-655535 $ip
"


