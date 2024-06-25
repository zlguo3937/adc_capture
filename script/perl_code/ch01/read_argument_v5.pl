#!/usr/local/bin/perl

use lib "../perl_module";
use My_perl_module_v1;

my %rule_of_opt = (
  '-s' => {
            'perl_type' => 'scalar',
          },
  '-a' => {
            'perl_type' => 'array',
          }
);
my (%value_of_opt) ;
My_perl_module_v1::Handle_argv( \@ARGV, \%rule_of_opt, \%value_of_opt );
print_argv( \%value_of_opt );

exit 0;
### sub
sub print_argv {
  my ($hv) = @_;
  for my $opt ( keys %$hv ) {
    print "$opt =>";
    for my $pv ( @{ $hv->{$opt} } ) {
      print " $pv";
    }
    print "\n";
  }
} # print_argv
