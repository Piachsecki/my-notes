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

ps aux
ax - all processes - auxilary
u - user oriented format (memory + cpu, which user itp)










