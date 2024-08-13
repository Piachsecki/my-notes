# LFCS - Storage

> Topic for Storage partitioning and knowledge

## Terms

# 1
> List, create, delete and manage physical storage partitions 

To check ur disk partitions you can type command
```bash
    lsblk #which stands for list block devices
```


The partitions are only the ones that have a 'part' word in the 'type' 
section


```bash
loop29        7:29   0  38.8M  1 loop /snap/snapd/21759
loop30        7:30   0   476K  1 loop /snap/snapd-desktop-integration/157
loop31        7:31   0   452K  1 loop /snap/snapd-desktop-integration/83
loop32        7:32   0 321.1M  1 loop /snap/vlc/3777
nvme0n1     259:0    0 953.9G  0 disk 
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
└─nvme0n1p2 259:2    0 953.4G  0 part /var/snap/firefox/common/host-hunspell
```

In linux we have a saying that everything is a file. Thats why we can access the partitions
on the path: /dev/[disk]
In my case it would be:
/dev/nvme0n1p1 - points to the partition
/dev/nvme0n1 - points to the entire device

We cn check our partitions that are part of the device and the details by typing the command:
```bash
    sudo fdisk --list /dev/nvme0n1  #It prints the information about the partitions that are part of this device


    sudo cfdisk /dev/sdb    #This opens gui that let us manage our disks and partitions


```
GPT i MBR to dwa różne schematy partycjonowania dysków, z GPT będącym nowocześniejszym i bardziej elastycznym rozwiązaniem.

### GPT (GUID Partition Table) to nowoczesny schemat partycjonowania dysków, który jest częścią standardu UEFI (Unified Extensible Firmware Interface).
- Obsługuje dyski o pojemności większej niż 2 TB, co jest ograniczeniem starego schematu MBR.
- Umożliwia tworzenie do 128 partycji na jednym dysku (w MBR maksymalnie 4 partycje podstawowe).
- Każda partycja w GPT ma swój unikalny identyfikator GUID.
- GPT zapisuje wiele kopii tablicy partycji, co zwiększa odporność na uszkodzenia.
- Jest bardziej elastyczny i skalowalny niż MBR.


### MBR (Master Boot Record) to starszy schemat partycjonowania dysków, używany od lat 80. XX wieku.
- Ogranicza pojemność obsługiwanego dysku do 2 TB.
- Umożliwia tworzenie maksymalnie 4 partycji podstawowych. Można obejść to ograniczenie, tworząc jedną partycję rozszerzoną, która może zawierać wiele partycji logicznych.
- Zawiera kod rozruchowy, który ładuje system operacyjny.
- MBR zapisuje tablicę partycji tylko na początku dysku, co czyni ją bardziej podatną na uszkodzenia.



### Czym jest cfdisk?
to narzędzie tekstowe w systemie Linux służące do zarządzania partycjami na dysku. Jest to interaktywny program, który umożliwia przeglądanie, tworzenie, usuwanie i modyfikowanie partycji na dyskach twardych.


### Czym jest Swap disk?
to obszar dysku twardego lub dysku SSD, który system operacyjny Linux wykorzystuje jako dodatkową pamięć wirtualną, gdy fizyczna pamięć RAM jest pełna. Swap jest przydatny w zarządzaniu pamięcią systemową i zapewnia stabilność systemu w sytuacjach, gdy brakuje dostępnej pamięci RAM.
- Plik swap: Swap może być plikiem utworzonym na istniejącym systemie plików. To rozwiązanie jest bardziej elastyczne, ponieważ rozmiar swapu można łatwo zmieniać.
- Partycja swap: Swap może być także wydzieloną partycją na dysku twardym. Taki swap jest zazwyczaj szybszy, ponieważ nie jest zależny od systemu plików.
- Zastosowanie: 
- - Wirtualizacja: Systemy operacyjne uruchamiane na maszynach wirtualnych często używają swapu, aby lepiej zarządzać ograniczoną ilością dostępnej pamięci.
- - Systemy z małą ilością RAM: Swap może być szczególnie przydatny na starszych komputerach z ograniczoną ilością pamięci RAM.

