#!/usr/bin/perl

my $str = "1 2 3 4 5 6, 7 8 9X";
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