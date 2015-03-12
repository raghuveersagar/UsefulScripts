#!/usr/bin/awk -f
#Ajinkya Kale
#remove second arg as it is not a existing filename
BEGIN{filename=ARGV[2];delete ARGV[2] }

#extract channel info
$1 ~ /<channel>/,/<description>/ {
    if ($0 ~ /<title>/){
	match($0,/<title>(.*)<\/title>/,temp)
	print "channel:"temp[1] >>filename 
    }
    if ($0 ~ /<link>/){
	match($0,/<link>(.*)<\/link>/,link)
	print "mainlink:"link[1] >>filename 
    }
}

#extract item info
$1 ~ /<item>/,/<\/item>/ {
    if ( $0 ~ /<title>/){
	match ($0, /<title>(.*)<\/title>/, x)
	print "headline:"x[1]>>filename
    }
    if ($0 ~ /<link>/){
	match ($0,/<link>(.*)<\/link>/,y)
	print "link:"y[1] >>filename
    }
    if ($0 ~ /<guid[^>]*>/){
	match ($0, /<guid[^>]*>(.*)<\/guid>/,z)
	print "guid:"z[1] >>filename
    }
#convert date format and time zone
    if ($0 ~ /<pubDate>/){
	match ($0,/.*<pubDate>(.*)<\/pubDate>.*$/, a)
	command1="date -d '"a[1]"'"
	command1|getline;close (command1);
	command2="date --date=\""$0"\" '+%y/%m/%d %H:%M %Z'"
	command2|getline;close (command2);print "pubdate:"$0 >>filename
    }
}
