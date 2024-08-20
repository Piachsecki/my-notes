

## 1.
Open the file under
   /home/student/textreferences/editme.txt and
   complete the following tasks:
   - Move line 7777 to line 1.

   - Remove line 7000.

   - Replace every occurrence of the word Earth shown with an uppercase E, with the word Globe.

   - Add a new line at the very end of the document that
   contains Auctores Varii.

## Solution

vim /home/student/textreferences/editme.txt
ESC + :7777 + ENTER + dd + ESC + :1 + ENTER + P

ESC + :7000 + ENTER + dd

sed -i 's/Earth/Globe/g' /home/student/textreferences/editme.txt

this one is not clear for me (I would go to vim, go to the end line, look for this text and add ENTER or /n)



## 2.
Create a bash shell script named certscript.sh under
/home/student/apps/.
- Make sure the script can be invoked as
./certscript.sh.
- The first line of output from the script should consist of the
name of the user who invoked it.
- The second line of output should contain the IP address
of the default gateway.

## Solution


vim /home/student/apps/certscript.sh

```shell
#!/bin/bash

whoami

ip route show | egrep -o '[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}' | head -n 1
```


sudo chmod 700 certscript.sh


./certscript.sh


## 3.
Install the tmux package on your system.

## Solution

sudo apt search tmux

sudo apt install tmux


## 4.  didnt know how to solve(we can use shell built ins such as this $(...) structure that we learned already)

Create a cron job that kills all processes named
scan_filesystem which is owned by root, every minute.

## Solution

crontab -e 
```shell

1 * * * * kill $(pgrep -u root scan_filesystem)
```

## 5.

Linux administrators are responsible for the creation, deletion,
and the modification of groups, as well as the group membership.
Complete the following tasks to demonstrate your ability to create
and manage groups and group membership:
1. Create the computestream group.
2. Create a computestream folder in /exam/.
3. Make the computestream group the owner of the
   /exam/computestream folder.

## Solution didnt know how to solve(chown command)


sudo groupadd computestream


mkdir /exam/computestream/


cat /etc/computestream | grep computestream #Wez teraz gid tej grupy

now we should use the command with chown


## 6.


Create a candidate user account with the password cert456.
Modify the sudo configuration to let the candidate account
access root privileges with no password prompt.


## Solution

useradd -p cert456 candidate

```shell
useradd candidate
passwd candidate #cert456

sudo visudo
#And write this line there: candidate candidate ALL=(ALL) NOPASSWD:ALL
```

## 7.


Configure the system so that an empty NEWS file is automatically
created in the home directory of any new user.

## Solution


```shell
   touch /etc/skell/NEWS
```



## 8.


Create a group called students.


## Solution

sudo groupadd students

## 9.


Create a new user account with the following attributes:
- Username is harry.
- Password is magic.
- This user’s home directory is defined as /home/school/harry/.
- This new user is a member of the existing students  group.
- The /home/school/harry/binaries/ directory is part of the PATH variable.

## Solution- didnt know how to solve(path variable)

```shell
  sudo useradd -G students -d /home/school/harry/ harry
  
  passwd harry #magic
  
  ##To define path variable 
  ##Podobno cos takiego ale nie jestem pewien czy to jest dobrze zrobione
  #Do sprawdzenia i wyjasnienia
  sudo sh -c 'echo "PATH=$PATH:/home/school/harry/binaries/" >> /home/school/harry/.bashrc'


```



## 10.


Create a user account with username sysadmin with the
following attributes:
- Use a password of science.
- This user’s home directory is defined as /sysadmin/.
- sysadmin has sudo privileges and will not be prompted  for a password when using the sudo command.
- The default shell for this user is zsh.

## Solution

```shell
   sudo useradd -s zsh -d /sysadmin/ sysadmin 

  sudo visudo 
  ## sysadmin ALL=(ALL) NOPASSWD:ALL
```


## 11.


Ensure that all users can invoke the last command and access
a list of users who previously logged in

## Solution - didnt know how to solve


## 12.

Correct the projectadmin user account so that logins are
possible using the password _onetime43_. Set the home
directory to /home/projectadmin.

## Solution


```shell
usermod -d /home/projectadmin projectadmin

passwd projectadmin #_onetime43_
``` 


## 13. 


Alter the devel user account so that it can log into the system
with a working bash shell environment.


## Solution


```shell
usermod -s /bin/bash devel
```


## 14.

Find the name of the service which uses TCP port 2605, as
documented in /etc/services, and write the service name to
the file /home/student/port-2605.txt. Find all of the ports
used for TCP services IMAP3 and IMAPS, again as documented
in /etc/services, and write those port numbers to the file
/home/student/imap-ports.txt.


