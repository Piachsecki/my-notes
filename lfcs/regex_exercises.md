

## 1. Match numbers containing floating point. Skip those that don't.

Speed of light in vacuum 299792458 m/s
Standard atmosphere 101325 Pa
Earth to sun distance 149600000 km
Acceleration of gravity 9.80665 m/s^2
Circumference to diameter ratio 3.141592
Gas constant 8.3144621 J/mol*K

## Solution: [0-9]\.[0-9]*



## 2. Match titles of all films produced before 1990.


1 The Shawshank Redemption (1994)
2 The Godfather (1972)
3 The Godfather: Part II (1974)
4 Pulp Fiction (1994)
5 The Good, the Bad and the Ugly (1966)
6 The Dark Knight (2008)
7 12 Angry Men (1957)
8 Schindler's List (1993)
9 The Lord of the Rings: The Return of the King (2003)
10 Fight Club (1999)


## Solution: .*\(19[1-8]\d\)
.* - jedna literka/cyfra przed 0 albo nieskonczona ilosc razy
i szukamy filmow od 1910 
\d - matchuje kazda cyfre
\) - omijamy znak ) jako specjalny


## 3. Exercise 1: Matching characters

match	abcdefg	
match	abcde	
match	abc

## Solution: abc.*

## 4. Exercise 1½: Matching digits

match	abc123xyz	Success
match	define "123"	Success
match	var g = 123;	Success

## Solution: .*123.*


## 4. Exercise 2: Matching with wildcards


match	cat.	Success
match	896.	Success
match	?=+.	Success
skip	abc1

## Solution: .{3}\.$


## 5. Exercise 3: Matching characters

match	can	Success
match	man	Success
match	fan	Success
skip	dan	To be completed
skip	ran	To be completed
skip	pan	To be completed


## Solution: [cmf]an




## 5. Exercise 4: Excluding characters


match	hog	Success
match	dog	Success
skip	bog

## Solution: [^b]og ALBO ^[hd]og

wyjasnienie: [^b] - to oznacza wszystkie opcje oprocz b



## 6. Exercise 5: Matching character ranges


match	Ana	Success
match	Bob	Success
match	Cpc	Success
skip	aax	To be completed
skip	bby	To be completed
skip	ccz

## Solution: ^[A-C].* albo [^a-z].* albo [A-C][n-p][a-c]


## 7. Exercise 5: Matching character ranges


match	wazzzzzup	Success
match	wazzzup	Success
skip	wazup

## Solution: ^waz+up albo ^waz{3,5}up albo 


## 8. Exercise 7: Matching repeated characters


match	aaaabcc	Success
match	aabbbbc	Success
match	aacc	Success
skip	a	

## Solution: a+b*c+ albo nawet aa+b*c+


## 9. Exercise 8: Matching optional characters



match	aaaabcc	Success
match	aabbbbc	Success
match	aacc	Success
skip	a

## Solution: a+b*c+ albo nawet aa+b*c+



## 10. Exercise 8: Matching optional characters


match	1 file found?	Success
match	2 files found?	Success
match	24 files found?	Success
skip	No files found.

## Solution: \d+ files? found\?



## 11. Exercise 9: Matching whitespaces


match	1.   abc	Success
match	2.	abc	Success
match	3.           abc	Success
skip	4.abc

## Solution: \d\.\s*abc$
wyjasnienie : \d odpowiada za liczbe zaczynajaca ta linie
\. - omijamy specjalny charakter kropki
\s+ - dowolna liczba whitespacow
abc$ - konczymy linie takim napisem


## 11. Exercise 10: Matching lines


match	Mission: successful	To be completed
skip	Last Mission: unsuccessful	To be completed
skip	Next Mission: successful upon capture of target

## Solution: ^Mission: *.successful$



## 12. Exercise 11: Matching groups



Task	Text	                    Capture Groups	 
capture	file_record_transcript.pdf	file_record_transcript	
capture	file_07241999.pdf	        file_07241999	
skip	testfile_fake.pdf.tmp

## Solution: ^(file.+)\.pdf$




## 13. Exercise 12: Matching nested groups





Task	    Text	    Capture Groups	 
capture	    Jan 1987	Jan 1987 1987	
capture	    May 1969	May 1969 1969	
capture	    Aug 2011	Aug 2011 2011

## Solution: (\w+ (\d+))

\w:
- Reprezentuje litery, cyfry oraz podkreślenia (_).
- W większości implementacji wyrażeń regularnych jest równoważne klasie znaków [a-zA-Z0-9_].
- Jest to jeden z tzw. metaznaków, który ułatwia pracę z wyrażeniami regularnymi.



