#!/usr/local/bin/perl

use warnings;
use strict;
use Cwd;
use File::Basename;
use Data::Dumper;
use lib "../perl_module";
use My_perl_module_v4 ;

my $readme = "
##########################
#
# USAGE: $0 [option]*
#
# FUNCTION: Run DRC
#
# OPTION:
#     -lib          string          : library name
#     -cell         string          : cell name
#    [-rule         inputfile ]     : DRC rule file, default is ./rule/drc_rule.txt
#    [-run_dir      directory ]     : directory where to run DRC, default is ./verify/<lib>/<cell>/drc
#
# EXAMPLE:
#   $0 -lib library -cell cell
#
##########################
";

if ( @ARGV < 2 ) {
  print_and_exit( $readme );
}
my ( %drc );
define_opt_rule( \%{ $drc{'def'} } );
Handle_argv( \@ARGV, \%{$drc{'def'}}, \%{$drc{'arg'}} );
prepare_run_dir( \%drc );
export_gds( \%drc );
prepare_drc_rule( \%drc );
run_drc( \%drc );
report_result( \%drc );
#print(Dumper(\%drc));

exit 0;

### subroutines
sub define_opt_rule {
  my ($h) = @_;

  %$h = (
    '-lib' => {
      'perl_type' => 'scalar',
    },
    '-cell' => {
      'perl_type' => 'scalar',
    },
    '-rule' => {
      'perl_type' => 'scalar',
      'data_type' => 'inputfile',
      'default'   => ["./rule/drc_rule.txt"],
    },
    '-run_dir' => {
      'perl_type' => 'scalar',
      'default'   => ['./verify/<lib>/<cell>/drc'],
    },
  );

  return 0;
} # define_opt_rule

sub prepare_run_dir {
  my ($ht) = @_;

  $ht->{'arg'}{'-run_dir'} =~ s/<(.+?)>/$ht->{'arg'}{"-$1"}/g ;
  make_dir( $ht->{'arg'}{'-run_dir'} );

  return 0;
} # prepare_run_dir

sub export_gds {
  my ($ht) = @_;

  my $ha = $ht->{'arg'};
  $ht->{'mid'}{'gds'} = $ha->{'-run_dir'} . "/" . $ha->{'-cell'} . '.gds' ;
  my $stream_command =   getcwd()
                       . "/eda_command/my_stream_gds.pl"
                       . " -library  $ha->{'-lib'}"
                       . " -topCell  $ha->{'-cell'}"
                       . " -strmFile $ht->{'mid'}{'gds'}" ;

  my $re = system( $stream_command );
  print_and_exit( "Error: $stream_command" ) unless $re == 0;
  print_and_exit( "Error: stream out GDS failed: $ht->{'mid'}{'gds'}" ) unless -f $ht->{'mid'}{'gds'};

  return 0;
} # export_gds

sub prepare_drc_rule {
  my ($ht) = @_;

  my $ha = $ht->{'arg'};
  my (@lines, );
  read_file_to_array( $ha->{'-rule'}, \@lines );

  my %replace = (
    '^\\s*layout\\s+path\\b' => "layout path = \"$ha->{'-cell'}.gds\"",
    '^\\s*layout\\s+top\\b'  => "layout top = \"$ha->{'-cell'}\"",
  );
  replace_array( \@lines, \%replace);
  
  $ht->{'mid'}{'rule'} = $ha->{'-run_dir'} . "/" . basename($ha->{'-rule'});

  $ht->{'mid'}{'report'} = get_match_word(\@lines, '^\\s*output\\s*=\\s*"([^"]+)') ;
  print_and_exit( "Error: get report filename failed." ) unless $ht->{'mid'}{'report'};

  write_array_to_file( $ht->{'mid'}{'rule'}, \@lines );

  return 0;
} # prepare_drc_rule

sub replace_array {
  my ($af, $h) = @_;

  my @sources = keys %$h ;
  for (@$af) {
    for my $s ( @sources ) {
      if ( /$s/ ) {
        $_ = $h->{$s} . "\n";
      }
    }
  }

  return 0;
} # replace_array

sub get_match_word {
  my ($af, $reg) = @_;
  my $re;
  for (@$af) {
    if ( /$reg/ ) {
      $re = $1;
      last;
    }
  }
  return $re;
} # get_word_in_quot

sub run_drc {
  my ($ht) = @_;

  my $rule = basename( $ht->{'mid'}{'rule'} ) ;
  my $drc_command =   getcwd()
                    . "/eda_command/my_drc.pl "
                    . $rule ;
  chdir $ht->{'arg'}{'-run_dir'};
  my $re = system($drc_command);
  print_and_exit( "Error: $drc_command" ) unless $re == 0;

  return 0;
} # run_drc

sub report_result {
  my ($ht) = @_;
  my (@lines);
  read_file_to_array($ht->{'mid'}{'report'}, \@lines);
  for (@lines) {
    if ( /\b(\d+)$/ and $1 ne "0" ) {
      print ;
    }
  }
  return 0;
} # report_result
