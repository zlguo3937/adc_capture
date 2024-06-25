#!/usr/local/bin/perl

opendir my $dh, "." or die "$!" ;
my @all_files = grep { $_ ne '.' and $_ ne '..' } readdir $dh;
closedir $dh or die "$!";

for my $file ( @all_files ) {
  print $file, "\n";
}

exit 0;