Komendy uzywane do uzycia swapu:
```bash
    free -h # SHows how much free GB we have in our swap config and in our memory too
    swapon --show #Shows only how much did we use of our swap partition/file
    
    #To create a swap we can either create a file or create a partition for it
    sudo mkwswap /dev/[PARTITION_WE_WANT_TO_USE_AS_SWAP]
    sudo mkwswap /dev/sdb1
    sudo swapon /dev/sdb1
    
    #To create a file we have to fill it with zero numbers
    sudo dd if=/dev/zero of=/swap bs=1M count=128 status=progress
    #And now when the file is created we can tell it to be a swap file:
    sudo mkswap /swap
    sudo swapon /swap
```



### Create and Configure File Systems

Even if we divide partitions and we have free GB of space in there we need to have
a File system installed on this partition to store files and folders. In ubuntu system's
this file system is called 'ext4' file system

```bash
    sudo mkfs.ext4 /dev/[DISK_WE_WANT_TO_CREATE_A_FILESYSTEM_ON]
    sudo mkfs.ext4 /dev/sdb1 #mkfs - make file system
```

We can have weird situation in ubuntu. We can have 1000GB of free space on disks, but 
we cannot save a file/system crashes. THis is because the are too few inodes on the system

```bash
    sudo mkfs.ext4 -N 500000 /dev/sdb2 #Sets a large amount of inodes on this file system
    
    sudo tune2fs -l /dev/sdb2 #tune2fs is a tool to manage our file system on a disk
    
    sudo tune2fs -L new_label /dev/sda1  # Zmiana etykiety na "new_label" dla systemu plików ext4 na /dev/sda1

```


### Mount Filesystems at our during boot

We have to mount a filesystem to one of our directories to be able to create files and folders at
this specific partition/disk

```bash
    sudo mount /dev/vdb1 /mnt/
    sudi touch /mnt/testfile #check if works
    ls -l /mnt/ #check
    
    
    sudo umount /mnt/
```


MNT to folder przeznaczony do tymczasowego montowania systemów plików. Służy jako miejsce, gdzie można zamontować dodatkowe dyski twarde, dyski przenośne, partycje sieciowe, obrazy dysków, lub inne zasoby systemowe, które nie są domyślnie montowane przy starcie systemu.

If want to mount our file system automatically when the system boots up, we have to edit
/etc/fstab file

```bash
<file system> <mount point>   <type>  <options>       <dump>  <pass>
    /dev/vda2       /boot       ext3      defaults      0       1 
```

dump: 0 - backup disabled
      1 - backup enabled

pass: 0 - the file system should never be scanned for error
      1 - should be scanned first for errors before the other ones 
      2 - should be scanned after the ones with a value of one have been scanned

On our systems we can pretty often see syntax:
```bash
    <file system>                           <mount point>   <type>      <options>    <dump>  <pass>

    UUID=0cfb2a0e-faff-4f3b-bc13-af0d866d258b     /          ext4    errors=remount-ro 0       1
```


- Nazwa urządzenia może się zmienić: W systemie Linux, przy uruchamianiu, system może przypisywać różne nazwy urządzeń blokowych (np. /dev/sda1, /dev/sdb1) w zależności od kolejności wykrywania urządzeń. Jeśli masz kilka dysków lub partycji, ich nazwy mogą się zmieniać, co może prowadzić do problemów z montowaniem.
- UUID jest unikalny: UUID jest unikalnym identyfikatorem przypisanym do każdej partycji w momencie jej tworzenia. Nie zmienia się, nawet jeśli zmieni się nazwa urządzenia. Dzięki temu system zawsze będzie wiedział, którą partycję zamontować, niezależnie od jej bieżącej nazwy.

to find our UID we have to use the command: 
```bash
    sudo blkid /dev/vdb1
    #OR
    ls -l /dev/disk/by-uuid/
```


To change some setting on our filesystem we have to use xfs_admin 


### FileSystem aand Mount Options

We have to use findmnt command to list additional info about mounted filesystems.


THE EXAMPLE OF THE OUTPUT OF THE findmnt command:

