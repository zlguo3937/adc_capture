#!/usr/local/bin/perl

my %rule_of_opt = (
  '-s' => {
            'perl_type' => 'scalar',
          },
  '-a' => {
            'perl_type' => 'array',
          }
);
my (%value_of_opt) ;
handle_argv( \@ARGV, \%rule_of_opt, \%value_of_opt );
print_argv( \%value_of_opt );

exit 0;

### sub

sub print_and_exit {
  print @_, "\n";
  exit 1;
} # print_and_exit

sub read_argv {
  my ($aref, $hv) = @_;
  my ($opt);
  for my $arg ( @$aref ) {
    if ( $arg =~ /^-/ ) {
      $opt = $arg;
      if ( exists $hv->{$opt} ) {
        print_and_exit( "Repeated option: $arg" );
      }
      else {
        @{ $hv->{$opt} } = ();
      }
    }
    elsif ( defined $opt ) {
      push @{ $hv->{$opt} }, $arg;
    }
    else {
      print_and_exit( "Un-support option: $arg" );
    }
  }
} # read_argv

sub check_argv_perl_type {
  my ($hr, $hv) = @_;
  for my $opt ( keys %$hv ) {
    if ( exists $hr->{$opt} ) {
      if ( ${$hr->{$opt}}{'perl_type'} eq 'scalar') {
        if ( @{ $hv->{$opt} } != 1 ) {
          print_and_exit( "Error: only one parameter is expected to '$opt'" );
        }
      }
      elsif ( ${$hr->{$opt}}{'perl_type'} eq 'array') {
        if ( @{ $hv->{$opt} } < 1 ) {
          print_and_exit( "Error: one or more parameter is expected to '$opt'" );
        }
      }
      else {
        print_and_exit( "Error: unknown 'perl_type' of '$opt'" );
      }
    }
    else {
      print_and_exit( "Un-support option: '$opt'" );
    }
  }
} # check_argv_perl_type

sub handle_argv {
  my ($aref, $hr, $hv) = @_;
  read_argv($aref, $hv);
  check_argv_perl_type($hr, $hv);
} # handle_argv

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
