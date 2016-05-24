#!/usr/bin/perl -W
use strict;
use warnings;
use Switch;


#system('sudo /opt/scripts/getter.sh');

#&getHashesReady;
#&getArraysReady;
&doFileRead;
#&printFileStuff;
&testCaseSwitch;

our @status;
sub getArraysReady() {
        our @status;
}

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
        our %rm101a_mainCenter;
        our %rm101c_mainCenter;
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

sub printFileStuff() {
        foreach my $x (@status) {
        #       print $x;
        #       print "\n"
                if ($x =~ 'panasonicPJLink') {
                print $x."\n";
                } else {
                print "not panasonic PJ Link \n";
                } 
        }
}

sub testCaseSwitch() {
        foreach my $x (@status) {
                switch ($x) {
                        #case m/bridge_mainLeft/ { print $x; }
                        case m/bridge_mainLeft/ { %bridge_mainLeft = &parseLine($x); }
                        #case m/bridge_mainLeft/ { &parseLine($x); }
                }
        }
}

sub parseLine($) {
        my $data = shift;
        my($proj,$item,$type,$status) = split /,/, $data;
        #print "projector: $proj\n";
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
