#!/usr/local/bin/perl

my %one_hash = (
  "a" => undef,
  "b" => 0,
  "c" => 1,
);

my @arr = qw/a b c d/;

for ( @arr ) {
  if ( exists $one_hash{$_} ) {
    print "$_ exists in %one_hash\n";
  }
  else {
    print "$_ not exists in %one_hash\n";
  }
}

exit 0;
