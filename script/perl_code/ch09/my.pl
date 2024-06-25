#!/usr/local/bin/perl

if ( 1 ) {
  my $str = "abc";
  print "in if: $str\n";
}

if ( defined $str ) {
  print "out if: $str\n";
}
else {
  print "out if: \$str is not defined.\n";
}

exit 0;
