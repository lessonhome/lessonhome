
iptables -t mangle -A PREROUTING -p tcp --dport 80 -j MARK --set-mark 1
iptables -t mangle -A PREROUTING -p tcp --dport 443 -j MARK --set-mark 1
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8081
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8083
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8081 -m mark --mark 1 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 8083 -m mark --mark 1 -j ACCEPT

 iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 8081
 iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j REDIRECT --to-ports 8083
 iptables -t nat -I OUTPUT -p tcp -d 192.168.88.232 --dport 80 -j REDIRECT --to-ports 8081
 iptables -t nat -I OUTPUT -p tcp -d 192.168.88.232 --dport 443 -j REDIRECT --to-ports 8083
