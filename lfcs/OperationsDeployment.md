# LFCS - Operations Deployment

> Topic for Operations Deployment commands and knowledge

## Terms

# 1


### Init System 
a feature which start up applications/boot up system and know what to do when program crashes. Is buil of Systemd files.
### Systemd files 
text file that describes the necessary logic. It is a collection of services/sockets/devices and timers. - these are called units. Responsible for system initialization
### Service
what program should do when program crashes. everything connected with: HOW IT SHOULD MANAGE the application
Timer - run sth in example in database every 2 weeks
```bash
  man systemd.service #to read about systemd.service
  sudo systemctl status #lists all of the services in a working system
  sudo systemctl status ssh.service #prints all of the informations about this exact service

  sudo systemctl stop ssh.service #manualy stops a service
  sudo systemctl start ssh.service #manually starts a service

  sudo systemctl restart ssh.service #restarts to reload program settings - might cause problems for the users currenttly using this service
  sudo systemctl reload ssh.service #gentle way for the uper command


  sudo systemctl enable ssh.service #worzy odpowiednie dowiązania symboliczne w systemie, które informują system, że usługa SSH powinna być uruchamiana automatycznie podczas bootowania.
  sudo systemctl disable ssh.service #nie bedzie juz dostepna po zbootowaniu
```

Ale zeby uzywac tych komend wyzej to najpierw trzeba:
- sudo systemctl enable ssh.service - Wlaczyc serwis podczas wystartowania
- sudo systemctl start ssh.service - Wlaczyc ten serwis


```bash
  sudo systemctl enable --now ssh.service
  ==
  sudo systemctl enable ssh.service
  sudo systemctl start ssh.service 
```

Often it happens that one service starts another service which starts another and so on...
To prevent this domino effect we are using masks.
```bash
  sudo systemctl mask atd.service #To powoduje ze ten serwis nie moze zostac started/enabled
  sudo systemctl unmask atd.service
```

## Creating our own systemd service

### Why?
We want our application to work all the time, but if it crashes we are f..ed. Thats why we neet to monitor this app and restarts it when it fails.

```bash
  sudo systemctl mask atd.service #To powoduje ze ten serwis nie moze zostac started/enabled
  sudo systemctl unmask atd.service
```

### Creating it by urself
If u want to create it, take the syntax of these files from:
```bash
  /lib/systemd/system/{name_of_the_service}
```
and save it at:
```bash
  /etc/systemd/system/{my_app.service}
```

then u have to reload daemon:
```bash
  sudo systemctl daemon-reload
  sudo journalctl -f #Prints the logs of services
```


# 2

## Dignose and Manage Processes

ps aux - display all the processes AT THIS EXACT MOMENT
ax - all processes - auxilary
u - user oriented format (memory + cpu, which user itp)


when we display these processes we get different columns, but if the COMMAND column the processes that comes from linux kernel are displayed in this format: [kththread]
, where normal processes (in the user space) are displated like this: /sbin/init


top - displays processes that are changing at the time too
THe most CPU Intense are on the top


Processes have sth like process 'niceness'. The lower the number the less nice it is.
Low number means that this process is higher in rank then the other and has priority to run amongst other processes

To setup a 'niceness' we have to specify this by command:
```bash
  nice -n [NICE VALUE] [COMMAND]
  nice -n 11 bash
  ps l #l prints BSD long format, where under column 'NI' we can see niceness of the process
```
or change the value:

```bash
  renice [NEW NICE VALUE] [PID]
  renice 7 12238
```

Normaly without root priviliges YOU CANNOT assign lower niceness.


This processes inherit niceness from their parents. To see the tree of this 'family' enter:

```bash
  ps faux
```




We can connect/contact our processes with commands: SIGKILL and many more, by typing:
```bash
  kill -L #to display all of the commands that can be used to interact with processes

  sudo kill -[COMMAND] [PID] # executes the command on the process
```


Pretty often when u want to change background you click - CTR+C. Which exits/stops the app, but we can use CTR+Z to STOP the app.
By clicking fg in terminal we can come back to the process that was stopped

By adding '&' to the process like this:

```bash
  sleep 123123 & #This process will be done in the background!
  jobs #Display jobs that are run/stopped in the background
```


