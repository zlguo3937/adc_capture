#!/usr/local/bin/perl

my @lines = (
  "China_capital Beijing",
  "China Shanghai",
  "Japan Toyko",
  "USA Newyork",
  "USA_capital DC",
);

my @countries = (
  "China",
  "USA",
);

for my $line ( @lines ) {
  for my $country ( @countries ) {
    if ( $line =~ /$country/ ) {
      print $line, "\n";
    }
  }
}

exit 0;
