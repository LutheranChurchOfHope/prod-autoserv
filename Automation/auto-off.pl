#!/usr/bin/perl -W

# location:
# /opt/scripts/projector-automation/auto-off.pl

use strict;
use warnings;

our @data;

sub doStuff {
	open (my $fh, "<", "/var/www/html/javascript/auto-off.js")
		or die "Failed to open file $!\n";
	while (my $x = <$fh>) {
		# cut off the trailing newline
		chomp $x;
		if ($x =~ m/enabled/) { system('/opt/scripts/projector-automation/run_auto-off.sh'); }
		if ($x =~ m/disabled/) { system('/opt/scripts/projector-automation/no_auto-off.sh'); }
		# Next two lines were just for testing:
		# if ($x =~ m/enabled/) { system('/bin/echo enabled'); }
		# if ($x =~ m/disabled/) { system('/bin/echo disabled'); }
	}
}

doStuff;
