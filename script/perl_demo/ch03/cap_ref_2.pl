#!/usr/bin/perl

my $str = "1 2 3 4 5 6 7 8 9 9 9 9 9 9 9 9 9 9 ";

if ( $str =~ /(.\s)(.\s)(.\s)(.\s)(.\s)(.\s)(.\s)(.\s)((.\s)\g{10})/ ) {
    print $1, $2, $3, $4, $5, $6, $7, $8, $9, "\n";
}
else {
    print "Error\n";
}

exit 0;