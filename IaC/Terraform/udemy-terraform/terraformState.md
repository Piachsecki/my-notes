# Terraform Section 5

> Co to jest terraform.tfstate?

Plik stanu Terraform, czyli terraform.tfstate, to kluczowy element w ekosystemie Terraform, który przechowuje aktualny stan zarządzanej infrastruktury. Terraform używa tego pliku, aby śledzić, jak wygląda faktyczna infrastruktura (zasoby, ich atrybuty) w porównaniu do tego, co jest opisane w plikach konfiguracyjnych (.tf). Dzięki temu Terraform może określić, jakie zmiany należy wprowadzić podczas wykonywania komend takich jak terraform plan i terraform apply.

Pozwala on nam zmieniac tylko poszczegolne pliki, a nie reloadowac cala konfiguracje na raz.
Jezeli dokonujemy zmian w pliku i bedziemy chcieli je wcielic w zycie,
to za pomoca komendy terraform apply USUNIEMY poprzedni resource i podmienimy go nowym
Z NOWYM ID i z nowa wczesniej juz przez nas zdefiniowana konfiguracja
state file posiada rowniez metadane z danych plikow


> Po co uzywac pliku state

Kiedy pracujemy w zespołach, zdalne przechowywanie stanu (remote state) zapewnia, że wszyscy członkowie zespołu mają dostęp do tej samej, aktualnej wersji stanu, co zapobiega niezgodnościom.


Problemy związane z plikiem stanu:
Jeśli wiele osób lub procesów próbuje jednocześnie zmieniać stan infrastruktury, mogą wystąpić konflikty. Dlatego zdalne przechowywanie stanu z mechanizmem blokowania (np. w S3 z DynamoDB) jest często zalecane.



### Terraform state file: terraform.tfstate IS NOT CREATED UNTIL we run terraform apply command 


# Terraform Section 5 - Working with terraform
> I will present simple commands and features that are used here in terraform



1) terraform fmt:
Komenda terraform fmt w Terraformie służy do automatycznego formatowania plików konfiguracyjnych w celu zapewnienia spójnego stylu kodu.
Polecenie to przekształca pliki .tf oraz inne pliki związane z Terraformem (np. *.tfvars),
zgodnie z ustalonym stylem formatowania, co ułatwia ich czytelność i współpracę w zespołach.

```bash
    terraform fmt   #Prints in what files the changes were made
```

![](img_4.png)

2) terraform validate:

```bash
    terraform validate   # Checks if the syntax is correct
```


2) terraform show:

```bash
    terraform show   # Prints essential information about our resource
```

3) terraform sprovidershow:

```bash
    terraform providers   # Prints the providers downloaded since entering the terraform init command
```


4) ## This is very important command! I had faced issues in the 1st tutorial where I deleted some resources in aws manually and then i faced issues because of not refreshing the state here
```bash
    terraform refresh   # Refreshes the state in our directory in case the changes were made OUTSIDE THE DIRECTORY HERE
```


5) terraform graph: Uzywany po to zeby zobaczyc jak resource sa powiazane ze soba:
![](img_5.png)

aws_instance.example jest zalezne od aws od aws_subnet.subnet
aws_subnet.subnet jest zalezne od aws_vpc.main
```bash
    terraform graph   
```



## Mutable vs immutable terraform infrastructure
> When we run terafform apply command we destroy the current configuration and implement a new one

Mutable infrastructure to podejście, w którym zasoby (np. serwery, maszyny wirtualne, bazy danych) mogą być modyfikowane w trakcie ich życia.


Immutable infrastructure to podejście, w którym zasoby nigdy nie są modyfikowane po ich utworzeniu. Gdy potrzebna jest zmiana, Terraform tworzy nowe zasoby, a stare są niszczone


Ale mozemy sprawic zeby najpierw byly tworzone np. nowe zasoby a stare usuwany dopiero wtedy kiedy nowe zostana utworzone, albo zeby stare rzeczy nie byly usuwane w ogole!
Mozemy to zrobic za pomoca uzycia LifeCycle Rules.


```terraform
    resource "local_file" "pet" {
        filename = "/root/pets.txt"
        lifecycle {
          prevent_destroy = true
        }
}
```



```terraform
    resource "local_file" "pet" {
        filename = "/root/pets.txt"
        lifecycle {
          create_before_destroy = true
        }
}
```

```terraform
    resource "aws_instance" "pet" {
  ami           = "ami-asfhvgg23412-asdA"
  instance_type = "t3-micro"
      tags = {
          Name = "Project A - Webserver"
      }
      lifecycle {
          ignore_changes = [
            tags
      ]
  }
}
```


```terraform
    resource "aws_instance" "pet" {
      ami           = "ami-asfhvgg23412-asdA"
      instance_type = "t3-micro"
      tags = {
          Name = "Project A - Webserver"
      }
      lifecycle {
          ignore_changes = all
  }
}
```


Fun fact: if we set the lifecycle rule on local_file as create before deleting we might face an issue of not having this file after all.
The filepath is unique such as /root/myfile.txt , so if we create the file first, we might just overwrite the 1st file that exists and then 
we destroy it so we dont have an access to it anymore!