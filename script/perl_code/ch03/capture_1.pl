#!/usr/local/bin/perl

my $str = "module xyz (something)";
if ( $str =~ /^module\s+(\S+)/ ) {
  print "module name is: ", $1, "\n";
}

exit 0;