```bash
TARGET                                   SOURCE            FSTYPE          OPTIONS
/                                        /dev/nvme0n1p2    ext4            rw,relatime,errors=remount-ro
├─/sys                                   sysfs             sysfs           rw,nosuid,nodev,noexec,relatime
│ ├─/sys/firmware/efi/efivars            efivarfs          efivarfs        rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/security                 securityfs        securityfs      rw,nosuid,nodev,noexec,relatime
│ ├─/sys/fs/cgroup                       cgroup2           cgroup2         rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot
│ ├─/sys/fs/pstore                       pstore            pstore          rw,nosuid,nodev,noexec,relatime
│ ├─/sys/fs/bpf                          bpf               bpf             rw,nosuid,nodev,noexec,relatime,mode=700
│ ├─/sys/kernel/debug                    debugfs           debugfs         rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/tracing                  tracefs           tracefs         rw,nosuid,nodev,noexec,relatime
│ ├─/sys/fs/fuse/connections             fusectl           fusectl         rw,nosuid,nodev,noexec,relatime
│ └─/sys/kernel/config                   configfs          configfs        rw,nosuid,nodev,noexec,relatime
├─/proc                                  proc              proc            rw,nosuid,nodev,noexec,relatime
│ ├─/proc/sys/fs/binfmt_misc             systemd-1         autofs          rw,relatime,fd=29,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=23750
│ │ └─/proc/sys/fs/binfmt_misc           binfmt_misc       binfmt_misc     rw,nosuid,nodev,noexec,relatime
│ └─/proc/fs/nfsd                        nfsd              nfsd            rw,relatime
├─/dev                                   udev              devtmpfs        rw,nosuid,relatime,size=3914396k,nr_inodes=978599,mode=755,inode64
│ ├─/dev/pts                             devpts            devpts          rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000
│ ├─/dev/shm                             tmpfs             tmpfs           rw,nosuid,nodev,inode64
│ ├─/dev/hugepages                       hugetlbfs         hugetlbfs       rw,relatime,pagesize=2M
│ └─/dev/mqueue                          mqueue            mqueue          rw,nosuid,nodev,noexec,relatime
├─/run                                   tmpfs             tmpfs           rw,nosuid,nodev,noexec,relatime,size=791192k,mode=755,inode64
│ ├─/run/lock                            tmpfs             tmpfs           rw,nosuid,nodev,noexec,relatime,size=5120k,inode64
│ ├─/run/qemu                            tmpfs             tmpfs           rw,nosuid,nodev,relatime,mode=755,inode64
│ ├─/run/credentials/systemd-sysusers.service
│ │                                      ramfs             ramfs           ro,nosuid,nodev,noexec,relatime,mode=700
│ ├─/run/rpc_pipefs                      sunrpc            rpc_pipefs      rw,relatime
│ ├─/run/snapd/ns                        tmpfs[/snapd/ns]  tmpfs           rw,nosuid,nodev,noexec,relatime,size=791192k,mode=755,inode64
│ │ ├─/run/snapd/ns/snapd-desktop-integration.mnt
│ │ │                                    nsfs[mnt:[4026533207]]
│ │ │                                                      nsfs            rw
│ │ ├─/run/snapd/ns/snap-store.mnt       nsfs[mnt:[4026533305]]
│ │ │                                                      nsfs            rw
│ │ └─/run/snapd/ns/discord.mnt          nsfs[mnt:[4026533328]]
│ │                                                        nsfs            rw
│ └─/run/user/1000                       tmpfs             tmpfs           rw,nosuid,nodev,relatime,size=791188k,nr_inodes=197797,mode=700,uid=1000,gid=1000,inode64
│   ├─/run/user/1000/doc                 portal            fuse.portal     rw,nosuid,nodev,relatime,user_id=1000,group_id=1000
│   └─/run/user/1000/gvfs                gvfsd-fuse        fuse.gvfsd-fuse rw,nosuid,nodev,relatime,user_id=1000,group_id=1000
├─/snap/bare/5                           /dev/loop1        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/atom/286                         /dev/loop0        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/code/165                         /dev/loop2        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/code/166                         /dev/loop3        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core18/2823                      /dev/loop4        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core18/2829                      /dev/loop5        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core20/2264                      /dev/loop6        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core20/2318                      /dev/loop7        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core22/1439                      /dev/loop9        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core22/1380                      /dev/loop8        squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/core24/423                       /dev/loop10       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/discord/202                      /dev/loop11       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/discord/203                      /dev/loop12       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/firefox/4650                     /dev/loop13       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/firefox/4698                     /dev/loop14       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gnome-3-38-2004/140              /dev/loop15       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gnome-3-38-2004/143              /dev/loop16       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gnome-42-2204/172                /dev/loop17       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gnome-42-2204/176                /dev/loop18       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gnome-46-2404/42                 /dev/loop19       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gradle/134                       /dev/loop20       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/gtk-common-themes/1535           /dev/loop21       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/logisim-evolution-snapcraft/46   /dev/loop22       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/mesa-2404/44                     /dev/loop23       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/postman/248                      /dev/loop24       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/postman/254                      /dev/loop25       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/snap-store/1113                  /dev/loop26       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/snap-store/959                   /dev/loop27       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/snapd/21465                      /dev/loop28       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/snapd/21759                      /dev/loop29       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/snapd-desktop-integration/157    /dev/loop30       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/snap/snapd-desktop-integration/83     /dev/loop31       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/var/snap/firefox/common/host-hunspell /dev/nvme0n1p2[/usr/share/hunspell]
│                                                          ext4            ro,noexec,noatime,errors=remount-ro
├─/snap/vlc/3777                         /dev/loop32       squashfs        ro,nodev,relatime,errors=continue,threads=single
├─/boot/efi                              /dev/nvme0n1p1    vfat            rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,errors
└─/tmp/.mount_jetbradH11gG               jetbrains-toolbox fuse.jetbrains- ro,nosuid,nodev,relatime,user_id=1000,group_id=1000

```

