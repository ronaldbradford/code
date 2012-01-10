ping -c 1 localhost

ping -c 1 xxx.localhost
#ping: unknown host xxx.localhost

sudo apt-get install dnsmasq
echo "address=/localhost/127.0.0.1" > /tmp/localhost
sudo mv /tmp/localhost /etc/dnsmasq.d
sudo /etc/init.d/dnsmasq restart

sed -e "s/#prepend domain-name-servers 127.0.0.1;/prepend domain-name-servers 127.0.0.1;/" /etc/dhcp/dhclient.conf > /tmp/dhclient.conf
diff /etc/dhcp/dhclient.conf /tmp/dhclient.conf 
sudo cp /etc/dhcp/dhclient.conf /etc/dhcp/dhclient.conf.bak
sudo mv /tmp/dhclient.conf /etc/dhcp

#sudo /etc/init.d/networking restart  # This does not do it, not sure if required after
sudo /etc/init.d/network-manager restart

ping -c 1 xxx.localhost



Or 

listen-address=127.0.0.1 in /tmp/localhost

and 
nameserver 127.0.0.1 #first in /etc/resolv.conf