We can see where this process is being used, by typing:

```bash
  lsof -p [PID]
  lsof -p 13536
```


## Locate and analyze System Log Files

the path where the logs are stored: /var/log


We can track who logs in and logs out for example by using the flag: -F
```bash
  tail -F /var/log/auth.log #Opens the current logs, but when new user logs it automatically shows it too
```

But we can analyze log files more efficiently by using journalctl. Let us filter for lgos generated by a specific command

```bash
  which sudo
  journalctl /usr/bin/sudo
  
  #Or if we know the name of the service that generates logs we can use:
  journalctl -u ssh.service
```

The logs have 4 different 'usages', which we can specify and see:
- info
- warning
- err
- critt

And we can specify which logs by which 'usage' we would like to see, by typing:
```bash
  journalctl -p err

  #We can also specify a grep - by which regular expression we can filter even more the output
  journalctl -p err -g '^b'

  #we can specify the time in which we would like to see our logs: -S since -U until
  journalctl -S 1:00 -U 02:00


  #we can specify that we would like to display logs from this current boot
  journalctl -b 0
  #previous boot -b -1, 2previous boots -b -2
```
Normaly the logs with the utility journalctl are not saved ANYWHERE in the system as /var/log/...
But if we decide to create the folder for that, by: sudo mkdir /var/log/journal/
We will be able to see logs


We can see the last logins by users by typing:
last

or to the the last logs created by
lastlog


# 3 Here I lost my notes due to unexpected crash
Notes missing: Package MAnager/Repositories/running program by source code


# 4
> Availability and Integrity of Resources and Processes

tmpfs - virtual file systems that only exists in the computer's memory NOT ON storage devices


```bash
  df -h #Prints the disk free, how much soace is used everywhere. h - human readable format
  du -su #du - Disk usage utility. It is used to see how much 1 specified folder takes space(-s option). Without -s we would see this directory with the other subdirectories that also use this path

  free -h

  uptime # Gives us the cpu used in the past: 1min, 5min, 15min (this data is displayed right after load average: ...)

  lscpu  #Prints the information about the cpu's
```
If the data displayed in uptime after load average: 0.2, 2.3, 4.5 Exceeds the data displayed in lscpu-> It is an information that we have to change our servers cpu.


```bash
  systemctl list-dependencies #Show all services that are active/inactive
  systemctl status [service_we_want_to_check]
  systemctl status atd.service #Prints the reason of being active/inactive?

  #But we can see for example all of the logs that are being generated by service, by typing:
  journactl -u [service_to_see]
  journalctl -u ssh.service
```

### Integrity of FIle Systems
File systems are at ubuntu default in format ext4. To check this file systems for errors we have to unmount them first

- System plików (File System): Jest to struktura, która przechowuje i organizuje dane na dysku twardym lub innym urządzeniu pamięci masowej.

- Sprawdzanie systemu plików (Checking File System): Polega na skanowaniu i wykrywaniu ewentualnych błędów lub niespójności w systemie plików. Narzędzie fsck (file system consistency check) jest często używane w tym celu.

- Odmontowanie (Unmounting): Oznacza to odłączenie systemu plików od systemu operacyjnego, co powoduje, że pliki w tym systemie plików nie są już dostępne dla użytkowników i procesów systemowych.

Przykład użycia:
sudo umount /dev/sda1
sudo fsck /dev/sda1

```bash
sudo umount /dev/sda1
sudo fsck /dev/sda1
```


# 5
> Change Kernel RUntime Parameters, Persistent and Non-Persistent


Kernel RUntime Parameters - fancy description of what linux kernel does jobs internally.
It is moslty low level stuff - like allocating memory, handling network traffic, itp.
```bash
  sudo sysctl -a #PRints all the runtime parameters
```
THis is the output of this command and
- vm - memory related stuff - virtual memory
- net - network stuff
- fs - file system setting
- 0 = false
- 1 = true
```bash

vm.numa_zonelist_order = Node
vm.oom_dump_tasks = 1
vm.oom_kill_allocating_task = 0
vm.overcommit_kbytes = 0
vm.overcommit_memory = 0
vm.overcommit_ratio = 50
vm.page-cluster = 3
vm.page_lock_unfairness = 5
vm.panic_on_oom = 0
vm.percpu_pagelist_fraction = 0
vm.stat_interval = 1
sysctl: permission denied on key 'vm.stat_refresh'
vm.swappiness = 60
vm.unprivileged_userfaultfd = 1
vm.user_reserve_kbytes = 60063
vm.vfs_cache_pressure = 100
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 10
vm.zone_reclaim_mode = 0```
```

To change the values of the parameters we type:
```bash
  sudo sysctl -w [parameter_name=0/1]
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 # -w - write

  #But it is only set for this boot if it restart our system it comes back to the previous value
