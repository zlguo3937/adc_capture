#!/usr/local/bin/perl
use strict;
my $str = "1234567800";

if ( $str =~ /(.)(.)(.)(.)(.)(.)(.)(.)((.)\g{10})/ ) {
  print "Warning: $9\n";
}

exit 0;
