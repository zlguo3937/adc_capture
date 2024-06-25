#!/usr/local/bin/perl

#use warnings;

my ($line, $reg);
$line = "str";
$reg = some_sub();

if ( $line =~ /$reg/ ) {
  print "match\n";
}
else {
  print "not match\n";
}

exit 0;

sub some_sub {
  
}
