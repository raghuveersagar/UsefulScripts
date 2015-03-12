#Script to create new user accounts in unix for admins

#!/usr/bin/perl
#Raghuveer Sagar

use strict;
use warnings;

#start uid counter
my $uid = 101;

#create path string templates
my $pathstu_ = "/home/student/";
my $pathfac_ = "/home/faculty/";

#create shell string templates
my $shellstu_ = "/bin/bash";
my $shellfac_ = "/bin/tcsh";

my $usernames = "#";

#create anonymous rot13 sub
my $rot13 = sub {
	( my $tmp = lc $_[0] ) =~ tr/a-z/n-za-m/;
	return $tmp;
};

open INPUT, "<", $ARGV[0];
foreach (<INPUT>) {
	( my $name, my $ssn, my $status ) = split('/');
	chomp $status;

	#handle bad ssn
	if ( $ssn !~ /^.{3}-.{2}-.{4}$/ ) {
		print STDERR "Bad Soc: $ssn\n";
		next;
	}

	#extract username
	( my $usrname1 = lc $name ) =~ s/^(.).* (.).* (.).*$/$1$2$3/;
	( my $usrname2 = $ssn )     =~ s/^[^-]*-[^-]*-(.*)$/$1/;
	my $usrname = ( $status eq "student" ) ? $usrname1 . $usrname2 : $usrname1;

	#handle duplicate username
	if ( ( index $usernames, "#$usrname#" ) >= 0 ) {
		print STDERR "Duplicate Name: $usrname\n";
		next;

	}

	#keep track of usernames
	$usernames = $usernames . $usrname . "#";

	#read in the password
	my $rawpsswd = <STDIN>;
	chomp $rawpsswd;

	#encrypt password
	my $encrpasswd = $rot13->($rawpsswd);
	my $gid = ( $status eq "student" ) ? 505 : 1010;
	my $homedir =
	  ( $status eq "student" ) ? $pathstu_ . $usrname : $pathfac_ . $usrname;
	my $shell = ( $status eq "student" ) ? $shellstu_ : $shellfac_;

	#final output
	print "$usrname:$encrpasswd:$uid:$gid:$name:$homedir:$shell\n";
	$uid++;

}
