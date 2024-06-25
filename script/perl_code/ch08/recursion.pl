#!/usr/local/bin/perl

use strict;
use warnings;

my (%size_of_file,);
for (@ARGV) {
  get_file_size( \%size_of_file, $_ );
}

for my $f ( sort {
                   $size_of_file{$b} <=> $size_of_file{$a}
                 }   keys %size_of_file
          ) {
  print $size_of_file{$f}, "\t", $f, "\n";
}

exit 0;

sub get_file_size {
  my ( $h, $fd ) = @_;

  my (@files);
  if ( -d $fd ) {
    opendir my $dir, $fd or die "$!";
    @files = map  { "$fd/$_" }
             grep { $_ ne '.' and $_ ne '..' } readdir $dir;
    closedir $dir or die "$!";
    for (@files) {
      get_file_size( $h, $_ );
    }
  }
  elsif ( -f $fd ) {
    $h->{$fd} = -s $fd;
  }
}

