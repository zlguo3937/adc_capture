#!/usr/local/bin/perl

open my $fh1, '<', $ARGV[0] || die "Error when using ||: $!";
open my $fh2, '<', $ARGV[0] or die "Error when using or: $!";

print "done\n";

exit 0;

