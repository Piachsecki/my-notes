
## 1

Command 1: sudo grep -r --text 'reboot' /var/log/ > reboot.log
Command 2: sudo grep -r 'reboot' /var/log/ > reboot.log

-r przeszukuje wszystkie pliki w katalogu, a --text traktuje wszystkie pliki w tym pliku JAKO PLIKI TEXTOWE, a nie np. jako binary data.
