# LFCS - Networking

> Topic for Networking commands and knowledge

## Terms

# 1
> IPv4 IPv6

Command that show us our networking devices/network interfaces. Like virtual once but can be as well some
like ethernet card too. Loopback - virtual
```bash
    ip link #This command show us interfaces
    ip address/ip add/ip a #This 2 commands print us the ip addresses of our interfaces
    ip -c address 
    
```

If some interface is down, we can manually set it up. To do it type the command:
```bash
    sudo ip link set dev [NAME_OF_THE_INTERFACE] up/down
    sudo ip link set dev br-85acce04497e up
    
    #Or to set it down
    sudo ip link set dev br-85acce04497e down 
    
    
    #In the same way we can add an ip address to our device/interface
    #To do so, type: 
    sudo ip address set [IP_ADDRESS] dev [INTERFACE]
    sudo ip address set 10.0.0.40/24 dev br-85acce04497e 
    
    #Or the same with IPv6 address
    sudo ip address set fe80::5054::ff:fe1f:8050/64 dev br-85acce04497e 
```
ip command is temporary so we use it mostly to test out our settings and network settings.
To change them permanently in Ubuntu we have to use 'Netplan'.
To see our current Netplan configuration files:
```bash
    sudo netplan get
```

The full path to the configuration file of netplan is:
> /etc/netplan/[this_file].yaml

BUT PRETTY OFTEN WE CAN FIND: renderer: NetworkManager.
Then we have to go to:
> /etc/NetworkManager/NetworkManager.conf

To change the configuration files


When we made the changes we have to apply them later on.
We have a better option to test it first and to 'try' it 
before we actually apply, this command looks like:
```bash
    sudo netplan try
```



To provide a functionality where we can ping/connect with our services not by their IP addresses,
but by their hostname we have to configure 
> /etc/hosts file

Where we can assign an IP address to a hostname


> /usr/share/doc/      under this path we can pretty often find extra configuration files that are
> not listed in the man pages


In this example under /usr/share/doc/netplan/examples we have many files that let us see how to write
certain functionalities.


We can use ss/netstat to check incoming connections to our ssh deamon?
```bash
    sudo ss -ltunp # l -listing , t - tcp connections, u - udp connections, n - numeric values, p- procceses
```


```
Netid  State   Recv-Q  Send-Q        Local Address:Port      Peer Address:Port  Process                                                                         
udp    UNCONN  0       0                   0.0.0.0:111            0.0.0.0:*      users:(("rpcbind",pid=664,fd=5),("systemd",pid=1,fd=36))                       
udp    UNCONN  0       0                   0.0.0.0:41074          0.0.0.0:*      users:(("rpc.mountd",pid=1867,fd=4))                                           
udp    UNCONN  0       0                   0.0.0.0:631            0.0.0.0:*      users:(("cups-browsed",pid=1857,fd=7))                                         
udp    UNCONN  0       0                   0.0.0.0:41595          0.0.0.0:*      users:(("rpc.statd",pid=1865,fd=8)) 
```
This is how these processes look
THe Local Address:Port - is an entry of an program that is listening for incoming connections from the
system itself, but not other computers
127.0.0.1 - so called localhost, basically the same computer that it is working on


>If the service is ending with the ssh.service w domysle to to jest sshd.service, d - pochodzi od deamon


We can disable/start these services by the commands we learned already
sudo sysctl start/stop/disable ssh.service



# 2
> Bridging/Bonding Devices and Configure Packet Filtering


What is Bridging/Bonding devices? We can take 2 or more network devices and glue them together 
under the operating system and this creates a network device - either Bridge or either Bond.

Bridge - builds a bridge between 2 separate network. Allows computers on 2 separate networks
to behave between each other as if they were part of the same network

NETWORK1 <-----------> BRIDGE <-----------> NETWORK2


Bond - it connects/create a 1 single interface by which other networks can communicate with our
connected one. It can increase speed, stability and so on.
     BOND
|-------------|
|  NETWORK1   |
|  NETWORK2   |
|-------------|

