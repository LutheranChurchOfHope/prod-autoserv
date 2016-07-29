#!/usr/bin/perl -W
use strict;
use warnings;
use Switch;

# Put this file at "/opt/scripts/file.pl"
# for use with "prod-autoserv".

sub getData {
	system('/opt/scripts/getter.sh');
}

# 0. have "getter" get stuff, before this script runs
# 1. Get variables ready
# 2. Read everything in
# 3. Make sure there's no %02 or %03
# 4. Put it all in array @data
# 5. Go line-by-line and grab statuses
# 6. As going line by line and grabbing, store in hash
# 7. Print stuff (parsed!) back out as necessary.
# 8. Web pages will read written-out stuff as JavaScript


# places that unit-specific code is kept:
# 1. initializing variables (hashes)
# 2. switch/case under "line by line" subroutine
# 3. "print" lines at the end
# 	(twice per line, and two lines per projector!)
# 4.


# vars and such:
our @data;
our %bridge_mainLeft;
our %bridge_mainRight;
our %bridge_mainCenter;
our %bridge_foldbackCenter;
our %chapel_mainSide;
our %chapel_mainCenter;
our %chapel_foldbackSide;
our %gym_mainSide;
our %well_mainCenter;
our %rm101A_mainCenter;
our %rm101C_mainCenter;
our %rm102_mainCenter;
our %rm104_mainCenter;
our %rm128_mainCenter;
our %rm212_mainCenter;
our %rm214_mainCenter;
our %rm216_mainCenter;
our %rmRR1_mainCenter;
our %rmXX_mainCenter;


sub doFileRead() {
		open (my $fh, "<", "/opt/data/projstatus/dumpstatus.txt")
				or die "Failed to open file $!\n";

		while (my $x = <$fh>) {
				# cut off the trailing newline
				chomp $x;
				# the following two lines are redundant,
				# since they should be caught by the "getter"
				# script and Extron box, respectively.
				$x =~ s/%02//g;
				$x =~ s/%03//g;
				# append line $x to array @data
				push @data, $x;
		}
}

#sub printFileStuff() {
#		foreach my $x (@status) {
#				if ($x =~ 'panasonicPJLink') {
#				print $x."\n";
#				} else {
#				print "not panasonic PJ Link \n";
#				} 
#		}
#}

sub lineByLine() {
	my $x;
	foreach $x (@data) {
		switch ($x) {
			case m/bridge_mainLeft/ { %bridge_mainLeft = parseLine($x); }
			case m/bridge_mainRight/ { %bridge_mainRight = parseLine($x); }
			case m/bridge_mainCenter/ { %bridge_mainCenter = parseLine($x); }
			case m/bridge_foldbackCenter/ { %bridge_foldbackCenter = parseLine($x); }
			case m/chapel_mainSide/ { %chapel_mainSide = parseLine($x); }
			case m/chapel_mainCenter/ { %chapel_mainCenter = parseLine($x); }
			case m/chapel_foldbackSide/ { %chapel_foldbackSide = parseLine($x); }
			case m/gym_mainSide/ { %gym_mainSide = parseLine($x); }
			case m/well_mainCenter/ { %well_mainCenter = parseLine($x); }
			case m/rm101A_mainCenter/ { %rm101A_mainCenter = parseLine($x); }
			case m/rm101C_mainCenter/ { %rm101C_mainCenter = parseLine($x); }
			case m/rm102_mainCenter/ { %rm102_mainCenter = parseLine($x); }
			case m/rm104_mainCenter/ { %rm104_mainCenter = parseLine($x); }
			case m/rm128_mainCenter/ { %rm128_mainCenter = parseLine($x); }
			case m/rm212_mainCenter/ { %rm212_mainCenter = parseLine($x); }
			case m/rm214_mainCenter/ { %rm214_mainCenter = parseLine($x); }
			case m/rm216_mainCenter/ { %rm216_mainCenter = parseLine($x); }
			case m/rmRR1_mainCenter/ { %rmRR1_mainCenter = parseLine($x); }
		}
	}
}
#TODO: try something like
#while ($item =~ m/(00|80|40|20|10|28|02|24|04|21|81|88)
#$status=$statusHashname{$1}
sub parseLine {
	# declare some vars
	our %hashName;
	our ($power,$hoursAll,$hours1,$hours2,$hours3,$hours4);
	# $data is whatever was passed to us
	my $data = shift;
	# split out the line from Extron box
	our ($proj,$item,$type,$value) = split /,/, $data;
	
	# determine what item (power, lamp hours, etc) we're
	# looking at, and act upon it.
	switch ($item) {
		case m/power/ {
			switch ($type) {
				case m/panasonicPJLink/ {
					switch ($value) {
						case m/000/ { $power = 'off'; }
						case m/001/ { $power = 'on'; }
					}
				}
				case m/sanyoPLC/ {
					switch ($value) {
						case m/00/ { $power = 'on'; }
						case m/80/ { $power = 'off'; }
						case m/40/ { $power = 'Countdown'; }
						case m/20/ { $power = 'Cooling Down'; }
						case m/10/ { $power = 'Power Malfunction'; }
						case m/28/ { $power = 'Cooling down at the temperature anomaly'; }
						case m/02/ { $power = 'Unable to receive the RC232C command.'; }
						case m/24/ { $power = 'Cooling down at Power Management mode'; }
						case m/04/ { $power = 'Power Management mode after Cooling down'; }
						case m/21/ { $power = 'Cooling down after the projector is turned off when the lamps are out.'; }
						case m/81/ { $power = 'Stand-by mode after Cooling down when the lamps are out.'; }
						case m/88/ { $power = 'Stand-by mode after Cooling down at the temperature anomaly.'; }
					}
				}
			}
		}
		case m/lampHoursAll/ {
			($hours1,$hours2,$hours3,$hours4) = split / /, $value;
		}
		case m/lampHours1/ {
			$hours1 = $value;
		}
		case m/lampHours2/ {
			$hours2 = $value;
		}
		case m/lampHours3/ {
			$hours3 = $value;
		}
		case m/lampHours4/ {
			$hours4 = $value;
		}
	}
		# initilize the hash we're about to use below..
		# ..with some "dummy" data:
		%hashName = (
			proj => 'NO_DATA',
			type => 'NO_DATA',
			power => 'NO_DATA',
		#	hoursAll => 'NO_DATA',
			hours1 => 'NO_DATA',
			hours2 => 'NO_DATA',
			hours3 => 'NO_DATA',
			hours4 => 'NO_DATA',
		);
		
		%hashName = (
			proj => $proj,
			type => $type,
			power => $power,
		#	hoursAll => $hoursAll,
			hours1 => $hours1,
			hours2 => $hours2,
			hours3 => $hours3,
			hours4 => $hours4,
		);
#		print %hashName;

		# return our temporary hash,
		# just for the fun of it:
		return %hashName;
}

