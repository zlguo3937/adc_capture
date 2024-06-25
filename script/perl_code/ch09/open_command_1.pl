#!/usr/local/bin/perl

open my $fhi, '-|', "cat $0" ;
while (<$fhi>) {
  print;
}
close($fhi);

exit 0;
