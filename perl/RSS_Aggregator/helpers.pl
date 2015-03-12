#!/usr/bin/perl -w
# Raghuveer Sagar
use strict;
#sub create a 'link' tag
sub create_a_tag
{
(my $link,my $data,my $font)=@_;
my $a_tag="<a href=$link style=\"color:black;font-weight:bold;font-size:$font%\" target=\"_blank\">$data<\/a><br\/>";
return $a_tag;
}

#sub creates a 'tr' tag in html table
sub create_row
{
(my $cell1,my $cell2) = @_;
my $x = "<tr>\n<td>$cell1\n<\/td>\n<td>$cell2\n<\/td>\n<tr>\n";
return $x;
}
1;
