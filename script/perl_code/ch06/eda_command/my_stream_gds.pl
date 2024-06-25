#!/usr/local/bin/perl

use warnings;
use strict;

use lib "../perl_module";
use My_perl_module_v4 ;

my $readme = "
##########################
#
# USAGE: $0 [option]*
#
# FUNCTION: Stream Out GDS
#
# OPTION:
#     -library          string          : library name
#     -topCell          string          : cell name
#     -strmFile         string          : gds file name
#
##########################
";

if ( @ARGV < 4 ) {
  print $readme ;
  exit 1;
}

my ( %stream );
define_opt_rule( \%{ $stream{'def'} } );
Handle_argv( \@ARGV, \%{ $stream{'def'} }, \%{ $stream{'arg'} } );
stream_out( \%stream );

exit 0;

### subroutine
sub define_opt_rule {
  my ($h) = @_;

  %$h = (
    '-library' => {
      'perl_type' => 'scalar',
    },
    '-topCell' => {
      'perl_type' => 'scalar',
    },
    '-strmFile' => {
      'perl_type' => 'scalar',
    },
  );

  return 0;
} # define_opt_rule

sub stream_out {
  my ($ht) = @_;
  if ( $ht->{'arg'}{'-strmFile'} =~ m{^(.+)/} ) {
    make_dir($1);
  }
  open my $foh, '>', $ht->{'arg'}{'-strmFile'} or die "$!";
  print $foh "lib : $ht->{'arg'}{'-library'}\n",
             "cell: $ht->{'arg'}{'-topCell'}\n";
  close $foh or die "$!";
  return 0;
} # read_var
