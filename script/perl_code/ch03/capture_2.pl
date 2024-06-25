#!/usr/local/bin/perl

my $str = "To be or not to be, it’s a question.";
if ($str =~ /^((\S+)\s+(\S+))\s+(\S+)\s+((\S+)\s+(\S+)\s+(\S+))\s+(.+)/) {
  for my $n ( 1..9 ) {
    print "\$$n is: ${$n}\n";
  }
}

exit 0;
