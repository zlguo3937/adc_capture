#!/usr/local/bin/perl

use strict;
use warnings;

my $abc = 123;
my @arr = qw/a b c/;
print << "END1";
any character here
$abc
@arr
单引号双引号：" ' " ' " '
END1

exit 0;
