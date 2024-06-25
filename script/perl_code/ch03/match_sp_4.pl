#!/usr/local/bin/perl
use strict;
my @caps;
my $str = "To be or not to be, it’s a question.";
if ( @caps = $str =~ /be(.{4})/g ) {
  for my $cap ( @caps ){
    print "Matched is: ", $cap, "\n";
  }
}

exit 0;