We have different Bonding Modes. From Mode 0 to mode 6.
- 0 - round-robin (default) - uses network interfaces in  sequential order.
- 1 - active backup - Takes 1 active interface only. If 1 interface goes down, then it uses the second one which was left as a backup
- 2 - XOR - picks the interface based on the source and destination of the data packets
- 3 - broadcast - all data is send to all interfaces
- 4 - IEEE 802.3 increases network throughput above 1 single card
- 5 - adaptive transmit load balancing - sends the data to the interface which is the least busy
- 6 - adaptive load balancing - tries to load balance both outgoing and incoming


Configuring bridge:
We have to modify/create a file under /etc/netplan/ directory and define a bridge in a yaml file


I connected 2 interfaces that were down by typing ip -c addresses and finding them
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    br-85acce04497e:
      dhcp4: no
    virbr0:
      dhcp4: no
  
  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - virbr0
        - br-85acce04497e
```

Configuring Bind:

The same: is the best practice to go into
> /usr/share/doc/netplan/examples/...  <------- and here are examplary yaml files stored to use

Then we can copy it and put into into right place -> /etc/netplan/...
and create/modify this file to our needs


```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: no
    enp4s0:
      dhcp4: no
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - enp3s0
        - enp4s0
      parameters:
        mode: active-backup
        primary: enp3s0
```
To apply changes with bonds we can only use
```bash
    sudo netplan apply
```

Other command like netplan try are not available here,
so we have to be careful because this will be applied immedietlely




Now after configuring bonds and bridges we can work on them in the same way as we did 
with other interfaces:
- sudo ip link set dev bond0 down
- sudo ip addr add dev brg0 10.0.0./24

itp....



### Packet Filtering(Firewall)

We have multiple firewalls:

Application Firewall - monitor individual apps and decide if they should allow/deny traffic(Windows)
that accepts for example traffic to google chrome, but not to calculator

On the other side in Linux we have

Network Data Packet - which takes a decision to allow/deny based on the network packets themselves,
not the applications possible

UFW - Uncomplimented Firewall this is the tool we are going to use 

If it is active - it blocks all incoming data - it is called whitelist approach - everything dissalowed
besides the stuff we manually configure

```bash
    sudo ufw allow 22 #Allows tcp and udp protocols on port 22 - ssh port
    sudo ufw status #Prints if our firewall is running
    sudo ufw allow 22/tcp #Specifying specific protocol
    sudo ufw enable #Enables firewall

    sudo ufw status verbose #Prints everything with more information
    
    sudo ufw allow [IP_ADDRESS] to any port [PORT]
    sudo ufw allow 10.0.0.192 to any port 22 #This command allows only our IP of the computer to connect via ssh port

```


BUT IMPORTANT DISCLAIMER!


adding new rules does not mean that previous are being deleted.
If we have both rules:
1. To allow connection from our IP to any 22 port
2. To allow all ip's to port 22

It basically means that the 2nd one is applied.
We have to delete it if we want to allow only the connection from our own IP to port 22.
To do it:

```bash
     sudo ufw status numbered #prints the numbers of our rules
     sudo ufw delete 1 #Delete the rule nr. 1
     
```

We can specify that we want to accept the connection between certain ranges.
To do so:

```bash
     sudo ufw allow from 10.0.0.0/24 to any port 22
     sudo ufw allow from 10.0.0.0/24 #It allows ip's from this range to enter all port in our network
```
We can also specify one specific ip which we dont want to accept. To do so we have the command:

```bash
     sudo ufw deny from 10.0.0.37
```


The rules are being checked from up to the bottom so if we have already a rule
that accepts all the trafic from the ip's 10.0.0.0/24 and the 2nd rule which denies
a traffic from the ip 10.0.0.37, then unfortunetly if a connection from 10.0.0.37 appears
it will be allowed, because only the 1st rule will be checked.
To do it correctly we have to place the rules in the correct order.
To do it use ufw insert command


```bash
  sudo ufw insert [NUMBER] [COMMAND]
  sudo ufw insert 1 deny from 10.0.0.37
