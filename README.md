# nagios-check_cpu
check multiple processors via snmp

Example command definition
$USER1$/check_snmp_cpuload.pl $HOSTADDRESS$ '$ARG1$' $ARG2$ $ARG3$ $ARG4$

$ARG1$ = Community String
$ARG2$ = Warning
$ARG3$ = Critical
$Arg4$ = Performance Data Off/On [0/1]

output is:
'Status': Overall CPU load %%, CPU-n: %%, CPU-n1: %% | Performance data

Error state is met if any processor reaches the warning/critical values.
