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
