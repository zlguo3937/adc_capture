#!/usr/local/bin/perl

use strict "refs";

my $str = "sub_a";
&$str;

exit 0;

sub sub_a {
  print "sub_a done\n";
}
