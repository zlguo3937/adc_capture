#!/usr/local/bin/perl

print_sub("a.txt");

exit 0;

### sub
sub print_sub {
  my ($f) = @_;

  return -1 unless -f $f;
  open FH, '<', $f or die "$!";
  while (my $line=<FH>) {
    chomp $line;
    if ( -f $line ) {
      print_sub($line);
    }
    else {
      print $line, "\n";
    }
  }
  close FH or die "$!";

  return 0;
} # print_sub