```
To make persistent changes we have to change/create /etc/sysctl.d/filename.conf file

THIS FILES HAVE TO END WITH .conf extension

sudo nano/vim /etc/sysctl.d/swap-less.conf
and now set it
vm.swapiness=20

OR
we can update the /etc/sysctl.conf file
and now set it
vm.swapiness=20

But this parameter will be seen and will be persistent from the next boot, to make it available now we have to type:
```bash
  sudo sysctl -p /etc/sysctl.d/swap-less.conf
  #or default
  sudo sysctl -p #It automatically takes etc/sysctl.conf this file
```



### List and Identify SELinux FIle and Process Contexts
Currently the read/write/execute priviliges are not enough for the cyber attacks, so linux kernel provides SELinux that give us advanced access restriction.

To check SELinux Contexts we have to type:
```bash
  ls -Z
```
This Security context are always displayed in the same format:

unconfined_u  :  object_r  :  user_home_t  :  s0
user             role         type            level

- user - every user that logs into a linux system is mapped to an SE Linux user
- role - each user can only assume predefined roles
- type - 
- level - almost never accessed 

By checking this fields in this order we can get granted pros:
- 1. ONly certain users can enter certain roles and then certain types
- 2. It lets authorized users and processes do their job, by granting the permissions they need
- 3. Authorized users and processes are allowaed to take only a limited set of actions


We can see that processes have their SELinux Contexts too. To see their 'roles' type:
```bash
  ps axZ

```

anything labeled with unconfined_t - is running unresstricted - processes can do whatever they want


to see the users SELinux roles and type enter:
```bash
  id -Z
  #or
  sudo semanage login -l #To see what will be added to a user that logs in
  sudo semanage login -l #Let us to see which roles we can assign to users
```

### Create and Enforce MAC using SELinux
In ubuntu by default App Armor is enabled instead of SELinux. We have to then check if it is already installed/ or install and configure it on our own
```bash
  sudo systemctl stop apparmor.service
  sudo systemctl disable apparmor.service
  sudo apt install selinux-basics auditd

  #Now after we installed it we have to configure it to tell the linux kernel to use it
  sudo selinux-activate    #Naprawia jakby pliki i foldery zeby mialy odpowiednie labele, po tym musimy bootnac nasz system
  reboot



  #Now after our system reboots we have the proper file structure that looks like this:
  ls -Z /

```
      system_u:object_r:bin_t:s0 bin                  system_u:object_r:proc_t:s0 proc
         system_u:object_r:boot_t:s0 boot        system_u:object_r:user_home_dir_t:s0 root
       system_u:object_r:device_t:s0 dev               system_u:object_r:var_run_t:s0 run
          system_u:object_r:etc_t:s0 etc                   system_u:object_r:bin_t:s0 sbin
    system_u:object_r:home_root_t:s0 home              system_u:object_r:default_t:s0 snap
          system_u:object_r:lib_t:s0 lib                   system_u:object_r:var_t:s0 srv
          system_u:object_r:lib_t:s0 lib32             system_u:object_r:default_t:s0 swap.img
          system_u:object_r:lib_t:s0 lib64               system_u:object_r:sysfs_t:s0 sys
          system_u:object_r:lib_t:s0 libx32                system_u:object_r:tmp_t:s0 tmp
   system_u:object_r:lost_found_t:s0 lost+found            system_u:object_r:usr_t:s0 usr
          system_u:object_r:mnt_t:s0 media             system_u:object_r:default_t:s0 vagrant
          system_u:object_r:mnt_t:s0 mnt                   system_u:object_r:var_t:s0 var

and sestatus command gives us the enabled status

Wyrozniamy 3 rozne typy dla SELinux: (mozemy zobaczyc aktualny tryb za pomoca komendy getenforce)
- Enforcing (Wymuszający) - W tym trybie SELinux egzekwuje polityki bezpieczeństwa. Oznacza to, że wszelkie działania, które naruszają politykę, są blokowane.
- Permissive (Dopuszczający) - W tym trybie SELinux nie egzekwuje polityk bezpieczeństwa, ale nadal monitoruje system i rejestruje wszelkie działania, które naruszałyby politykę, gdyby był w trybie enforcing.
- Disabled (Wyłączony) - W tym trybie SELinux jest całkowicie wyłączony, co oznacza, że nie monitoruje ani nie egzekwuje żadnych polityk bezpieczeństwa.
```bash
  sudo setenforce 1 #Activates Enforcing Mode, but it sets it up only in this boot, if we reboot it comes back to permissive
  sudo setenforce 0 #Activates Permissivee Mode


  #To set it up persistently, we have to modify /etc/selinux/config
