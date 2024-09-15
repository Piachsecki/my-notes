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