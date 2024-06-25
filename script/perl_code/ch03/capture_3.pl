#!/usr/local/bin/perl

my $str = "To be or not to be, it’s a question.";
my @caps;
if ( @caps = $str =~ /^((\S+)\s+(\S+))\s+
                       (\S+)\s+
                       ((\S+)\s+(\S+)\s+(\S+))\s+
                       ([^.]+)
                       (((.)))
                     /x ) {
  for my $n ( 0..$#caps ) {
    print 1+$n, " is: $caps[$n]\n";
  }
}

exit 0;
