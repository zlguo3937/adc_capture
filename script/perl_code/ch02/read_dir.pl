#!/usr/local/bin/perl

opendir my $dh, "." or die "Error: read directory failed.";
my @filedirs = readdir $dh;
closedir $dh or die "Error: close directory failed.";

for my $f ( @filedirs ) {
  print $f, "\n";
}

exit 0;