```

To define deny outgoing packets we do sth similar by:
```bash
     sudo ufw deny out on [INTERFACE] to [IP_ADDRESS]
     sudo ufw deny out on enp0s3 to 8.8.8.8
```


More advanced command:
```bash
     sudo ufw allow in on en0s03 from 10.0.0.192 to 10.0.0.100 proto tcp #incoming rule
     sudo ufw allow out on en0s03 from 10.0.0.100 to 10.0.0.192 proto tcp #outcoming rule
```


# 3
> Port redirection and Network Address Translation (NAT)


Port redirection.
Some networks are not publicly accessable from the internet. Thats why we need port redirection


```
                                                         Internal Network
                                             |------->      Server1
Internet -------> Publicly Accessible server |------->      Server2
                                             |------->      Server3
```
And on Publicly Accessible server we will have ports that will be listening for incoming traffic
and will be redirecting the requests to the right servers on the internal network

Teraz po polsku przedstawie na czym dokładnie polega NAT na podstawie przykładu powyżej

1. Komputer w sieci lokalnej (192.168.1.2) chce uzyskać dostęp do strony internetowej na serwerze 198.51.100.7.

2. Komputer wysyła pakiet z żądaniem HTTP do serwera. Pakiet ten ma:
- Źródłowy adres IP: 192.168.1.2 (prywatny adres IP komputera).
- Docelowy adres IP: 198.51.100.7 (publiczny adres IP serwera).
3. Pakiet dociera do routera. Router działa jako brama między twoją siecią lokalną a Internetem.

4. NAT w routerze modyfikuje pakiet:
- Router zmienia adres źródłowy pakietu z 192.168.1.2 na swój publiczny adres IP 203.0.113.5.
- Router zapisuje informację o translacji, aby wiedzieć, do którego urządzenia w sieci lokalnej przesłać odpowiedź z serwera.

5. Pakiet opuszcza router i wchodzi do Internetu z publicznym adresem IP 203.0.113.5.

6. Publiczny serwer 198.51.100.7 otrzymuje pakiet, widzi jako adres źródłowy 203.0.113.5 (adres twojego routera), a nie 192.168.1.2.

7. Serwer odsyła odpowiedź na publiczny adres IP 203.0.113.5 (adres twojego routera).

8. Router odbiera odpowiedź, a dzięki zapisanej informacji o translacji wie, że ten pakiet należy przesłać z powrotem do komputera 192.168.1.2 w prywatnej sieci lokalnej.

9. Router modyfikuje pakiet (przywracając oryginalny adres źródłowy) i przesyła go do komputera w sieci lokalnej.


### How to set up port redirection ?
We have to enable IP forwarding because it is disabled by default
> /etc/sysctl.conf

and change this line:
```bash
#
# Do not send ICMP redirects (we are not a router)
#net.ipv4.conf.all.send_redirects = 0
#
```

Or change this file:
> /etc/sysctl.d/99-sysctl.conf

And change these lines:
```bash
#net.ipv4.ip_forward=1
#net.ipv6.conf.all.forwarding=1

and run sudo sysctl system
```

The command in terminal for the port redirection:
Ta komenda przekierowuje cały ruch TCP i UDP, który przychodzi do interfejsu enp1s0 z sieci 10.0.0.0/24 na port 8080, na serwer wewnętrzny o adresie IP 192.168.0.5 na port 80.
```bash
     sudo iptables -t nat -A PREROUTING -i enp1s0 -s 10.0.0.0/24 -p tcp -p udp --dport 8080 -j DNAT --to-destination 192.168.0.5:80
