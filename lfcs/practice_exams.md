4

7

11

15 - jak rozpoznac odpowiednia partycje (to za pomoca -ph)

Identify the process with the high read transfer rate/second. Create the file /opt/highread.pid and write the PID number of that process in that file. For example, if the PID is 3886 you just write 3886 in that file (only the number, on a single line).

a to jak znalezc PID jak tam za pomoca iostat partycje pokazuje



17 - jak zrobic wyjatek?

On caleston-lp10 change the configuration for the SSH daemon. Disable X11 forwarding globally. Then, make an exception for just one user called bob. For that user alone enable X11 forwarding.



first exam: 54 %







SECOND EXAM: 43%

Don't use the system-wide crontable - this means not to use the crontab -e? And use the /etc/crontab instead when we are logged as certain user?


Change the required kernel parameter to enable IPv4 forwarding on this system.


which one when the output is:
net.ipv4.conf.all.bc_forwarding = 0
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.all.mc_forwarding = 0
net.ipv4.conf.default.bc_forwarding = 0
net.ipv4.conf.default.forwarding = 1
net.ipv4.conf.default.mc_forwarding = 0
net.ipv4.conf.eth0.bc_forwarding = 0
net.ipv4.conf.eth0.forwarding = 1
net.ipv4.conf.eth0.mc_forwarding = 0
net.ipv4.conf.eth1.bc_forwarding = 0
net.ipv4.conf.eth1.forwarding = 1
net.ipv4.conf.eth1.mc_forwarding = 0
net.ipv4.conf.lo.bc_forwarding = 0
net.ipv4.conf.lo.forwarding = 1
net.ipv4.conf.lo.mc_forwarding = 0
net.ipv4.conf.virbr0.bc_forwarding = 0
net.ipv4.conf.virbr0.forwarding = 1
net.ipv4.conf.virbr0.mc_forwarding = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.all.mc_forwarding = 0
net.ipv6.conf.default.forwarding = 0
net.ipv6.conf.default.mc_forwarding = 0
net.ipv6.conf.eth0.forwarding = 0
net.ipv6.conf.eth0.mc_forwarding = 0
net.ipv6.conf.eth1.forwarding = 0
net.ipv6.conf.eth1.mc_forwarding = 0
net.ipv6.conf.lo.forwarding = 0
net.ipv6.conf.lo.mc_forwarding = 0
net.ipv6.conf.virbr0.forwarding = 0
net.ipv6.conf.virbr0.mc_forwarding = 0





zad 5.

Nie pamietam jak sie robi port redirection - to ejst chyba reverse proxy ale nie pamietam skladni pliku jak to powinno sie zrobic poprawnie


zad 6

nic nie pamietam apropo rsa i certyfikator tls/ssl



11

pamietam ze trzeba zrobic soft-link ln -s /sites/available do /sites/enabled

i usunac defaultowa konfiguracje ale nie pamietam dokladnie jak to sie robi


15

1. nie pamietam gdzie byly przykladowe pliki yaml od netplan

2. nie pamietam skladni pliku yaml, ktory trzeba tam zastosowac

za pomoca man netplan znalazlem konf tego pliku:
network:
ethernets:
eth0:
dhcp4: false
eth1:
dhcp4: false
bridges:
br0:
interfaces: [eth0, eth1]
dhcp4: true

Ale nadal nie pamietam gdzie to sie umieszczalo i jak to sie resetowalo wszystko


zad 17
LDAP - nic z tego nie zrobilem w powtorkach. 













LFCS EXAM 3 - 56 % chociaz wydaje mi sie ze wiecej po 3 zadania
dodatkowo powinny byc zaliczone ze poprawnie
- crontab
- interfaces
- docker



1. - nie pamietam jak utowrzyc reverse proxy
     server nginx.



Pamietam ze potem jak stworzymy konfiguracje pliku, to
zapisujemy ja w sites-available, pozniej tworzy soft link do sites-enabled

rm /sites-enabled/default i

najpierw sudo nginx -t (od try)
sudo systemctl restart/revert nginx

6. - Jak sprawdzic czy te paremetry zostaly odpowiednio ustawione


9. - nie powtorzony iptables

sudo iptables -t nat -A PREROUTING -s 10.11.12.0/24 -d 10.9.9.1
to udalo mi sie wyjac z dokumentacji + z tego co pamietam

a jezeli chodzi o POSTROUTING to nie wiem zupelnie jak to zrobic
ale wpisalem cos takiego:
sudo iptables -t nat -A POSTROUTING -s 10.9.9.1 MASQUERADE
ale to jest zle
s

10. cos zjebane na stronce

docker build -t kodekloud/nginx_kodekloud:1.0 .

docker run -d --name kodekloud_webserv -p 81:80 id_contenera


16. - jak sprawdzic czy zmiany wprowadzone w /etc/systemd/timedatectl.conf zostaly wprowadzone


17. - powtorz cale nbd od poczatku jak robic












sudo iptables -t nat -A PREROUTING -p tcp -s 10.9.9.0/24 --dport 8080 -j DNAT --to-destination 10.100.0.8:80


sudo iptables -t nat -A PREROUTING -p tcp -s 10.5.5.0/24 --dport 81 -j DNAT --to-destination 192.168.5.2:80




LFCS4



1. jak sprawdzic zdefiniowane port redirection rules

sudo iptables -t nat -L -n -v


2. NTP default cos tam jak znalezc

7.git push --set-upstream origin master

co to dokladnie jest ?


8. how to get the associated key to the certificate


9. Expand the logical volume called LV1 to use 100% of the free space available on the VG1 volume group

za chuj nie wiem czemu mi to nie dziala


14. ogolnie zrobione dobrze ale nie wiem dlaczego akurat sie ustawilo na poprawny type label.
    Sprawdz czy da sie ustawic to na co sie zmienia




Add a cron job to the crontable of the user called john (not the system-wide crontable).

This cron job should be executed every Monday and Saturday at 3 AM (03:00).
The command executed by this cron job should be:
tar acf /home/john/www-snapshot.tgz /var/www
Important note: The crontable entry should be specified on a single line (not one line for Monday and a separate one for Friday).


tu pod




upstream server_my_server{
server 124.123.123.123 weight=3;

}


server{
listen 80;
location / {
proxy_conf server_my_server
}
}

