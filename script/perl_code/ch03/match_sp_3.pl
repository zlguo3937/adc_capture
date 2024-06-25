#!/usr/local/bin/perl
use strict;

my $str = "To be or not to be, it’s a question.";
if ( $str =~ /be(.{4})/ ) {
  print "Matched is: ", $1, "\n";
}

exit 0;