sub printStuff {
	my $projvar = shift;
	if (defined $projvar ) { print "\'".$projvar."\'"; } else { print "\'".'GEEK_ERR'."\'"; }
	#print ';'."\n";
}

sub printer() {

	print 'function readVars() {';
	print "\n";

	# print stuff out to JavaScript

	print 'bridge_mainLeft_power = ';
	printStuff($bridge_mainLeft{'power'});
	print ';'."\n";
	print 'bridge_mainLeft_hours = ';
	printStuff($bridge_mainLeft{'hours1'});
	print ', ';
	printStuff($bridge_mainLeft{'hours2'});
	print ', ';
	printStuff($bridge_mainLeft{'hours3'});
	print ', ';
	printStuff($bridge_mainLeft{'hours4'});
	print ';'."\n";

	print 'bridge_mainRight_power = ';
	printStuff($bridge_mainRight{'power'});
	print ';'."\n";

	print 'bridge_mainCenter_power = ';
	printStuff($bridge_mainCenter{'power'});
	print ';'."\n";

	print 'bridge_foldbackCenter_power = ';
	printStuff($bridge_foldbackCenter{'power'});
	print ';'."\n";

	print 'chapel_mainSide_power = ';
	printStuff($chapel_mainSide{'power'});
	print ';'."\n";
	
	print 'chapel_mainCenter_power = ';
	printStuff($chapel_mainCenter{'power'});
	print ';'."\n";

	print 'chapel_foldbackSide_power = ';
	printStuff($chapel_foldbackSide{'power'});
	print ';'."\n";

	print 'gym_mainSide_power = ';
	printStuff($gym_mainSide{'power'});
	print ';'."\n";

	print 'well_mainCenter_power = ';
	printStuff($well_mainCenter{'power'});
	print ';'."\n";

	print 'rm101A_mainCenter_power = ';
	printStuff($rm101A_mainCenter{'power'});
	print ';'."\n";

	print 'rm101C_mainCenter_power = ';
	printStuff($rm101C_mainCenter{'power'});
	print ';'."\n";

	print 'rm102_mainCenter_power = ';
	printStuff($rm102_mainCenter{'power'});
	print ';'."\n";

	print 'rm104_mainCenter_power = ';
	printStuff($rm104_mainCenter{'power'});
	print ';'."\n";

	print 'rm128_mainCenter_power = ';
	printStuff($rm128_mainCenter{'power'});
	print ';'."\n";

	print 'rm212_mainCenter_power = ';
	printStuff($rm212_mainCenter{'power'});
	print ';'."\n";

	print 'rm214_mainCenter_power = ';
	printStuff($rm214_mainCenter{'power'});
	print ';'."\n";

	print 'rm216_mainCenter_power = ';
	printStuff($rm216_mainCenter{'power'});
	print ';'."\n";

	print 'rmRR1_mainCenter_power = ';
	printStuff($rmRR1_mainCenter{'power'});
	print ';'."\n";

	print 'rmXX_mainCenter_power = ';
	printStuff($rmXX_mainCenter{'power'});
	print ';'."\n";
	
	print '}';
	print "\n";

}

#print 'var bridge_mainLeft_hours = '.$bridge_mainLeft{"hours"}."\n";
#print 'var bridge_mainRight_hours = '.$bridge_mainRight{"hours"}."\n";
#print 'var bridge_mainCenter_hours = '.$bridge_mainCenter{"hours"}."\n";
#print 'var bridge_foldbackCenter_hours = '.$bridge_foldbackCenter{"hours"}."\n";
#print 'var chapel_mainSide_hours = '.$chapel_mainSide{"hours"}."\n";
#print 'var chapel_mainCenter_hours = '.$chapel_mainCenter{"hours"}."\n";
#print 'var chapel_foldbackSide_hours = '.$chapel_foldbackSide{"hours"}."\n";



sub doEverythingInScript {
	getData;
	#&getHashesReady;
	#&getArraysReady;
	doFileRead;
	#&printFileStuff;
	lineByLine;
	printer;
}
doEverythingInScript;