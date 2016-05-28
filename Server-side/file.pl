#!/usr/bin/perl -W
use strict;
use warnings;
use Switch;


#system('sudo /opt/scripts/getter.sh');

#&getHashesReady;
#&getArraysReady;
&doFileRead;
#&printFileStuff;
&lineByLine;

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
		foreach my $x (@data) {
			&parseLine($x);
		}
#				switch ($x) {
#						case m/bridge_mainLeft/ { %bridge_mainLeft = &parseLine($x); }
#						case m/bridge_mainRight/ { %bridge_mainRight = &parseLine($x); }
#						case m/bridge_mainCenter/ { %bridge_mainCenter = &parseLine($x); }
#						case m/bridge_foldbackCenter/ { %bridge_foldbackCenter = &parseLine($x); }
#						case m/chapel_mainSide/ { %chapel_mainSide = &parseLine($x); }
#						case m/chapel_mainCenter/ { %chapel_mainCenter = &parseLine($x); }
#						case m/chapel_foldbackCenter/ { %chapel_foldbackCenter = &parseLine($x); }
#						case m/gym_mainSide/ { %gym_mainSide = &parseLine($x); }
#						case m/well_mainCenter/ { %well_mainCenter = &parseLine($x); }
#						case m/rm101A_mainCenter/ { %rm101A_mainCenter = &parseLine($x); }
#						case m/rm101C_mainCenter/ { %rm101C_mainCenter = &parseLine($x); }
#						case m/rm102_mainCenter/ { %rm102_mainCenter = &parseLine($x); }
#						case m/rm104_mainCenter/ { %rm104_mainCenter = &parseLine($x); }
#						case m/rm128_mainCenter/ { %rm128_mainCenter = &parseLine($x); }
#						case m/rm212_mainCenter/ { %rm212_mainCenter = &parseLine($x); }
#						case m/rm214_mainCenter/ { %rm214_mainCenter = &parseLine($x); }
#						case m/rm216_mainCenter/ { %rm216_mainCenter = &parseLine($x); }
#						case m/rmRR1_mainCenter/ { %rmRR1_mainCenter = &parseLine($x); }
#				}
#		}
}
our ($status,$hoursAll,$hours1,$hours2,$hours3,$hours4);
sub parseLine($) {
		# declare some vars
		our %hashName;
		#our ($status,$hoursAll,$hours1,$hours2,$hours3,$hours4);
		# $data is whatever was passed to us
		my $data = shift;
		# split out the line from Extron box
		our ($proj,$type,$item,$value) = split /,/, $data;
		# determine what item (power, lamp hours, etc) we're
		# looking at, and act upon it.
		switch ($item) {
			case m/power/ {
				switch ($type) {
					case m/panasonicPJLink/ {
						switch ($value) {
							case m/000/ { $status = 'off'; }
							case m/001/ { $status = 'on'; }
						}
					}
					case m/sanyoPLC/ {
						switch ($value) {
							case m/00/ { $status = 'on'; }
							case m/80/ { $status = 'off'; }
							case m/40/ { $status = 'Countdown'; }
							case m/20/ { $status = 'Cooling Down'; }
							case m/10/ { $status = 'Power Malfunction'; }
							case m/28/ { $status = 'Cooling down at the temperature anomaly'; }
							case m/02/ { $status = 'Unable to receive the RC232C command.'; }
							case m/24/ { $status = 'Cooling down at Power Management mode'; }
							case m/04/ { $status = 'Power Management mode after Cooling down'; }
							case m/21/ { $status = 'Cooling down after the projector is turned off when the lamps are out.'; }
							case m/81/ { $status = 'Stand-by mode after Cooling down when the lamps are out.'; }
							case m/88/ { $status = 'Stand-by mode after Cooling down at the temperature anomaly.'; }
						}
					}
				}
			}
			case m/lampHoursAll/ {
				our ($hours1,$hours2,$hours3,$hours4) = split / /, $value;
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

		# put data we have into a temporary
		# hash, just for the fun of it:
		%hashName = (
			proj => $proj,
			type => $type,
			status => $status,
		#	hoursAll => $hoursAll,
			hours1 => $hours1,
			hours2 => $hours2,
			hours3 => $hours3,
			hours4 => $hours4,
		);

		# figure out what projector, and what data,
		# needs to be put into the appropriate hash
		switch ($proj) {
			case m/bridge_mainLeft/ {
				if ($status != '') { $bridge_mainLeft{'power'} = $status; }
				if ($hours1 != '') { $bridge_mainLeft{'hours1'} = $hours1; }
				if ($hours2 != '') { $bridge_mainLeft{'hours2'} = $hours2; }
				if ($hours3 != '') { $bridge_mainLeft{'hours3'} = $hours3; }
				if ($hours4 != '') { $bridge_mainLeft{'hours4'} = $hours4; }
			}
			case m/bridge_mainRight/ {
				if ($status != '') { $bridge_mainRight{'power'} = $status; }
				if ($hours1 != '') { $bridge_mainRight{'hours1'} = $hours1; }
				if ($hours2 != '') { $bridge_mainRight{'hours2'} = $hours2; }
				if ($hours3 != '') { $bridge_mainRight{'hours3'} = $hours3; }
				if ($hours4 != '') { $bridge_mainRight{'hours4'} = $hours4; }
			}
			case m/bridge_mainCenter/ {
				if ($status != '') { $bridge_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $bridge_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $bridge_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $bridge_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $bridge_mainCenter{'hours4'} = $hours4; }
			}
			case m/bridge_foldbackCenter/ {
				if ($status != '') { $bridge_foldbackCenter{'power'} = $status; }
				if ($hours1 != '') { $bridge_foldbackCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $bridge_foldbackCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $bridge_foldbackCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $bridge_foldbackCenter{'hours4'} = $hours4; }
			}
			case m/chapel_mainSide/ {
				if ($status != '') { $chapel_mainSide{'power'} = $status; }
				if ($hours1 != '') { $chapel_mainSide{'hours1'} = $hours1; }
				if ($hours2 != '') { $chapel_mainSide{'hours2'} = $hours2; }
				if ($hours3 != '') { $chapel_mainSide{'hours3'} = $hours3; }
				if ($hours4 != '') { $chapel_mainSide{'hours4'} = $hours4; }
			}
			case m/chapel_mainCenter/ {
				if ($status != '') { $chapel_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $chapel_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $chapel_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $chapel_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $chapel_mainCenter{'hours4'} = $hours4; }
			}
			case m/chapel_foldbackSide/ {
				if ($status != '') { $chapel_foldbackSide{'power'} = $status; }
				if ($hours1 != '') { $chapel_foldbackSide{'hours1'} = $hours1; }
				if ($hours2 != '') { $chapel_foldbackSide{'hours2'} = $hours2; }
				if ($hours3 != '') { $chapel_foldbackSide{'hours3'} = $hours3; }
				if ($hours4 != '') { $chapel_foldbackSide{'hours4'} = $hours4; }
			}
			case m/gym_mainSide/ {
				if ($status != '') { $gym_mainSide{'power'} = $status; }
				if ($hours1 != '') { $gym_mainSide{'hours1'} = $hours1; }
				if ($hours2 != '') { $gym_mainSide{'hours2'} = $hours2; }
				if ($hours3 != '') { $gym_mainSide{'hours3'} = $hours3; }
				if ($hours4 != '') { $gym_mainSide{'hours4'} = $hours4; }
			}
			case m/well_mainCenter/ {
				if ($status != '') { $well_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $well_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $well_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $well_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $well_mainCenter{'hours4'} = $hours4; }
			}
			case m/rmX_mainCenter/ {
				if ($status != '') { $rmX_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rmX_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rmX_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rmX_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rmX_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm101A_mainCenter/ {
				if ($status != '') { $rm101A_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm101A_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm101A_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm101A_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm101A_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm101C_mainCenter/ {
				if ($status != '') { $rm101C_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm101C_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm101C_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm101C_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm101C_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm102_mainCenter/ {
				if ($status != '') { $rm102_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm102_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm102_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm102_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm102_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm104_mainCenter/ {
				if ($status != '') { $rm104_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm104_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm104_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm104_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm104_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm128_mainCenter/ {
				if ($status != '') { $rm128_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm128_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm128_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm128_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm128_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm212_mainCenter/ {
				if ($status != '') { $rm212_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm212_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm212_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm212_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm212_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm214_mainCenter/ {
				if ($status != '') { $rm214_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm214_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm214_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm214_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm214_mainCenter{'hours4'} = $hours4; }
			}
			case m/rm216_mainCenter/ {
				if ($status != '') { $rm216_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rm216_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rm216_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rm216_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rm216_mainCenter{'hours4'} = $hours4; }
			}
			case m/rmRR1_mainCenter/ {
				if ($status != '') { $rmRR1_mainCenter{'power'} = $status; }
				if ($hours1 != '') { $rmRR1_mainCenter{'hours1'} = $hours1; }
				if ($hours2 != '') { $rmRR1_mainCenter{'hours2'} = $hours2; }
				if ($hours3 != '') { $rmRR1_mainCenter{'hours3'} = $hours3; }
				if ($hours4 != '') { $rmRR1_mainCenter{'hours4'} = $hours4; }
			}
		}
		# return our temporary hash,
		# just for the fun of it:
		return %hashName;

		#print %hashName;
}

sub printStuff() {

	# print stuff out to JavaScript

	if (defined $bridge_mainLeft{'status'}) {
		print 'var bridge_mainLeft_status = '.$bridge_mainLeft{"status"}."\n";
	} else {
		print 'var bridge_mainLeft_status = GEEK_ERR'."\n";
	}

	if (defined $bridge_mainRight{'status'}) {
		print 'var bridge_mainRight_status = '.$bridge_mainRight{"status"}."\n";
	} else {
		print 'var bridge_mainRight_status = GEEK_ERR'."\n";
	}

	if (defined $bridge_mainCenter{'status'}) {
		print 'var bridge_mainCenter_status = '.$bridge_mainCenter{"status"}."\n";
	} else {
		print 'var bridge_mainCenter_status = GEEK_ERR'."\n";

	if (defined $bridge_foldbackCenter{'status'}) {
		print 'var bridge_foldbackCenter_status = '.$bridge_foldbackCenter{"status"}."\n";
	} else {
		print 'var bridge_foldbackCenter_status = GEEK_ERR'."\n";
	}

	if (defined $chapel_mainSide{'status'}) {
		print 'var chapel_mainSide_status = '.$chapel_mainSide{"status"}."\n";
	} else {
		print 'var chapel_mainSide_status = GEEK_ERR'."\n";
	}
	
	if (defined $chapel_mainCenter{'status'}) {
		print 'var chapel_mainCenter_status = '.$chapel_mainCenter{"status"}."\n";
	} else {
		print 'var chapel_mainCenter_status = GEEK_ERR'."\n";
	}

	if (defined $chapel_foldbackSide{'status}) {
		print 'var chapel_foldbackSide_status = '.$chapel_foldbackSide{"status"}."\n";
	} else {
		print 'var chapel_foldbackSide_status = GEEK_ERR'."\n";
	}

#print 'var bridge_mainLeft_hours = '.$bridge_mainLeft{"hours"}."\n";
#print 'var bridge_mainRight_hours = '.$bridge_mainRight{"hours"}."\n";
#print 'var bridge_mainCenter_hours = '.$bridge_mainCenter{"hours"}."\n";
#print 'var bridge_foldbackCenter_hours = '.$bridge_foldbackCenter{"hours"}."\n";
#print 'var chapel_mainSide_hours = '.$chapel_mainSide{"hours"}."\n";
#print 'var chapel_mainCenter_hours = '.$chapel_mainCenter{"hours"}."\n";
#print 'var chapel_foldbackSide_hours = '.$chapel_foldbackSide{"hours"}."\n";
