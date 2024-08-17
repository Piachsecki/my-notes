

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

ip route show | egrep -o '[0-9]{3}\.[0-9]{3}\.[0-9]{3}' | head -n 1
```


sudo chmod 700 certscript.sh


./certscript.sh


## 3.
Install the tmux package on your system.

## Solution

sudo apt search tmux

sudo apt install tmux


## 4. 

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

## Solution

sudo groupadd computestream


mkdir /exam/computestream/


cat /etc/computestream | grep computestream #Wez teraz gid tej grupy

