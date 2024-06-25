#!/usr/local/bin/perl

opendir my $dh, "." or die "$!" ;
my @all_files = readdir $dh;
closedir $dh or die "$!";

for my $file ( @all_files ) {
  print $file, "\n";
}

exit 0;
