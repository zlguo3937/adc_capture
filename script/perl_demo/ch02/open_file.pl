#!/usr/bin/perl

open my $fh_input, '<', "./check_e.pl" or die "read file failed: $!";
open my $fh_output, '>', "write_file.txt";
while ( my $line = <$fh_input> ) {
    print $fh_output $line;
}
close $fh_output;
close $fh_input or die "close file failed:$!";
exit 0;