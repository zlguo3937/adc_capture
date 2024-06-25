#!/usr/local/bin/perl

opendir my $dh, "." or die "$!" ;
while ( my $file = readdir($dh) ) {
  print $file, "\n";
}
closedir $dh or die "$!";

exit 0;
