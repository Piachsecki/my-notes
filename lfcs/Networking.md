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