```

iptables: Narzędzie służące do konfiguracji zapory sieciowej (firewall) w systemie Linux.

-t nat: Wskazanie, że modyfikujemy tablicę nat (Network Address Translation), która jest używana do translacji adresów IP.

-A PREROUTING: Dodanie (-A od "Append") reguły do łańcucha PREROUTING, który przetwarza pakiety zanim zostaną one przekierowane do odpowiedniego interfejsu sieciowego. Reguły w PREROUTING są stosowane do wszystkich pakietów przychodzących.

-i enp1s0: Określenie interfejsu sieciowego, na którym reguła ma być stosowana. W tym przypadku jest to enp1s0.

-s 10.0.0.0/24: Źródłowy adres IP lub zakres adresów (w notacji CIDR). Reguła będzie stosowana tylko do pakietów pochodzących z sieci 10.0.0.0/24.

-p tcp -p udp: Określenie protokołów, które mają być objęte tą regułą. W tym przypadku są to zarówno tcp, jak i udp.

--dport 8080: Określenie docelowego portu, na który przychodzące pakiety mają być skierowane. Reguła ta dotyczy portu 8080.

-j DNAT: Wskazanie celu reguły (-j od "jump"). DNAT (Destination Network Address Translation) oznacza, że docelowy adres IP w przychodzących pakietach zostanie zmieniony na inny.

--to-destination 192.168.0.5:80: Określenie nowego docelowego adresu IP i portu, na który mają być przekierowane pakiety. W tym przypadku pakiety kierowane na port 8080 zostaną przekierowane na adres 192.168.0.5 i port 80.



### Reverse Proxies and Load Balancers



> Reverse Proxies

We have a situation like this in the internet:
```bash
                     ------------>                <---------
User (Web Browser)   <------------  Reverse Proxy ---------> Web Server

```
This reverse Proxy have multiple advantages.
Transition of the new web servers are much easier. We can build a new web server and then just tell the reverse proxy
to use this new one from now on. We dont have to switch off our resources

Other advantages of REverse PRoxies are:
- Caching pages
- Filtering Web Traffic


### Creating Reverse Proxies

Czym jest nginx?
- Został zaprojektowany z myślą o obsłudze dużych ilości jednoczesnych połączeń przy minimalnym wykorzystaniu zasobów systemowych, co czyni go popularnym wyborem wśród administratorów systemów i programistów.

Reverse Proxy: Nginx może działać jako reverse proxy, co oznacza, że przyjmuje zapytania od klienta (np. przeglądarki internetowej) i przekazuje je do jednego lub więcej serwerów aplikacyjnych w backendzie. Jest to przydatne w celu równoważenia obciążenia między serwerami (load balancing) oraz ochrony wewnętrznej infrastruktury.

Load Balancer: Nginx może równomiernie rozdzielać ruch pomiędzy wiele serwerów, co zwiększa skalowalność aplikacji i zapewnia ciągłość działania nawet w przypadku awarii jednego z serwerów.


To create it we have to:
- use sudo apt install nginx
- And then create 
- edit file: sudo vim /etc/nginx/sites-available/proxy.conf

``` bash
 server {
	listen 80;

	location /images {
		proxy_pass http://1.1.1.1:8081
	}
}
```

"location /images" : This enables a reverse proxy to the request that contains /images in its url
example.com/images/dog.jpg    ---> ACCEPTS
example.com/videos/cat.mp4    ---> DOES NOT ACCEPT



"proxy_pass http://1.1.1.1": if the request matches the location directive it will be proxied to the web server
specified here. We can Use here a hostname/domain name or IP address

But defining this file in /etc/nginx/sites-available/proxy.conf is not enough to make it available right away.
We have to enable it in /etc/nginx/sites-enabled/... .
To do so we can create a link:
```bash
     sudo ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
     
     #And disable the current webserver configuration:
     #But dont worry - this file is also a soft link, which has its template in a different place
     #So removing it by rm command does not mean we will get rid of it permanently or we will loose it somehow
     sudo rm /etc/nginx/sites-enabled/default 
     
     
     sudo nginx -t #This tests if everything is fine
     sdo systemctl reload nginx.service
```

> Load Balancers

Let us redirect the traffic to different web servers to split up a work so every web server is not over-used.

```bash
                     ------------>                 ---------> Web Server 1
User (Web Browser)   <------------  Load Balancers ---------> Web Server 2
                                                   ---------> Web Server 3

```

### Creating Load Balancers

```bash
     sudo rm /etc/nginx/sites-enabled/proxy.conf  #To remove previous configurations of reverse proxies
     sudo vim /etc/nginx/sites-available/lb.conf  #A file where we will define a load balancer

