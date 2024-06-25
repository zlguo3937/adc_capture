#!/usr/local/bin/perl

open my $foh, '>', "output.txt" or die "$!";
print $foh "rule_1 3\n",
           "rule_2 0\n",
           "rule_3 1\n" ;
close $foh or die "$!";

exit 0;
