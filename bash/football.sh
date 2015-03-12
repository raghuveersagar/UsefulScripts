#This script Downloads previous year NFL standings and 
#calculates Strength of Schedule

#!/bin/bash 
# Raghuveer Sagar
present_date=`date +%Y`
year=$1

#Performs basic checks like "correct arguments" and "valid year" 
basic_check()
{
    if [ $1 -ne 1 ];then
	echo "usage calculate.sh year" >&2
	exit 1
    fi

    if [ $year -gt $present_date ];then
	echo "Invalid year :'$year'!.Enter year <= $present_date"
	exit 2
    fi
}


#Sets traps for 3 signals SIGINT SIGQUIT SIGTERM
set_traps()
{ 
    trap "echo SIGINT;cleanup;exit 3" SIGINT
    trap "echo SIGQUIT;cleanup;exit 3" SIGQUIT
    trap "echo SIGTERM;cleanup;exit 3" SIGTERM
}

tempfiles="standings tbodies trs tds points_table schedule points temp_final"

#Rmoves all temporary files
cleanup ()
{
    for file in $tempfiles;do
	if [ -f $file ];then
	    rm -f $file
	fi
    done
}

#checks to see if standings file exists or else downloads it
download()
{
    standing_file_name="standings.$((year-1)).download"
    url="http://www.nfl.com/standings?category=div&season=$((year-1))-REG"
    if [ -f $standing_file_name ];then
	cp $standing_file_name standings
    else
	wget -q $url -O $standing_file_name >/dev/null
	cp $standing_file_name standings
    fi
}


#create well formed standings table from HTML table data
create_table()
{
    cat standings|tr '\n' "  "|tr '\t' " "|tr -s " "|sed 's/<tbody>/~/g'|sed 's/<\/tbody>/~/g' >tbodies
    >points_table
    tbody_fields="2 3"
    tr_fields="4 5 6 7 10 11 12 13 16 17 18 19 22 23 24 25"
    for fields in $tbody_fields;do
	cat tbodies |cut -d~ -f$fields|sed 's/<tr[^>]*> /~/g'|sed 's/<\/tr> /~/g'|tr -s '~' >trs
	for  f in $tr_fields;do
	    cat trs |cut -d~ -f$f|sed 's/<td[^>]*>/~/g'|sed 's/<\/td> /~/g'|tr -s '~' >tds
	    paste <(cat tds |cut -d~ -f2 |sed 's/[^>]*> \(.*\) <\/a>/\1:/') <(cut -d~ -f3-5 tds)|tr '\t' " "|tr -s " "|tr '~' ':'|tr -d " " >>points_table
	    #cut -d~ -f3-5 tds
	done
    done
    #rm standings tbodies trs tds
}


#replace the names of teams in the table formed above by their nicknames
create_table_nicknames()
{
    #Remove  BYE and @ and sort according to field 1
    cat "schedule.$year.download"|sed '/^ *$/d'|sed 's/\tBYE//g'|tr -d '@'|sort -k1 > schedule
    #Sort Fullnames of Points table and LUT and replace Fullnames of Points table bu LUT field.The result is sorted according to short name and replaced with short names from schedule created earlier because of 2 short names are different 
   
     paste -d: <(cat schedule|cut -f1) <(paste -d: <(cat LUT|tr -d " "|sort -t: -k2|cut -d: -f1) <(cat points_table |sort -t: -k1|cut -d: -f2-4)|sort -t: -k1|cut -d: -f2-4) > points
}



#calculate SOS 
calculate_sos()
{
    >temp_final
    declare -i win
    declare -i tie
    declare -i loss
    while read line;do
	z=`echo $line|cut -d" " -f1`
	teams=`echo $line|cut -d" " -f2-`
	win=0
	tie=0
	loss=0
	for team in $teams ;do
	    win=win+`grep ^$team points|cut -d: -f2`
	    tie=tie+`grep ^$team points|cut -d: -f4`
	    loss=loss+`grep ^$team points|cut -d: -f3`
	done
	sos=`echo "scale=5;($win+0.5*$tie)/256"|bc`
	printf "%s %.3f %s\n" "$z" "$sos" "$win-$loss-$tie">> temp_final
	done< schedule
    while read line;do
	s1=`echo $line|cut -d: -f3`
	s2=`echo $line|cut -d: -f1|bc`
	s3=`echo $line|cut -d: -f2`

	printf "%-20s %7s   %8s\n" "$s1" "$s2" "$s3"
    done < <(paste -d: <(cat temp_final|cut -d" " -f2) <(cat temp_final|cut -d" " -f3) <(cat LUT|sort -k1|cut -d: -f2) |sort -t: -k1,1nr -k3,3)
}




basic_check $#
set_traps
download
create_table
create_table_nicknames
calculate_sos
cleanup

