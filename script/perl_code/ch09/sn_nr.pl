#!/usr/local/bin/perl

open my $fhi, '<', $0 or die "$!";
while (<$fhi>) {
  print "Line: $. : " , $_ ;
}
close $fhi or die "$!";

exit 0;
