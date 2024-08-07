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
