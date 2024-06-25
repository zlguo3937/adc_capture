#!/usr/bin/perl

my $str = "aAcABC";
if ( $str =~ /pattern/ ) {
    print "yes\n";
}
else {
    print "no\n";
}
exit 0;