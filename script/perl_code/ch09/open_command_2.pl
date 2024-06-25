#!/usr/local/bin/perl

open my $fho, '|-', "tr 'a-z' 'A-Z'" ;
print $fho "something\n";
close($fho);

exit 0;
