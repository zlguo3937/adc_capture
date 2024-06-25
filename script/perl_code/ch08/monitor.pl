#!/usr/local/bin/perl

use warnings;
use strict;

use lib "../perl_module";
use My_perl_module_v4 ;

my $readme = "
##############################
#
# Usage: $0 option
#
# Function: Check file size under directory
#
# Option:
#
#    -dirs    directory*  : Directory to check
#
#    -to      email*      : Email list to send
#
#    -step    num         : Step minutes
#
#    -eda_log file        : Log file of EDA tool
#
#    -log     file        : Log file for this script
#
##############################
";

if ( @ARGV < 2 ) {
  print $readme ;
  exit 1;
}

my ( %eda_check );
define_arg( \%{ $eda_check{'def'} } );
Handle_argv( \@ARGV, \%{ $eda_check{'def'} }, \%{ $eda_check{'arg'} } );

init_log( $eda_check{'arg'}{'-log'} );
check_and_compare( \%eda_check );

exit 0;


sub define_arg {
  my ($h) = @_;
  %$h = (
    '-dirs' => {
      'perl_type' => 'array',
      'data_type' => 'inputdir',
    },
    '-to' => {
      'perl_type' => 'array',
    },
    '-step' => {
      'perl_type' => 'scalar',
      'data_type' => 'num',
    },
    '-eda_log' => {
      'perl_type' => 'scalar',
      'data_type' => 'inputfile',
    },
    '-log' => {
      'perl_type' => 'scalar',
    },
  );
} # define_arg

sub init_log {
  my ($f) = @_;

  my $cmd_arg = $0 . " " . join " ", @ARGV;
  my $cur_date    = `date`;
  chomp $cur_date;
  open my $fh, '>', $f or die "$!";
  print $fh
"#############
# Command: $cmd_arg
# User   : $ENV{'USER'}
# date   : $cur_date
#############\n";
  close $fh or die "$!";

} # init_log

sub check_and_compare {
  my ($h) = @_;

  my $harg = $h->{'arg'};
  my $sleep_seconds = 60 * $harg->{'-step'};
  my $n = 0;
  my (%present_status, %previous_status, $present_file, $previous_file);
  my (@result_lines, $file_to_send, $email_status );
  while (1) {
    ++$n;
    get_present( \%present_status, \@{ $harg->{'-dirs'} } );
    $present_file = $harg->{'-log'} . "." . $n;
    write_status( $present_file, \%present_status );
    if ( $n == 1 ) {
      sleep( $sleep_seconds );
      next;
    }
    $previous_file = $harg->{'-log'} . "." . ($n-1);
    get_previous( $previous_file, \%previous_status );
    compare_between(\@result_lines,\%previous_status,\%present_status );

    $file_to_send = $present_file . ".send" ;
    write_to_send( $file_to_send, \@result_lines );
    append_send( $file_to_send, $harg->{'-eda_log'} );
    $email_status = send_email( $harg->{'-to'}, $file_to_send );
    append_log( $harg->{'-log'}, $n, $file_to_send, $email_status );
    if_exit( $harg );
    sleep( $sleep_seconds );
  } # while

  return 0;
} # check_and_compare

sub get_present {
  my ($h, $af) = @_;
  %$h = ();
  for my $d ( @$af ) {
    get_file_size( $h, $d );
  }
  return 0;
} # get_present

sub write_status {
  my ($f, $h) = @_;

  open my $fhout, '>', $f or die "$!";
  for my $k ( keys %$h ) {
    print $fhout $h->{$k}, " ", $k, "\n";
  }
  close $fhout or die "$!";

  return 0;
} # write_status

sub get_previous {
  my ($f, $h) = @_;

  %$h = ();
  open my $fhin, '<', $f or die "$!";
  while (<$fhin>) {
    if ( /^(\S+) (.+)$/ ) {
      $h->{ $2 } = $1 ;
    }
  }
  close $fhin or die "$!";

  return 0;
} # get_previous

sub compare_between {
  my ($af, $hold, $hnew) = @_;

  @$af = ();
  my ($line, );
  for my $knew ( keys %$hnew ) {
    if ( exists $hold->{$knew} ) {
      if ( $hnew->{$knew} > $hold->{$knew} ) {
        $line =  "Extend: (" . ( $hnew->{$knew} - $hold->{$knew} ) 
                 . " Byte) " . $knew;
        push @$af, $line;
      }
    }
    else {
      push @$af, "Add: $knew";
    }
  }
  return 0;
} # compare_between
sub write_to_send {
  my ($f, $af) = @_;

  open my $fhout, '>', $f or die "$!";
  print $fhout `date` ;
  for (@$af) {
    print $fhout $_, "\n";
  }
  close $fhout or die "$!";

  return 0;
} # write_to_send

sub append_send {
  my ($f, $edalog) = @_;

  my @lines = grep /Error/, `cat $edalog`;

  return unless @lines;

  open my $fhapp, '>>', $f or die "$!";
  for (@lines) {
    print $fhapp $_;
  }
  close $fhapp or die "$!";

  return 0;
} # append_send

sub send_email {
  my ($ef, $f) = @_;

  my $re = 0;
  my $email_cmd = q{mail -s "perl monitor" -c};
  for (@$ef) {
    $email_cmd .= " $_";
  }
  $email_cmd .= " < $f";

  #$re = system( $email_cmd );
  print "email cmd: $email_cmd\n";
  print `cat $f`;

  return $re;
} # append_to_log

sub append_log {
  my ($f, $n, $file, $e) = @_;

  open my $fhapp, '>>', $f or die "$!";
  print $fhapp "n= $n:", "\n",
               "  mail status: $e", "\n",
               "  file :", -s $file, " ", $file, "\n";
  close $fhapp or die "$!";

  return 0;
} # append_log

sub if_exit {
  my ($harg) = @_;
  
  my @lines = `tail $harg->{'-eda_log'}`;
  my $done = 0;
  for (@lines) {
    if ( /DONE/ ) {
      $done = 1;
      last; 
    } 
  } 
  
  return 0 unless $done;
  my $fend = $harg->{'-log'} . ".end";
  write_array_to_file( $fend, \@lines );
  send_email( $harg->{'-to'}, $fend );
  
  my $cur_date = `date`;
  open my $fhapp, '>>', $harg->{'-log'} or die "$!";
  print $fhapp "Last file sent: $fend\n",
               "finish at: ", $cur_date;
  close $fhapp or die "$!";
  
  exit 0;
} # if_exit
