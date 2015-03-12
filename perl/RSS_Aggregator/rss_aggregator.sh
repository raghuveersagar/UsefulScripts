#!/bin/bash
#Raghuveer Sagar

count=0
feedfiles=""
parsedfiles=""
chmod 700 parseFeed.awk  html_writer.pl 
while read line ;do
    count=`expr $count + 1`
    #Download feed XMLs
    wget -q -O "$count.feed" "$line" 
    #Call the XML Parser Module
    parseFeed.awk "$count.feed" "$count.parsed"
    feedfiles="$feedfiles $count.feed"
    parsedfiles="$parsedfiles $count.parsed"
done < feeds 
#Call the html generator module
html_writer.pl $parsedfiles
rm -f $parsedfiles
rm -f $feedfiles 
