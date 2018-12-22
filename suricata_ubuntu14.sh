echo "INSTALL SURICATA FORM APT"

apt-get install -y libpcre3-dbg libpcre3-dev autoconf automake libtool libpcap-dev libnet1-dev libyaml-dev libjansson4 libcap-ng-dev libmagic-dev libjansson-dev zlib1g-dev

apt-get install -y libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev

add-apt-repository ppa:oisf/suricata-stable -y

apt-get update -y

apt-get install suricata suricata-dbg -y

echo "TURN OFF GRO"

ethtool -K eth0 gro off

echo "CREATE TEST.RULES"

cat > /etc/suricata/rules/test.rules <<\EOF
alert icmp any any -> $HOME_NET any (msg:"ICMP connection attempt"; sid:1000002; rev:1;) 
alert tcp any any -> $HOME_NET 23 (msg:"TELNET connection attempt"; sid:1000003; rev:1;)
alert tcp any any -> $HOME_NET 22 (msg: "NMAP TCP Scan";sid:10000005; rev:2; )
alert tcp any any -> $HOME_NET 22 (msg:"Nmap XMAS Tree Scan"; flags:FPU; sid:1000006; rev:1; )
alert tcp any any -> $HOME_NET 22 (msg:"Nmap FIN Scan"; flags:F; sid:1000008; rev:1;)
alert tcp any any -> $HOME_NET 22 (msg:"Nmap NULL Scan"; flags:0; sid:1000009; rev:1; )
alert udp any any -> $HOME_NET any ( msg:"Nmap UDP Scan"; sid:1000010; rev:1; )
EOF

sed -i "s|default-rule-path: /var/lib/suricata/rules|default-rule-path: /etc/suricata/rules|" /etc/suricata/suricata.yaml
sed -i "s| - suricata.rules| - test.rules|" /etc/suricata/suricata.yaml
ip=$(/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
sed -i "s| HOME_NET:| HOME_NET:  \"[$ip]\"\n #HOME_NET:|" /etc/suricata/suricata.yaml

echo "EDIT CONFIG FLOW"
echo "chinh sua file /etc/suricata/suricata.yaml:
- HOME_NET: IP cua may
- default-rule-path: /etc/suricata/rules
- rule-files: - test.rules
Chay chuong trinh: (rm -rf /var/run/suricata.pid) /usr/bin/suricata -D -c /etc/suricata/suricata.yaml -i  eth0
Xem log: tail -50f /var/log/suricata/fast.log
* test voi nmap:
- nmap -sP $ip --disable-arp-ping
- NMAP TCP Scan: nmap -sT -p22 $ip
- NMAP XMAS Scan (lay flag: FIN, PSH, URG): nmap -sX -p22 $ip
- NMAP FIN Scan (lay flag FIN): nmap -sF -p22 $ip
- NMAP NULL Scan (TCP khong chua flag): nmap -sN -p22 $ip
- NMAP UDP Scan: nmap -sU -p68 $ip
"


