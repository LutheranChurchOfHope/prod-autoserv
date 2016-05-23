#!/usr/bin/perl -W
use strict;
use warnings;

our @status;

open (my $fh, "<", "/opt/data/projstatus/dumpstatus.txt")
        or die "Failed to open file $!\n";
while (my $x = <$fh>) {
        chomp $x;
        # the following two lines are redundant,
        # since they should be caught by the "getter"
        # script and Extron box, respectively.
        $x =~ s/%02//g;
        $x =~ s/%03//g;
        push @status, $x;
}

foreach my $x (@status) {
#       print $x;
#       print "\n"
        if ($x =~ 'panasonicPJLink') {
        print $x."\n";
        } else {
        print "not panasonic PJ Link \n";
        } 
}
