#!/usr/bin/perl

open my $fh_output, '>', "write_file.txt";
print $fh_output "This is an example\n";
close $fh_output;

exit 0;