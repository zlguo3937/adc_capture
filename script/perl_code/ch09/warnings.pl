#!/usr/local/bin/perl

my ($str, @arr, %ahash) ;
print $str, " warn 1\n";
print $arr[0], " warn 2\n";
print $ahash{"aa"}, " warn 3\n";

my @chars = qw/a b c/;
print @chars[2], " warn 4\n";

my $num = "6,";
++$num ;
print $num, " warn 5\n";

exit 0;