We can specify what mounted filesystems we would like to get:
```bash
      findmnt -t xfs,ext4 #Currently mounted 
      
      #In the options column we can see ro - read only, rw - read write and other options
      #To change them we can use mount command
      sudo mount -o ro /dev/nvme0n1p2 /
      sudo remount -o ro /dev/nvme0n1p2 /
```


WE CAN USE THE SAME MOUNT OPTIONS PERMANENTLY IN A FILE

```bash
<file system> <mount point>   <type>       <options>   <dump>  <pass>
    /dev/vda2       /boot       ext3      ro,noexec      0       1 
```

# 3

### Remote Filesystems

NFS - Network File System, to protokół umożliwiający współdzielenie plików między komputerami w sieci. Dzięki NFS użytkownicy mogą uzyskać dostęp do plików znajdujących się na zdalnym komputerze w taki sam sposób, jak do plików na lokalnym dysku.

Jak działa NFS?
- Serwer NFS: Udostępnia pliki i katalogi, które są dostępne dla klientów w sieci.
- Klient NFS: Montuje zdalny system plików na swoim komputerze i uzyskuje do niego dostęp, jakby był lokalnie dostępny.



Na systemie Linux konfiguracja NFS polega na:

- Instalacji pakietów: nfs-kernel-server na serwerze oraz nfs-common na kliencie.
- Konfiguracji udostępnianych zasobów: W pliku /etc/exports na serwerze definiuje się, które katalogi mają być udostępnione.
- Montowaniu zasobów na kliencie: Używa się polecenia mount lub wpisuje zasób do /etc/fstab, aby zamontować katalog NFS.

## Server SIDE

```bash
      sudo apt install nfs-kernel-server #server side
      
      sudo vim /etc/exports #Here we define which files/packages should be exported
```

Example of /etc/exports file:
```bash
# /etc/exports: the access control list for filesystems which may be exported
#		to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#

WHERE

  the directory         which nfs clients should be allowed to use this remote file system
  that will be
  remote
/srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)




hostname1 -> example.com/server1.example.com/[10.0.0.9]/[20.0.5.1/24]
sync -> synchronous writes - NFS ensures that data written by client is actually saved on the storage device
async -> asynchronous writes - faster, but not 100% stored
no_subtree_check -> disables subtree checking
no_root_squash -> allows root user to have root priviliges
```

After we change our /etc/exports file we have to apply these changes and make our nfs server available.
To do so write:
```bash
      sudo exportfs -r # -r re-export. Refreshes "/etc/exports" file
      sudo exportfs -v # Prints current nfs 
```



## Client SIDE

```bash
      sudo apt install nfs-common #Here are all utilities needed for a client side of nfs
      
      sudo mount [IP_OR_HOSTNAME_OF_SERVER]:/path/to/remote/directory /path/to/local/directory #This is how we mount shared nfs directory
    
      sudo mount 127.0.0.1:/etc /mnt
      
      
      #If we want this NFS share to be auto mounted at boot time, we have to edit /etc/fstab
      #And in the place where we before defined ext4, we type nfs
      
    <file system>        <mount point>   <type>       <options>   <dump>  <pass>
      127.0.0.1:/etc       /mnt           nfs          defaults     0       0 

```


