# Extra notes for linux features such as sed, awk and one liners that can be used in linux terminal

### AWK 

Struktura używania tej komendy odnosi się do takiego patternu:

pattern { action }: Podstawowy format programu awk. Jeśli wiersz pasuje do pattern, wykonywana jest action.

THIS IS THE FILE ON WHICH I WILL TRY TO SHOW THE COMMANDS
```shell
CREDITS,EXPDATE,USER,GROUPS
99,01 jun 2018,sylvain,team:::admin
52,01    dec   2018,sonia,team
52,01    dec   2018,sonia,team
25,01    jan   2019,sonia,team
10,01 jan 2019,sylvain,team:::admin
8,12    jun   2018,öle,team:support
        


17,05 apr 2019,abhishek,guest
```

$[LICZBA] jest odniesieniem do komendy w wierszu,
gdzie numeracja zaczyna sie od 1.
Wypisanie komendy awk '{print $0}' - jest rownoznaczne
z napisaniem cat (0 jest traktowane jako caly plik)


1. 

```bash
    awk '{print $1} file

: '99,01
52,01
52,01
25,01
10,01
8,12
17,05
'

```
Zwraca to taki wynik, poniewaz domyslnie separatorem dla AWK kolumn 
jest spacja ewentualnie tabulator. Ten 'delimeter' mozemy zmienic 
i pokazemy to w dalszych czesciach tego pliku 


2. 

$NF oznacza ostatnia kolumne w naszym wierszu, dlatego zostanie nam zwrocone:

```bash
    awk '{print $NF} file

: '
CREDITS,EXPDATE,USER,GROUPS
2018,sylvain,team:::admin
2018,sonia,team
2018,sonia,team
2019,sonia,team
2019,sylvain,team:::admin
2018,öle,team:support
        


2019,abhishek,guest
'

```

3.

Mozemy printowac kilka kolumn naraz, musimy zduplikwoac komende print

```shell
    awk '{print $1, $3}' file

```

4. 
Mozemy tez odnosic sie do numeru wiersza, a nie tylko kolumny za ktora odpowiada NF.
DO tego uzyjemy NR - ktory odpowiada za nr. wiersza

```shell
    #Wyprintuje caly plik - $0 
    # ale dopiero OD 2 wiersza - NR>1
    awk 'NR>1 {print $0}' file
    
```
5.

Mozemy tez zawierac jakies dzialania boolowskie np w naszym segmencie awk, gdzie powiemy ze mamy 
wyswietlic tylko te kolumny, gdzie ... cos sie nam zgadza.

```shell
    awk -F',' '$3 == 2019 {print $3}' file
```


6.
Albo mozemy zdefiniowac, ze delimeterem moze byc ',' ALBO ':'
Zeby to zrobic musimy ustawic to w patternie: F'[:,]'

```shell
    awk -F'[,:]' '{print $3}' file
```


7.

Ale awk to tez potezne narzedzie z wbudowanym kalkulatorem jezeli
potrzebujemy na szybko kalkulatora, ktory mozemy wykorzystac do obliczen

```shell
    echo | awk '{print sqrt(16)}'  # Pierwiastek kwadratowy z 16
  
    echo | awk '{print 2^3}'  # 2 do potęgi 3

    echo | awk '{print log(2)}'  # Logarytm naturalny z 2
    
    echo | awk '{print 20 / 4}'
    
    echo | awk '{print 5 + 3}'


```



