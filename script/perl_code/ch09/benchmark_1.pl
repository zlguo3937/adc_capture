#!/usr/local/bin/perl

use Benchmark qw(cmpthese);

$x = 3;
cmpthese( -1, {
    byit => sub{$x*$x},
    by2  => sub{$x**2},
} );

exit 0;
