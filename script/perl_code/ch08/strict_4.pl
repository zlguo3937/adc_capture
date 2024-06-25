#!/usr/local/bin/perl
use strict ;
no strict 'refs';
my $to_run = "try";

&$to_run;

exit 0;

### sub

sub try {
  print "try\n";
}
