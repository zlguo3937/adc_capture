#!/usr/local/bin/perl

# Scalar
my $str = "hello" ;
my $sref = \$str ;
$$sref = "HELLO" ;
print $$sref, "\n";

# Array
my @lines = ( "a", "b", "c" ) ;
my $aref = \@lines ;
for my $str ( @$aref ) {
  print $str, "\n";
}
push @$aref, "d";
$aref->[0] = "A";
for my $str ( @$aref ) {
  print $str, "\n";
}

# Hash
my %cof = (
  'China' => 'Beijing',
  'England' => 'London',
  'Japan' => 'Tokyo',
);
my $href = \%cof ;
for my $k ( keys %$href ) {
  print "$k : $href->{$k}\n" ;
}
$href->{'USA'} = 'WDC' ;
for my $k ( keys %$href ) {
  print "$k : $href->{$k}\n" ;
}

exit 0;