## NBD

NBD to protokół sieciowy, który pozwala komputerowi na dostęp do blokowego urządzenia magazynującego (np. dysku twardego) znajdującego się na innym komputerze przez sieć. W praktyce, NBD umożliwia traktowanie zdalnego urządzenia jako lokalnego dysku.
W systemie operacyjnym, zasób NBD jest widziany jako urządzenie blokowe, co oznacza, że można na nim tworzyć partycje, formatować je i montować jako system plików.
Taki NFS ale do calego dysku/partycji

Dziala tez w oparciu o serwer i klienta

### Server Side
```bash
      sudo apt install nbd-server
      
      sudo vim /etc/nbd-server/config   #Default Configuration file
      
      #After we make changes we have to rerun the nbd deamon
      sudo systemctl restart nbd-server.service
```


```bash
[generic]
# If you want to run everything as root rather than the nbd user, you
# may either say "root" in the two following lines, or remove them
# altogether. Do not remove the [generic] section, however.
#       user = nbd
#       group = nbd
        includedir = /etc/nbd-server/conf.d
        allowlist = true
# What follows are export definitions. You may create as much of them as
# you want, but the section header has to be unique.
#
[partition2]
        exportname=/dev/sda1

```

[partition2] - the new name of our partition that will be shared
      exportname=/dev/sda1 - the block storage that will be shared


### Client Side

```bash
      sudo apt install nbd-client
      sudo modprobe nbd #We have to enable this module, but this enables it only during this boot
      
      #To tell ubuntu to enable this module everytime we boot the system we have to edit this file:
      
     sudo vim /etc/modules-load.d/modules.conf
     
     
     sudo nbd-client [IP_OF_THE_NBD_SERVER] -N [NAME_OF_THE_BLOCK_DEFINED]
     sudo nbd-client 127.0.0.1 -N partition2
     
     #And now to access it we have to mount it somewhere in our system
     sudo mount /dev/nbd0 /mnt
```


# 5
> LVM Storage


```bash
      sudo apt install lvm2
```
PV - Physical Volume - real storage devices that it will be used (a disk, more rarely the partition)

VG - Volume Group

LV - Logical Volume

PE - Physical Extent



1. Tworzenie fizycznych wolumenów (Physical Volumes, PV)
   - Fizyczny wolumen (PV) jest to dysk twardy, partycja dyskowa lub inne urządzenie magazynujące, które zostało przygotowane do użycia przez LVM.
   - Używając narzędzia pvcreate, przekształcasz dysk lub partycję w fizyczny wolumen.
   - Przykład: pvcreate /dev/sda1
2. Tworzenie grupy wolumenów (Volume Groups, VG)
   - Grupa wolumenów (VG) to pula przestrzeni dyskowej utworzona z jednego lub więcej fizycznych wolumenów.
   - Grupa wolumenów łączy dostępne przestrzenie ze wszystkich fizycznych wolumenów, dając jednolitą przestrzeń, z której można tworzyć logiczne wolumeny.
   - Przykład: vgcreate my_volume_group /dev/sda1 /dev/sdb1
   - W tym przykładzie, my_volume_group łączy przestrzeń z /dev/sda1 i /dev/sdb1.
3. Tworzenie logicznych wolumenów (Logical Volumes, LV)
   - Logiczny wolumen (LV) to logiczna partycja, którą tworzysz wewnątrz grupy wolumenów.
   - Logicznemu wolumenowi możesz przypisać określoną wielkość, która może być później dynamicznie zmieniana.
   - Narzędzie lvcreate służy do tworzenia logicznych wolumenów.
   - Przykład: lvcreate -L 500G -n my_logical_volume my_volume_group
   - -L 500G oznacza, że wolumen logiczny będzie miał 500 GB przestrzeni.
   - -n my_logical_volume nadaje nazwę wolumenowi logicznemu.
4. Montowanie logicznego wolumenu
   - Po utworzeniu logicznego wolumenu, możesz go sformatować za pomocą systemu plików, np. ext4.
   - Przykład: mkfs.ext4 /dev/my_volume_group/my_logical_volume
   - Następnie, montujesz ten wolumen do systemu plików.
   - Przykład: mount /dev/my_volume_group/my_logical_volume /mnt/my_mount_point
