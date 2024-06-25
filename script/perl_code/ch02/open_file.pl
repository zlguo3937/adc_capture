#!/usr/local/bin/perl

open my $fh_input, '<', "./open_file.pl" or die "read file failed: $!";
while ( my $line = <$fh_input> ) {
  print $line ;
}
close $fh_input or die "close file failed: $!";

exit 0;
