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
