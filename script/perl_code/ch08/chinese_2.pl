#!/usr/local/bin/perl

use strict;
use warnings;

use utf8;

open my $fhi, '<:encoding(gbk)', $ARGV[0] or die "$!";
open my $fho, '>:encoding(utf8)', $ARGV[1] or die "$!";
while ( <$fhi> ) {
  if ( /文件/ ) {
    print "match\n";
  }
  else {
    print "not match\n";
  }
  print $fho $_;
}
close $fho or die "$!";
close $fhi or die "$!";

exit 0;

