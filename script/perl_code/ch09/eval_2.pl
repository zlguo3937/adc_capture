#!/usr/local/bin/perl

my $n1 = 10;
my $n2 = 0;
my $n3;

eval {
$n3 = $n1/$n2;
};

warn $@ if $@;

print "done\n";
