#!/usr/bin/perl
# Original Author : jakubowski Benjamin
# Date : 19/12/2005
# Update Date : 10/7/2015
# check_snmp_cpuload.pl IP COMMUNITY warning critical perf[0/1]

sub print_usage {
    print "check_win_snmp_cpuload.pl IP COMMUNITY warning critical perf[0/1]\n";
}

$PROGNAME = "check_snmp_cpuload.pl";

if  ( @ARGV[0] eq "" || @ARGV[1] eq "" || @ARGV[2] eq "" || @ARGV[3] eq "" || (@ARGV[4] ne "0" && @ARGV[4] ne "1")) {
    print_usage();
    exit 0;
}

$IP=@ARGV[0];
$COMMUNITY=@ARGV[1];
$warning=@ARGV[2];
$critical=@ARGV[3];
$perfannounce=@ARGV[4];
$i=0;
$warn=0;
$crit=0;
$strout=undef;
$perfvalue=undef;

##############

$resultat =`snmpwalk -v 1 -c $COMMUNITY $IP 1.3.6.1.2.1.25.3.3.1.2`;

if ( $perfannounce == 1 ) {
	$perfvalue = " | "
	}

if ( $resultat ) {
    @pourcentage = split (/\n/,$resultat);
    $j=0;
    foreach ( @pourcentage ) {
	s/HOST-RESOURCES-MIB::hrProcessorLoad.\d+ = INTEGER:.//g;	
	$use_total+=$_;
        $j++;
    }
    $use = $use_total / $j;

# Getting Individual CPU Load
    foreach ( @pourcentage ) {
	s/HOST-RESOURCES-MIB::hrProcessorLoad.\d+ = INTEGER:.//g;	
	$cpuuse=$_;
	$strout=$strout . ", CPU-$i: $cpuuse%";
	if ( $cpuuse >= $warning && $cpuuse < $critical ) {$warn++};
	if ( $cpuuse >= $critical ) {$crit++};
	if ( $perfannounce == 1 ) {$perfvalue .= "CPU-$i=$cpuuse%;$warning;$critical;0;100 "};
	$i++;
    }
    if ( $crit == 0 && $warn == 0 ) {
		print "OK: Overall CPU load $use%".$strout.$perfvalue."\n";
		exit 0;
    } elsif ( $warn != 0 && $crit == 0 ) {
        print "WARNING: Overall CPU load $use%".$strout.$perfvalue."\n";
		exit 1;
    } else {
        print "CRITICAL: Overall CPU load $use%".$strout.$perfvalue."\n";
		exit 2;
    }
} else {
    print "Unknown  : No response\n";
    exit 3;
}