## Solution


## ZLE MOJE ROZWIAZANIE
```shell
   ss -tlnp | grep ':2605' #From here we take the PID/name of the proccess and write
   
   sudo echo 'PID' > /home/student/port-2605.txt
   
   
   ## CHybaa to samo w ten sposob:
   ss -tlnp | grep 'IMAP3'
   ss -tlnp | grep 'IMAPS' 
   ##and write these port numbers to a file by echo
   
```

## POPRAWNE:

```shell

grep "2605/tcp" /etc/services 

grep -E "imap3|imaps" /etc/services 
```


## 15. 


The following tasks may be achieved using the user student’s
sudo privileges:
1. Temporarily mount the filesystem available on
   /dev/xvdf2 under /mnt/backup/.
2. Decompress and unarchive the
   /mnt/backup/backup-primary.tar.bz2 archive
   into /opt/. This should result in a new directory (created
   from the archive itself) named /opt/proddata/.

## Solution - problems with the 2nd task to unarchive and decompress (--extract ?? --directory ??)

```shell
  #1
   sudo mount /dev/xvdf2 /mnt/backup/
   
   #2 -MOJE ROZWIAZANIE BLEDNE
   sudo tar --extract vf /mnt/backup/backup-primary.tar.bz2 --directory /opt/proddata/


  #Poprawiona komenda, gdzie -j odpowiada za obsluge archiwum .bz2
  sudo tar -xvjf /mnt/backup/backup-primary.tar.bz2 -C /opt/ 


```



## 16.

Configure the swap partition /dev/xvdi1 so that it does not*
become attached automatically at boot time.

## Solution
```shell
  swapon --show # check if it is implemented somewhere
  #If it is then go to /etc/fstab file and delete the swap partition that is used for this
  
  mkswap /dev/xvdi1
  swapon /dev/xvdi1
  
  swapon --show #To check if successfull
```


## 17.

Configure the system so that the existing filesystem that
corresponds to /staging gets persistently mounted in read-only
mode.

## Solution

```shell
  #First we have to find a partition that this existing filesystem is mounted
  mount -l | grep 'on /staging'

   #We have to modify the fstab file obviously
   sudo vim /etc/fstab
   
   ## [NAME_OF_PARTITION_WE_FOUND]  /staging [w zaleznosci od tego co zwroci nam grep] ro 0 1

```


## 18.

Working with archives and compressed files is an integral part of
the System Administrator’s job.
Perform the following tasks to demonstrate your ability to work
with archives and compressed files:
1. Extract all files from archive file /opt/SAMPLE001.zip
   into target directory /opt/SAMPLE001
2. Create a tar archive file /opt/SAMPLE0001.tar
   containing all files in the directory /opt/SAMPLE001
3. Compress the tar archive file /opt/SAMPLE0001.tar
   using the bzip2 compression algorithm
4. Compress the tar archive file /opt/SAMPLE0001.tar
   using the xz compression algorithm
   Make sure that the uncompressed archive file
   /opt/SAMPLE0001.tar is not removed aft

## Solution

```shell
   tar --extract --file /opt/SAMPLE001.zip --directory /opt/SAMPLE001
   
   tar -cvf /opt/SAMPLE0001.tar /opt/SAMPLE001/
   
   bzip2 -c /opt/SAMPLE0001.tar
   
   xz --keep -c /opt/SAMPLE0001.tar
   
   unxz --keep /opt/SAMPLE0001.tar.xz
```

## 19.
A data directory is not used anymore and is about to be archived.
You have been asked to identify and remove some files,before
archiving takes place.
Perform the following tasks to demonstrate your ability to search
for files given various criteria:
1. Find all executable files in the directory
   /srv/SAMPLE002 and remove them
2. Find all files in the directory /srv/SAMPLE002, which
   have not been accessed during the last month and
   remove them
3. Find all empty directories in the directory
   /srv/SAMPLE002 and remove them
4. Find all files in the directory /srv/SAMPLE002 with a file
   extension of .tar. Write a list of matching filenames, one
   per line, to the file
   /opt/SAMPLE002/toBeCompressed.txt, which has
   already been created. Ensure that you specify a relative
   path to each file, using /srv/SA

## Solution

```shell
   find /srv/SAMPLE002 -perm /u=x #NIE WIEM CZY DOBRZE + nie wiem jak to przekazac te argumenty do usuniecia.
   
   find /srv/SAMPLE002 -atime -30  #rmdir - to delete empty dirs
   
   find ?  #rmdir - to delete empty dirs
   
   find /srv/SAMPLE002 .tar #And i dont know how to pipe it correctly to add a relative path to each file
   

```