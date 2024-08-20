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
