#!/usr/local/bin/perl

print_sub("a.txt");

exit 0;

### sub
sub print_sub {
  my ($f) = @_;

  return -1 unless -f $f;
  open my $fh, '<', $f or die "$!";
  while (my $line=<$fh>) {
    chomp $line;
    if ( -f $line ) {
      print_sub($line);
    }
    else {
      print $line, "\n";
    }
  }
  close $fh or die "$!";

  return 0;
} # print_sub
