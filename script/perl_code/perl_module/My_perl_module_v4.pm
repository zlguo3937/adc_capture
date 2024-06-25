package My_perl_module_v4;

use parent qw(Exporter);
our @EXPORT = qw(Handle_argv print_and_exit read_file_to_array write_array_to_file make_dir);

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
      $arg =~ s/^\s*// ;
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

sub combine_scalar {
  my ($hr, $hv) = @_;

  for my $opt ( keys %$hv ) {
    if ( ${$hr->{$opt}}{'perl_type'} eq 'scalar') {
      $hv->{$opt} = $hv->{$opt}[0];
    }
  }

} # combine_scalar

sub check_argv_data_type {
  my ($hr, $hv) = @_;

  for my $opt ( keys %$hv ) {
    if ( exists $hr->{$opt} ) {
      next unless exists $hr->{$opt}{'data_type'};
      if ( $hr->{$opt}{'data_type'} eq 'inputfile') {
        for my $arg ( @{ $hv->{$opt} } ) {
          if ( ! ( (-f $arg) and (-s $arg) ) ) {
            print_and_exit( "Error: input file is expected to '$opt': $arg" );
          }
        }
      }
      elsif ( $hr->{$opt}{'data_type'} eq 'num') {
        for my $arg ( @{ $hv->{$opt} } ) {
          unless (     ( $arg =~ /^-?\d+$/ )
                    or ( $arg =~ /^-?\d+\.\d+$/ )
                    or ( $arg =~ /^-?\d+[eE]-?\d+$/ )
                    or ( $arg =~ /^-?\d+\.\d+[eE]-?\d+$/ )
                 ) {
            print_and_exit( "Error: number is expected to '$opt': $arg" );
          }
        }
      }
      elsif ( $hr->{$opt}{'data_type'} eq 'inputdir') {
        for my $arg ( @{ $hv->{$opt} } ) {
          if ( ! -d $arg ) {
            print_and_exit( "Error: directory is expected to '$opt': $arg" );
          }
        }
      }
    }
    else {
      print_and_exit( "Un-support option: '$opt'" );
    }
  }
} # check_argv_data_type

sub Handle_argv {
  my ($aref, $hr, $hv) = @_;
  read_argv($aref, $hv);
  check_argv_perl_type($hr, $hv);
  check_argv_data_type($hr, $hv);
  get_default($hr, $hv);
  combine_scalar($hr, $hv);
} # Handle_argv

sub get_default {
  my ($hr, $hv) = @_;
  for my $opt ( keys %$hr ) {
    next if exists $hv->{$opt} ;
    if ( exists $hr->{$opt}{'default'} ) {
      ### 'default' => "some_scalar", OR 'default' => ["some", "element", "of", "array"],
      $hv->{$opt} = $hr->{$opt}{'default'}; 
    }
    else {
      print_and_exit( "Error: no input or default for '$opt'" );
    }
  }

} # get_default

sub read_file_to_array {
  my ($f, $aref) = @_;

  open my $fih, '<', $f or die "$!";
  @$aref = <$fih> ;
  close $fih or die "$!";

} # read_file_to_array

sub write_array_to_file {
  my ($f, $aref) = @_;

  open my $foh, '>', $f or die "$!";
  print $foh @$aref;
  close $foh or die "$!";

} # write_array_to_file

sub make_dir {
  my ($d) = @_;

  return 0 if -d $d;
  system( "mkdir -p $d" ) and print_and_exit( "Error: make directory failed: $d" );

} # make_dir

1;