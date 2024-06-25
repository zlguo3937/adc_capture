#!/usr/local/bin/perl
use strict;

my $str = "To be or not to be, it’s a question.";
if ( $str =~ /(.+)/ ) {
  print "Matched is: ", $1, "\n";
}

exit 0;