```

To see the logs type:
```bash
  sudo audit2why --all  #It shows us the logs in for example permissive stage, where sth would be restricted/denied, but it is not because we are in permisse state
```


To change for example the user in SELinx of some file we can do it by the command:
```bash
  sudo chcon -u unconfined_u /var/log/auth.log
```

To change the role:
```bash
  sudo chcon -r object_r /var/log/auth.log
```
To change the type:
```bash
  sudo chcon -t user_home_t /var/log/auth.log
```

To list all available users predifned for SELinux we can check by:
```bash
  seinfo -u # for users
  seinfo -r # for  roles
  seinfo -t # for types

  sudo chcon --reference=/var/log/dmesg /var/log/auth.log #Sets everything for auth.log like it is in dmesg - roles/users/types

```

We can automatically set the proper types for the files written in specific directories

```bash
  sudo restorecon -R /var/www/ #It automatically changes all of the files in this directory to the types that linux find the most applicable in here

  sudo restorecon /var/www/10 #Comes back to default types for this exact type
```
# 6
> Docker && VM's


We are going to use VIRSH and KME

First install all the packages that are required.
We have multiple ways to start/create the vm, but the one we are going to use is
through XML file.
1. Create a .xml file that looks like:

```html
 <domain type='qemu'>
    <name>TestMachine</name>
    <memory unit="GiB">1</memory>
    <vcpu>1</vcpu>
    <os>
        <type arch="x86_64">hvm</type>
        <boot dev='cdrom'/>
    </os>
</domain>

```
2. Then we will use the command to create this vm
```bash
    virsh define testmachine.xml
```

3. Now we can see this domain by virsh list -all
4. NOw we can start the machine: virsh start TestMachine
5. We can now reboot it by virsh reboot TestMachine
6. virsh reset TestMachine
7. virsh shutdown TestMachine 
8. virsh destroy TestMachine - it is like unplugging it but not destroing
To destroy a VM machine, we have to use the command:
```bash
    virsh undefine testmachine.xml #So pretty similar to the one that is being used during starting
  
    virsh dominfo TestMachine # Let us see the basic info of this vm
    
    virsh setvcpus TestMachine 2 --config
    
    #Basically use man virsh / virsh --help to see all the options and to get familiar with it
```

### Create and Boot VM

We can now boot a vm, by UBUNTU img.
1. Download the image. Afterwards we can check the checksums of the file downloaded to check
if everything downloaded successfully. First download SHA256SUMS.gpg form UBUNTU webpage and then
you can type in the folder where you are an image downloaded:
```bash
    sha256sum -c SHA256SUMS 2>&1 | grep OK #If it returns sth else than 'OK', you have to redownload the img
```

2. To modify this image- to for example change the space on this image we can do it by
```bash
    qemu-img [COMMAND] img
    qemu-img info [].img
    qemu-img resize [].img 10G
```
3. Now we can change the path of this img to the proper location - /var/lib/libvirt/images/ directory
```bash
    sudo cp [].img /var/lib/libvirt/images/
```
4. Now we can install it by virt.
```bash
    virt-install --osinfo ubuntu24.04 --name ubuntu 1 --memory 1024 --vcpus 1 --import --disk 
    /var/lib/libvirt/images/[].img  --graphics none
```
