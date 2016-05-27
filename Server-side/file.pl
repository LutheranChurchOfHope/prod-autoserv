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
# 4. Put it all in array @status
# 5. Go line-by-line and grab statuses
# 6. As going line by line and grabbing, store in hash
# 7. Print stuff (parsed!) back out as necessary.
# 8. Web pages will read written-out stuff as JavaScript


#sub getArraysReady() {
		our @status;
#}

#sub getHashesReady () {
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
				chomp $x;
				# the following two lines are redundant,
				# since they should be caught by the "getter"
				# script and Extron box, respectively.
				$x =~ s/%02//g;
				$x =~ s/%03//g;
				push @status, $x;
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
		foreach my $x (@status) {
				switch ($x) {
						case m/bridge_mainLeft/ { %bridge_mainLeft = &parseLine($x); }
						case m/bridge_mainRight/ { %bridge_mainRight = &parseLine($x); }
						case m/bridge_mainCenter/ { %bridge_mainCenter = &parseLine($x); }
						case m/bridge_foldbackCenter/ { %bridge_foldbackCenter = &parseLine($x); }
						case m/chapel_mainSide/ { %chapel_mainSide = &parseLine($x); }
						case m/chapel_mainCenter/ { %chapel_mainCenter = &parseLine($x); }
						case m/chapel_foldbackCenter/ { %chapel_foldbackCenter = &parseLine($x); }
						case m/gym_mainSide/ { %gym_mainSide = &parseLine($x); }
						case m/well_mainCenter/ { %well_mainCenter = &parseLine($x); }
						case m/rm101A_mainCenter/ { %rm101A_mainCenter = &parseLine($x); }
						case m/rm101C_mainCenter/ { %rm101C_mainCenter = &parseLine($x); }
						case m/rm102_mainCenter/ { %rm102_mainCenter = &parseLine($x); }
						case m/rm104_mainCenter/ { %rm104_mainCenter = &parseLine($x); }
						case m/rm128_mainCenter/ { %rm128_mainCenter = &parseLine($x); }
						case m/rm212_mainCenter/ { %rm212_mainCenter = &parseLine($x); }
						case m/rm214_mainCenter/ { %rm214_mainCenter = &parseLine($x); }
						case m/rm216_mainCenter/ { %rm216_mainCenter = &parseLine($x); }
						case m/rmRR1_mainCenter/ { %rmRR1_mainCenter = &parseLine($x); }
				}
		}
}

sub parseLine($) {
		my $data = shift;
		my($proj,$item,$type,$status) = split /,/, $data;
	#	switch ($type) {
		my %hashName = (
				proj => $proj,
				item => $item,
				type => $type,
				status => $status,
		);
		return %hashName;
		#print %hashName;
}

print $bridge_mainLeft{"status"}."\n";
