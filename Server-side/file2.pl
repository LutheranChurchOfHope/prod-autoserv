#!/usr/bin/perl -W
use strict;
use warnings;
use Switch;


#system('sudo /opt/scripts/getter.sh');

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


#sub getArraysReady() {
		our @data;
#}

#sub getHashesReady () {
		# power
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
#}




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
			case m/bridge_mainLeft/ { %bridge_mainLeft = parseLine($x);
				print %bridge_mainLeft;}
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
		#DEBUG
#		print $data;
#		print "\n";
		
		our ($proj,$item,$type,$value) = split /,/, $data;
		#DEBUG
#		print 'proj '."$proj"."\n";
#		print 'item '."$item"."\n";
#		print 'type '."$type"."\n";
#		print 'value '."$value"."\n";
		
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
		#DEBUG
#		print $power;
#		print "\n\n";

		# initilize the hash we're about to use below..
		# ..with some "dummy" data:
		%hashName = (
			proj => 'no data',
			type => 'no data',
			power => 'no data',
		#	hoursAll => 'no data',
			hours1 => 'no data',
			hours2 => 'no data',
			hours3 => 'no data',
			hours4 => 'no data',
		);
		
		# put data we have into a temporary
		# hash, just for the fun of it:
		if (defined $proj) { $hashName{'proj'} = $proj; }
		if (defined $type) { $hashName{'type'} = $type; }
		if (defined $power) { $hashName{'power'} = $power; }
		if (defined $hoursAll) { $hashName{'hoursAll'} = $hoursAll; }
		if (defined $hours1) { $hashName{'hours1'} = $hours1; }
		if (defined $hours2) { $hashName{'hours2'} = $hours2; }
		if (defined $hours3) { $hashName{'hours3'} = $hours3; }
		if (defined $hours4) { $hashName{'hours4'} = $hours4; }
#		%hashName = (
#			proj => $proj,
#			type => $type,
#			power => $power,
#		#	hoursAll => $hoursAll,
#			hours1 => $hours1,
#			hours2 => $hours2,
#			hours3 => $hours3,
#			hours4 => $hours4,
#		);
#		print %hashName;

		# return our temporary hash,
		# just for the fun of it:
		return %hashName;
}

sub printStuff() {

	# print stuff out to JavaScript

	#if (defined $bridge_mainLeft{'power'}) {
		print 'var bridge_mainLeft_power = '.$bridge_mainLeft{"power"}."\n";
	#} else {
	#	print 'var bridge_mainLeft_power = GEEK_ERR'."\n";
	#}

	if (defined $bridge_mainRight{'power'}) {
		print 'var bridge_mainRight_power = '.$bridge_mainRight{"power"}."\n";
	} else {
		print 'var bridge_mainRight_power = GEEK_ERR'."\n";
	}

	if (defined $bridge_mainCenter{'power'}) {
		print 'var bridge_mainCenter_power = '.$bridge_mainCenter{"power"}."\n";
	} else {
		print 'var bridge_mainCenter_power = GEEK_ERR'."\n";
	}

	if (defined $bridge_foldbackCenter{'power'}) {
		print 'var bridge_foldbackCenter_power = '.$bridge_foldbackCenter{"power"}."\n";
	} else {
		print 'var bridge_foldbackCenter_power = GEEK_ERR'."\n";
	}

	if (defined $chapel_mainSide{'power'}) {
		print 'var chapel_mainSide_power = '.$chapel_mainSide{"power"}."\n";
	} else {
		print 'var chapel_mainSide_power = GEEK_ERR'."\n";
	}
	
	if (defined $chapel_mainCenter{'power'}) {
		print 'var chapel_mainCenter_power = '.$chapel_mainCenter{"power"}."\n";
	} else {
		print 'var chapel_mainCenter_power = GEEK_ERR'."\n";
	}

	if (defined $chapel_foldbackSide{'power'}) {
		print 'var chapel_foldbackSide_power = '.$chapel_foldbackSide{"power"}."\n";
	} else {
		print 'var chapel_foldbackSide_power = GEEK_ERR'."\n";
	}
}

#print 'var bridge_mainLeft_hours = '.$bridge_mainLeft{"hours"}."\n";
#print 'var bridge_mainRight_hours = '.$bridge_mainRight{"hours"}."\n";
#print 'var bridge_mainCenter_hours = '.$bridge_mainCenter{"hours"}."\n";
#print 'var bridge_foldbackCenter_hours = '.$bridge_foldbackCenter{"hours"}."\n";
#print 'var chapel_mainSide_hours = '.$chapel_mainSide{"hours"}."\n";
#print 'var chapel_mainCenter_hours = '.$chapel_mainCenter{"hours"}."\n";
#print 'var chapel_foldbackSide_hours = '.$chapel_foldbackSide{"hours"}."\n";


#&getHashesReady;
#&getArraysReady;
doFileRead;
#&printFileStuff;
lineByLine;
printStuff;

