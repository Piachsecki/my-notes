# Exam from Oreily website


checked
1. Use the appropriate command to locate all files on your system with a size
   bigger than 100 MiB and write the result of that command to the file
   /tmp/bigfiles


```shell
    sudo find / -type f -size +100M 2>/dev/null | sudo tee /tmp/bigfiles
```
checked
2. Create a hard link in user root home directory with the name bigfiles that
   links to the file created in the previous step 

```shell
    sudo ln /tmp/bigfiles root/rootbigfiles
```

3. Set defaults for all new users such that passwords have a maximum validity
   of 90 days
checked - first idea better
```shell
   #1 IDEA -> edit /etc/logins.def file and line:
   # PASS_MAX_DAYS   99999 to 90 and save the file
   
   
   #2 IDEA -> run some script
   sudo cat /etc/passwd | awk -F ':' '{print $1}' | while read user; do
   > sudo chage -E 90 "$user"
   > done
```

checked
4. When creating new users, copy an empty file with the name data to their
   home directory

```shell
   #put an empty file in /etc/skel/ directory ? 
```


5. Adda secondary disk to server1. On this disk, create an LVM volume group
   vgexam with a size of 2 GB. The volume group should use two physical
   volumes that are created as partitions on the secondary disk you've added 
   * Inthe vgexam volume group, create a logical volume with the name
   lvexam. Format it with the Ext4 file system and mount it persistently on
   /exam
   * Copy all files with a size greater than 1 MB from the /etc directory to the
   new volume which is mounted on /exam

sprawdzone -> dobrze
```shell
   #NIe rozumiem: add secondary disk to server1
   #zakladam ze mamy juz ten dysk i partycje na nim gotowe do dziala
   
   sudo cfdisk /dev/sec #And create 2 partitions for 1GB
   sudo pvcreate /dev/sec1 /dev/sec2
   sudo vgcreate vgexam /dev/sec1 /dev/sec2
   sudo lvcreate --name lvexam vgexam
   sudo mkfs.ext4 /dev/vgexam/lvexam
   
   #Enter the /etc/fstab file
   # /dev/vgexam/lvexam /exam ext4 defaults 0 2
   
   sudo find /etc/ -size +1MB -type f -exec cp -f {} /exam \;

```


6. Schedule a tasks that writes the text "good morning" to the default system
   logging system every day at5 AM Ensure this task runs as user bob. Create this user if necessary


```shell
   sudo crontab -u bob -e
   # 0 5 * * * echo "good morning" | logger
   
   
   DEFAULT SYSTEM LOGGIN SYSTEM -> LOGGER


```


7. Create the file /tmp/protectedfile, containing the text "| am protected".
   Ensure this file can be added to, but not removed, and current contents
   cannot be changed 

```shell
    echo 'I am protected' > /tmp/protectedfile
   #Nie pamietam jaki parametr w setfacl odpowiadal za te rzeczy ale pamietam
   #ze uczylem sie czegos takiego
   
   sudo chattr +a /tmp/protectedfile
```

8. Start a container based on the docker.io/library/nginx:latest image, and
ensure it meets the following requirements .
The container is started by the root user
The container main application can be reached on localhost port 8080
An environment variable is set as type=webserver
The container is started as a background process
Within the container, a directory /data is presented. All files written to that
directory are mapped to /root/data 


```shell
  sudo docker run -d -p 8080:8080 -v /root/data:/data -e type=webserver docker.io/library/nginx:latest

  # Nie wiem jak zrobic to: Within the container, a directory /data is presented. All files written to that
  # directory are mapped to /root/data 
  
  za to odpowiada -v 
```

9. Create a systemd unit that runs the sleep infinity command. The unit
   should be enabled in the multi-user.target and run with an adjusted
   priority, giving it a lower priority than any other running process 

```shell
   #Nie pamietam gdzie powinno sie definiowac wlasne serwisy,
   #ja bym chyba postaral sie to zrobic pod sciezka /etc/systemd/system/
   # i potem zrobic sudo systemctl [name_of_the_service]
   
   #znalazlem w dokumentacji w man systemd.service:
   [Unit]
           Description=My service

   [Service]

   [Install]
           WantedBy=multi-user.target


   # pozniej jak to stworzymy to mozemy sudosystemctl start [name_of_the_service]
   sudo systemctl start [name_of_the_service]
   
   # teraz zobaczyc process id od tego serwisu
   sudo systemctl status [name_of_the_service]
   
   #sprawdzic nice values wszystkich procesow
   sudo renice -n -20 -p [PROCESS_ID]
```

odpowiedz koncowa: 

```shell
sudo nano /etc/systemd/system/sleep-infinity.service


[Unit]
Description=Run sleep infinity command

[Service]
ExecStart=/bin/sleep infinity
Nice=19
# Optional: Limit CPU and memory usage if needed
# CPUQuota=10%
# MemoryMax=100M

[Install]
WantedBy=multi-user.target

sudo systemctl daemon-reload
sudo systemctl start sleep-infinity.service


```


