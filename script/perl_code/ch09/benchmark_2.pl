#!/usr/local/bin/perl

use Benchmark qw(cmpthese timethese);

$x = 3;
$r = timethese( -1, {
    byit => sub{$x*$x},
    by2  => sub{$x**2},
} );
cmpthese $r;

exit 0;
