#!/usr/bin/perl

my $str = "aAcABC";
if ( $str =~ /AB/ ) {
    print "match\n";
}
else {
    print "unmatch\n";
}
exit 0;