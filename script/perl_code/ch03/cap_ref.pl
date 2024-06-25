#!/usr/local/bin/perl
use strict;
my $str = "To bbe or not to be, it’s a question.";

if ( $str =~ /\b((.)\2\S*)\b/ ) {
  print "Warning: $1\n";
}

exit 0;