checked
10. Create a file that contains a list of all files on your system that have the
    SUID permission set. Call it /root/suid-files-base.txt 

```shell
   sudo find / -perm /u=s -type f 2>/dev/null  > /root/suid-files-base.txt 
```


11. Add the file /tmp/runme, and ensure it has SUID as well as execute
permissions 

checked
```shell
   sudo touch /tmp/runme
   sudo chmod u+sx
   
   # male s -> bit x jest ustawiony
   # duze S -> bit x NIE jest ustawiony
```


12. Run the appropriate command to create a file that contains a list of all files on your system that have the SUID permission set. Call it /root/suid-filesdd-mm-yyyy.txt, where "dd-mm-yyyy" should be automatically set to the
    date on which this command is run

```shell
# Po dlugich bojach ale udalo sie samodzielnie
   sudo find / -type f -perm /u=s > /root/suid-file"$(date +%d-%m-%Y)".txt
```


checked
13. Generate a scheduled job that will automatically do this once a day 

```shell
   # Cronjob?
   sudo crontab -e
   # 0 12 * * * sudo find / -type f -perm /u=s > /root/suid-file"$(date +%d-%m-%Y)".txt
```


14. Add anew disk to your system, with a size of 10 GiB. On this disk, create a
    GPT partition with a size of 2 GiB, and mount it by UUID on the directory
    /files. Ensure that this mount is happening automatically, but only through a systemd mount unit. 
    The mount should not be included in /etc/fstab 

```shell
   # Lets act as we have disk already prepared and we have to create partition on it
   sudo cfdisk /dev/vdb #And create a 2 GiB on this partition
   
   blkid | grep '/dev/vdb' # take the UUID of the partition
   
   # Ensure that this mount is happening automatically, but only through a systemd mount unit.
   # I have no clue what does it mean -> I would do it in /etc/fstab

```

solution:


```shell

sudo vim /etc/systemd/system/files.mount

[Unit]

    Description=Mount 2 GiB Partition

    After=network.target

[Mount]

    What=/dev/disk/by-uuid/1234-ABCD

    Where=/files

    Type=ext4

    Options=defaults

[Install]

    WantedBy=multi-user.target

and then sudo systemctl daemon-reload

sudo systemctl enable files.mount
```

checked
15. Create a swap file with the name /swapfile and ensure it is activated
    automatically when booting. Configure the appropriate sysctl parameter tc set the system preference for swapping out data on memory shortage to
    the value 70 

```shell
    sudo fallocate -l 10MB /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    
    #and how to make it persistent just for a file ? - tak mozna po prostu mountpoint sie wpisuje none
    sudo vim /etc/fstab
    # /swapfile none swap sw 0 0
    
    
    ##swappiness determines how aggressively the kernel will swap memory pages. The value ranges from 0 to 100:
    #0 means the kernel will avoid swapping as much as possible.
    #100 means the kernel will swap aggressively.
    sudo nano /etc/sysctl.conf
    vm.swappiness=70
    sudo sysctl -p

```

checked
16. Set the hostname of your computer to examhost.example.local. Ensure
that this name resolves to your computers primary IP address 
```shell
   #Wydawalo mi sie ze powininem zobaczyc plik /etc/hosts + /etc/hostname aby zobaczyc jaki jest adres IP naszego computera
   #i teraz w pliku /etc/hosts dodac:
   #127.0.1.1 examhost.example.local
   
   no niby dobrze to co napisalem ale jednak inaczje
    1. edytuj plik /etc/hostname na taki jaki powinien byc
    2. edytuj plik /etc/hosts tak zeby nasz nowo ustalony hostname matchowal 127.0.0.1
```

17. Write a script that meets the following requirements:
* The script should prompt the user to enter a color. The name of this color
  should be stored in a variable
* The script should loop in such a way, that every 10 seconds, it will prompt the
  message "the color is ..." on screen. Ensure that instead of “...” the actual color name is printed
* Start this script in a way that it takes a lower priority than other processes
  running on your computer 

```shell
    #!/bin/bash
    read -p 'Enter the color' COLOR
    while true; do
      sleep 2
      echo "YOur color is $COLOR"
    done
    
    nice -n 10 ./color_prompt.sh

```



18. Configure the Systemd Journal in such a way that it is stored persistently 



19. Set up your system such that direct login by the user root is only allowed
    on tty3. Ensure this requires your root user to be able to log in with a
    password

```shell
   #Wydawalo mi sie ze tutaj trzeba zeedytowac sudo visudo
   
```


20. ssh to the given machine and find out the process on the mounted
    volumes where there is high consumption of resources. I knew to check
    for the mounted volumes so I did


21. Create a volume group for a physical volume & Create a lv named ly-data
    and extend it by 0.2 G. Format this volume using ext4 filesystem.