5. Rozszerzanie wolumenów logicznych
   - Jeśli potrzebujesz więcej miejsca, możesz rozszerzyć logiczny wolumen, a następnie powiększyć system plików na tym wolumenie.
   - Przykład: lvextend -L +100G /dev/my_volume_group/my_logical_volume
   - Po rozszerzeniu logicznego wolumenu, należy powiększyć system plików, np. za pomocą resize2fs dla ext4.
   - Przykład: resize2fs /dev/my_volume_group/my_logical_volume


```bash
      sudo pvcreate /dev/sdc /dev/sdd # Creates 2 pv's
      
      sudo vgcreate my_volume /dev/sdc /dev/sdd # creates VG that consists of 2 pv's
      
      sudo pvcreate /dev/sde
      
      sudo vgextend my_volume /dev/sde # Expands it for a new disk
      sudo vgreduce my_volume /dev/sde
      
      sudo lvcreate --size 2G --name partition1 my_volume #Creates a LVM
      sudo lvcreate --size 5G --name partition2 my_volume #Creates a LVM
      
      sudo lvs #Lists our lvs
      
      sudo lvresize --extents 100%VG my_volume/partition1 #Adds remaining space of the pv's to this LV
      
      sudo lvresize --size 2G my_volume/partition1 #Changes its size to original 2G
      
      sudo lvdisplay #Prints all the essential information of our lv's
      
      #To create a filesystem on LV:
      #we have to create it by
      sudo mkfs.ext4 /dev/[NAME_OF_VOLUME_GROUP]/[NAME_OF_LOGICAL_VOLUME]
      
      sudo mkfs.ext4 /dev/my_volume/partition1
      
```

# 6
> Monitor Storage Performance


```bash
      sudo apt install sysstat
      
      iostat 
      
      pidstat -pidstat  #-d - devices
```

Here we have the output of the iostat command. Data since bootup

```bash
Linux 6.5.0-44-generic (kompiq) 	13/08/24 	_x86_64_	(8 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           5.31    0.02    1.12    0.11    0.00   93.45

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
loop0             0.00         0.03         0.00         0.00       1222          0          0
loop1             0.00         0.00         0.00         0.00         17          0          0
loop10            0.00         0.03         0.00         0.00       1224          0          0
loop11            0.00         0.03         0.00         0.00       1212          0          0
nvme0n1           5.35        97.46        91.17         0.00    4201223    3930025          0


```
tps - transfers per second

# 7 
> Advanced Filesystem Permissions


Imagine we are being logged as kacper user and we belong to kacper group.
What if we want to grant kacper permissions to edit and read a file nr 3, but not the other files.
If we add him to the group he will be able to read and write to file 2 and file 1 too, so this is not 
the best approach. THat is why we need advanced filestystem permissions
```
-rw-rw-r-- alex staff 0 MAy 23 5:56 file1

-rw-rw-r-- alex staff 0 MAy 23 5:56 file2

-rw-rw-r-- alex staff 0 MAy 23 5:56 file2
```

To do it we will use the feature called ACL'S. Access Control List. It can allow kacper to read and write,
JAne to read onlly and Maciek to do not have any priviliges for example

```bash
      sudo apt install acl
      
      sudo setfacl --modify user:jeremy:rw file3
      
      sudo getfacl file3 #Prints all permissions of this file
      
      sudo setfacl --modify mask:r file3 #it sets the same permissions for all: user/groups/other as specified
      
      #We can set permissions in the same way for groups and others:
      sudo setfacl --modify group:sudo:rw file3
      
      #Deleting
      sudo setfacl --remove group:sudo file3
      
      #Deleting all
      sudo setfacl --remove-all file3
      
      
      #APplying setfacl for directories(we have to use it recursively)
      sudo setfacl --recursive --modify user:jeremy:rx dir1/
```


But we have also different attributes that we can set for some users:
For example it can be only append attribute:
```bash
   sudo chattr +a file3 #It give the attribute that we can only add data to this file but we cannot modify/change/delete the data which was there already
```

immutable attribute:

```bash
   sudo chattr +i file3 #File cannot be edited/deleted/changed
   
   lsattr file3 #Print the attributes of the file/directory
   
   #Basically we can add and delete an attribute by using '-' or '+' with the correct attribute flag
```