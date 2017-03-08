#!/bin/bash
#MyISBN
#It's simple bash script reading ISBN book numbers from file and writing it's 
#metadata from worldcat database to csv file. For database and API license and conditions see worldcat.org
#Free version is limited by Worldcat to 1000 requests per day.
#
#Copyright 2017 Piotr Kowalik <pietrasagh@gmail.com>
#
#This file is part of MyISBN.
#
#MyISBN is free software: you can redistribute it and/or modify it under the terms 
#of the GNU General Public License as published by the Free Software Foundation, 
#either version 3 of the License, or (at your option) any later version.
#
#MyISBN is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
#without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#See the GNU General Public License for more details.
#
#For license text of GNU General Public License plase see http://www.gnu.org/licenses/.


ISBN_BAZA="isbn.txt"
OUTPUT_FILE="test.csv"
NOL=$(grep -c ^ $ISBN_BAZA)
i=0

#if output file doesnt exists create it add header row to csv
if [ ! -f $OUTPUT_FILE ]
then
    echo "Input,ISBN,ID1,ID2,Wydanie,Tytuł,ID3,Język,Rok wydania,Autor,Wydawnictwo,Miasto,ID5,Język oryginału,Żródło danych" > $OUTPUT_FILE
fi
if [ -z "$1" ]
    then
    #if no argument get ISBN number form each line in input file
    echo "Number of ISBN to process:" $NOL;
	while read ISBN
	    do
	    ((i++));
	    #in case something go wrong 
	    printf -- "%s;%d-%d," $ISBN $i $NOL >> $OUTPUT_FILE;
	    #request to Worldcat xisbn API and append result to output file
	    curl -s  "http://xisbn.worldcat.org/webservices/xid/isbn/$ISBN?method=getMetadata&format=csv&fl=*"| tr \" " " >> $OUTPUT_FILE;
	    echo "Processing IBSN $ISBN, $i out of $NOL";
	done < $ISBN_BAZA
    else 
	printf -- "%s;single input,"  $1 >> $OUTPUT_FILE
	curl -s  "http://xisbn.worldcat.org/webservices/xid/isbn/$1?method=getMetadata&format=csv&fl=*"| tr \" " " >> $OUTPUT_FILE;
fi