```


```
upstream mywebservers{
     least_conn;
     server 1.2.3.4 weight=3;
     server 5.6.7.8 down;
     server 9.10.11.12 backup;
     server 13.14.15.16:8080
     server 17.18.19.20
}

server {
     listen 80;
     location / {
          proxy_pass http://mywebservers;
     }
}
```

This is similar to the configuration of reverse proxy, but we first define which servers it should forward the traffic to.
Now if we want to imply this config. we have to continue the same steps as with reverse proxies.

```bash
     sudo ln -s /etc/nginx/sites-available/lb.conf /etc/nginx/sites-enabled/lb.conf
     
     #And disable the current webserver configuration:
     #But dont worry - this file is also a soft link, which has its template in a different place
     #So removing it by rm command does not mean we will get rid of it permanently or we will loose it somehow
     sudo rm /etc/nginx/sites-enabled/default 
     
     
     sudo nginx -t #This tests if everything is fine
     sdo systemctl reload nginx.service
```



### Set and synchronize System TIme USing Time Servers

All the devices are using sth called Time servers. In reality its is Network Time Protocol 'NTP'

```bash
     sudo timedatectl set-timezone America/Los_Angeles
     sudo timedatectl set-timezone Europe/Warsaw
     
     timedatectl #Prints current timezone and local time, itp
     systemctl status systemd-timesyncd.service #Checks if our ntp server is running
```

TO edit it we can edit this file:
```bash
     ssudo vim /etc/systemd/timesyncd.conf
```
We can specify which ntp server we would like to use 




### SSH

SSH Client:
- Co to jest: Klient SSH to oprogramowanie uruchamiane na komputerze, z którego użytkownik chce połączyć się z innym komputerem (serwerem SSH). Przykładami klientów SSH są OpenSSH, PuTTY (na Windows) oraz ssh (komenda w terminalu Linux/MacOS).
- Funkcja: Klient SSH inicjuje połączenie z serwerem SSH, wprowadza dane logowania użytkownika (np. nazwę użytkownika i hasło lub klucz SSH) i po uzyskaniu dostępu pozwala użytkownikowi na zdalne zarządzanie serwerem, tak jakby był przed nim fizycznie.
Sciezka do pliku na linuxie: 
```bash
     sudo vim /etc/ssh/ssh_config
```


SSH Server:
- Co to jest: Serwer SSH to oprogramowanie działające na komputerze, który udostępnia swoje zasoby do zdalnego zarządzania przez klienta SSH. Popularnym serwerem SSH jest OpenSSH, który działa na systemach Linux i Unix oraz na Windowsie (od wersji 10).
- Funkcja: Serwer SSH nasłuchuje na określonym porcie (zazwyczaj port 22) i czeka na przychodzące połączenia od klientów SSH. Po nawiązaniu połączenia, serwer autoryzuje użytkownika na podstawie danych logowania, a następnie udostępnia dostęp do systemu.
  Sciezka do pliku na linuxie:
```bash
      sudo vim /etc/ssh/sshd_config
```

Jezeli chcemy wprowadzac jakies zmiany dla clienta warto po prostu dodac nowy plik konfiguracyjny, ktory mialby teoretycznie
nadpisac te rzeczy ktore mamy zdefiniowane. Umieszcza sie je w :
```bash
     sudo vim /etc/ssh/ssh_config.d/[NAME_OF_OUR_FILE]
```

Fajnym/Waznym aspektem jest wlaczanie logowania tylko za pomoca ssh keys.

ssh-keygen     - generowanie klucza
Pozniej ten klucz jest widoczny i dostepny w /home/krpia/.ssh/[NAZWA_KLUCZA]

Ale zeby sie zalogowac na serwer za pomoca klucza ssh, musimy
1. skopiowac ten klucz na nasz serwer za pomoca: ssh-copy-id [NAZWA_SERWERA] (klucze po stronie serwera sa zdefiniowane w /home/kacper/.ssh/authorized_keys)

