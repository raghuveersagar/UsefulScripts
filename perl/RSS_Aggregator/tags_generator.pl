#!/usr/bin/perl -w
#Raghuveer Sagar

#This file parses the whole 'Parsed' file and extracts information to add to the tags in the html file 

require 'helpers.pl';
sub write_sub
{
($filename) = @_;
open my $OUTPUT,">>","rss_aggregator.html";
open my $INPUT,"<","$filename";
my @alllines = <$INPUT>;
close $INPUT;
$count=0;
foreach (@alllines)
{
(my $tmp,$channel) =split(':',$_,2) if ($_ =~ /^channel/);
if ($_ =~ /^mainlink/)
{
($tmp,$mainlink)=split(':',$_,2);
$count++;
last;
}
$count++;
}
my $tag = create_a_tag($mainlink,$channel,150);
print $OUTPUT "<tr>\n<td>".$tag."<\/td>\n<td><\/td>\n</tr>\n";
while ($count < $#alllines)
{
    $count_in=0;
    while($count_in < 4)
{
(my $tmp,$headline)=split(':',$alllines[$count+$count_in],2) if $alllines[$count+$count_in]=~/headline/;
($tmp,$link) = split(':',$alllines[$count+$count_in],2) if $alllines[$count+$count_in]=~/link/;
($tmp,$pubdate)=split(':',$alllines[$count+$count_in],2) if $alllines[$count+$count_in]=~/pubdate/;
$count_in++;
}
chomp($pubdate);
chomp($headline);
chomp($link);
$count=$count+4;
#create tags and then write them to file
my $tag=create_a_tag($link,$headline,100);
my $row = create_row($tag,$pubdate);
print $OUTPUT $row;
}
close $OUTPUT;
}
1;
