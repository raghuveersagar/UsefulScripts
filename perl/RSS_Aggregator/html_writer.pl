#!/usr/bin/perl -w
# Raghuveer Sagar

#This file handles each parsed file    

#required modules
require 'tags_generator.pl';
require 'helpers.pl';

#read predefined template file 
open my $INPUT,"<","page_template";
open my $OUTPUT,">","rss_aggregator.html";
my @templatelines = <$INPUT>;
close $INPUT;
foreach (@templatelines)
{
    print $OUTPUT  $_;
} 
close $OUTPUT;
foreach(@ARGV)
{
#Call sub to write output HTML file
    write_sub($_);
}
open  $OUTPUT,">>","rss_aggregator.html";
print $OUTPUT "<\/table>\n<\/body>\n<\/html>";
close $OUTPUT;
