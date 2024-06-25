#!/usr/local/bin/perl

use warnings;
use strict;

use lib '../perl_module';
use My_perl_module_v4;


my $readme = "
##########################
#
# USAGE: $0 [option]*
#
# FUNCTION: Run PVT simulation
#
# OPTION:
#     -netlist      file       : netlist file which can be simulated
#     -run_dir      directory  : directory where to run simualtion
#    [-corner       list  ]    : corner[s] to be cover, default is: tt ff ss
#     -volt_name    scalar     : net name of VDD
#    [-volt_values  list  ]    : values of <volt_name> to be cover,default is: 0.9 1.0 1.1
#    [-temp         list  ]    : temperature[s] to be cover, default is: 240 300 370
#     -net_name     scalar     : net name to report
#     -report       scalar     : file name of report
#    [-sim_opt      scalar]    : option which pass to simulate command, default is empty
#
# EXAMPLE:
#   $0 -netlist ./input_netlist/input_netlist.txt -run_dir ./run_dir -volt_name val_vdda -net_name tocheck -report ./run_dir/output.csv
#
##########################
";

if ( @ARGV < 10 ) {
  print_and_exit( $readme );
}
my (%rule_of_opt, %value_of_opt, %result_of);
define_opt_rule( \%rule_of_opt );

Handle_argv( \@ARGV, \%rule_of_opt, \%value_of_opt );

run_pvt( \%value_of_opt, \%result_of );

generate_report( \%value_of_opt, \%result_of );

exit 0;

### subroutines
sub define_opt_rule {
  my ($h) = @_;
  %$h = (
    '-netlist' => {
              'perl_type' => 'scalar',
              'data_type' => 'inputfile',
            },
    '-run_dir' => {
              'perl_type' => 'scalar',
            },
    '-sim_opt' => {
              'perl_type' => 'scalar',
              'default' => [""],
            },
    '-corner' => {
              'perl_type' => 'array',
              'default' => ["tt", "ff", "ss"],
            },
    '-volt_name' => {
              'perl_type' => 'scalar',
            },
    '-volt_values' => {
              'perl_type' => 'array',
              'default' => ["0.9", "1.0", "1.1"],
            },
    '-temp' => {
              'perl_type' => 'array',
              'default' => [240, 300, 370],
            },
    '-net_name' => {
              'perl_type' => 'scalar',
            },
    '-report' => {
              'perl_type' => 'scalar',
            },
  );
} # define_opt_rule

sub run_pvt {
  my ($hv, $hr) = @_;

  my (@lines);
  read_file_to_array( $hv->{'-netlist'}, \@lines );

  my ($netlist_filename);
  if ( $hv->{'-netlist'} =~ m{/([^/]+)$} ) {
    $netlist_filename = $1;
  }
  else {
    $netlist_filename = $hv->{'-netlist'};
  }

  my ($input_netlist, $sim_output);
  for my $c ( @{ $hv->{'-corner'} } ) {
    for my $v ( @{ $hv->{'-volt_values'} } ) {
      for my $t ( @{ $hv->{'-temp'} } ) {
        $input_netlist          = generate_netlist( $hv, $c, $v, $t, $netlist_filename, \@lines );
        $sim_output             = run_sim( $input_netlist, $hv->{'-sim_opt'} );
        $hr->{"${c}_${v}_${t}"} = get_sim_result( $sim_output, $hv->{'-net_name'} );
      }
    }
  }

  return 0;
} # run_pvt

sub generate_netlist {
  my ($hv, $c, $v, $t, $nf, $aref) = @_;

  my $subdir = $hv->{'-run_dir'} . "/" . "${c}_${v}_${t}" ;
  make_dir( $subdir );

  my $innet = $subdir . "/" . $nf ;

  open my $foh, '>', $innet or die "$!";
  for my $line (@$aref) {
    if ( $line =~ /\b$hv->{'-volt_name'}\s*=/ ) {
      $line =~ s/\b$hv->{'-volt_name'}\s*=\S+/$hv->{'-volt_name'}=$v/ ;
    }
    elsif ( $line =~ /^\s*temp\s*=/ ) {
      $line = "temp=" . $t;
    }
    elsif ( $line =~ /^\s*include\s/ and $line =~ /\bsection\s*=/ ) {
      $line =~ s/\bsection\s*=.*/section=$c/ ;
    }
    print $foh $line;
  }
  close $foh or die "$!";

  return $innet;
} # generate_netlist

sub run_sim {
  my ($inet, $sopt) = @_;

  my $sim_out = $inet . ".log";
  my $command = "./eda_command/my_spice.pl -i $inet -o $sim_out" . $sopt;

  my $re = system( $command );
  if ( $re != 0 ) {
    print_and_exit( "Error: $command" );
  }

  return $sim_out;
} # run_sim

sub get_sim_result {
  my ($f, $p) = @_;

  my $re = "unknown";
  open my $fih, '<', $f or die "$!";
  while (<$fih>) {
    if ( /^\s*$p\s*=\s*(\S+)/ ) {
      $re = $1;
      last;
    }
  }
  close $fih or die "$!";

  return $re;
} # get_sim_result

sub generate_report {
  my ($hv, $hr) = @_;

  my $output_csv = $hv->{'-report'};
  open my $foh, '>', $output_csv or die "$!";
  print $foh "c_v_t,$hv->{'-net_name'}\n";
  for my $k ( sort keys %$hr ) {
    print $foh $k, ",", $hr->{$k}, "\n";
  }
  close $foh or die "$!";

  print "Output CSV file is: $output_csv\n";
  return 0;
} # generate_report

### END
