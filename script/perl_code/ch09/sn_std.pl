#!/usr/local/bin/perl

print "Please input any thing and return:";
my $input = <> ; ## <> is same as <STDIN>;
print "your input is $input";
print STDOUT "to STDOUT\n";
print STDERR "to STDERR\n";

exit 0;
