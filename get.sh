#!/bin/bash
ISBN_BAZA="isbn.txt"
OUTPUT_FILE="test.csv"
NOL=$(grep -c ^ $ISBN_BAZA)
i=0

if [ ! -f $OUTPUT_FILE ]
then
    echo "Input,ISBN,ID1,ID2,Wydanie,Tytuł,ID3,Język,Rok wydania,Autor,Wydawnictwo,Miasto,ID5,Język oryginału,Żródło danych" > $OUTPUT_FILE
fi

echo "Number of ISBN to process:" $NOL;


while read ISBN
do
	((i++));
	printf -- "%s;%d-%d," $ISBN $i $NOL >> $OUTPUT_FILE;
	curl -s  "http://xisbn.worldcat.org/webservices/xid/isbn/$ISBN?method=getMetadata&format=csv&fl=*"| tr \" " " >> $OUTPUT_FILE;
	echo "Processing IBSN $ISBN, $i out of $NOL";
done < $ISBN_BAZA
