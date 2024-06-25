#!/usr/local/bin/perl

use strict;
use warnings;

my ($num, $pre, $pc);

my %cof = ( '0b' => 'b', '0' => 'o', '0x' => 'x' );
my $bitn = 0b0101 ;

printf "\$bitn = %s%04b\n", "0b", $bitn ;

for ( @ARGV ) {
  if ( /^(0b)[01]{4}$/ || /^(0x)[\da-f]{4}$/i || /^(0)[0-7]{4}$/ ) {
    $pre = $1 ;
    $pc  = $cof{$pre};
    $num = oct();
    print $_, "\n";
    print  q{ }x4, "decimal: ", $num, "\n";
    printf "    $_ | \$bitn : %s%04$pc\n", $pre, ($num | $bitn);
    printf "    $_ & \$bitn : %s%04$pc\n", $pre, ($num & $bitn);
    printf "    $_ ^ \$bitn : %s%04$pc\n", $pre, ($num ^ $bitn);
  }
  else {
    print "unknown input: $_\n";
    next;
  }
}

exit 0;
