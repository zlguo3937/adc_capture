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
# FUNCTION: Connect verilog files to TOP
#
# OPTION:
#     -file_list    inputfile       : verilog file list
#     -output       outputfile      : output(top) verilog file
#
# EXAMPLE:
#   $0 -file_list ./file_list -output ./output/top_design.v
#
##########################
";

if ( @ARGV < 2 ) {
  print $readme ;
  exit 1;
}

my ( %converilog );
define_arg( \%{ $converilog{'def'} } );
Handle_argv( \@ARGV, \%{ $converilog{'def'} }, \%{ $converilog{'arg'} } );
read_file_list( \%converilog );
read_verilog_file( \%converilog );
con_top_verilog( \%converilog );
generate_lines( \%converilog );
output_verilog( \%converilog );

exit 0;

### subroutines
sub define_arg {
  my ($h) = @_;
  %$h = (
    '-file_list' => {
      'perl_type' => 'scalar',
      'data_type' => 'inputfile',
    },
    '-output' => {
      'perl_type' => 'scalar',
    }
  );
}
sub read_file_list {
  my ($h) = @_;

  open my $fih, '<', $h->{'arg'}{'-file_list'} or die "$!";
  while (<$fih>) {
    if ( /^\s*([^#]\S+)/ ) {
      push @{ $h->{'vfiles'} }, $1;
    }
  }
  close $fih or die "$!";
  return 0;
} # read_file_list

sub read_verilog_file {
  my ($h) = @_;
  my ($flag, $mod, $io, $tmp, @tmps);
  $flag = 0;
  for my $f ( @{ $h->{'vfiles'} } ) {
    open my $fih, '<', $f or die "$!";
    while (<$fih>) {
      if ( /^\s*module\s+([^(\s]+)/ ) {
        $mod = $1;
      }
      elsif ( /^\s*((?:input)|(?:output)|(?:inout))\s+(.*)$/ ) {
        ($io, $tmp) = ($1, $2);
        @tmps = split /[,;\s]+/, $tmp ;
        for my $t ( @tmps ) {
          push @{ $h->{'mod'}{$mod}{$io} }, $t;
          push @{ $h->{'mod'}{$mod}{'ports'} }, $t;
        }
        if ( $tmp =~ /;/ ) {
          $flag = 0;
        }
        else {
          $flag = 1;
        }
      }
      elsif ( $flag == 1 and /^\s*(.*)/ ) {
        $tmp = $1;
        @tmps = split /[,;\s]+/, $tmp ;
        for my $t ( @tmps ) {
          push @{ $h->{'mod'}{$mod}{$io} }, $t;
          push @{ $h->{'mod'}{$mod}{'ports'} }, $t;
        }
        if ( $tmp =~ /;/ ) {
          $flag = 0;
        }
      }
    }
    close $fih or die "$!";
  }
  return 0;
} # read_verilog_file

sub con_top_verilog {
  my ($h) = @_;

  my $hm = $h->{'mod'};
  my $ht = \%{ $h->{'top'} };

  for my $design ( keys %$hm ) {
    for my $dir ( "input", "output", "inout" ) {
      next unless exists $hm->{$design}{$dir};
      for my $p ( @{ $hm->{$design}{$dir} } ) {
        $ht->{'candidate'}{$p}{$dir} = 1;
      }
    }
  }
  for my $p ( keys %{ $ht->{'candidate'} } ) {
    if (     exists $ht->{'candidate'}{$p}{'input'}
         and exists $ht->{'candidate'}{$p}{'output'}
       ) {
      push @{ $ht->{'wire'} }, $p;
    }
    elsif ( exists $ht->{'candidate'}{$p}{'inout'} ) {
      push @{ $ht->{'inout'} }, $p;
      push @{ $ht->{'ports'} }, $p;
    }
    elsif ( exists $ht->{'candidate'}{$p}{'input'} ) {
      push @{ $ht->{'input'} }, $p;
      push @{ $ht->{'ports'} }, $p;
    }
    elsif ( exists $ht->{'candidate'}{$p}{'output'} ) {
      push @{ $ht->{'output'} }, $p;
      push @{ $ht->{'ports'} }, $p;
    }
    else {
      print "Unknown error\n";
    }
  }
  return 0;
} # con_top_verilog

sub generate_lines {
  my ($h) = @_;

  my $ht = $h->{'top'} ;
  my $af = \@{ $h->{'lines'} };

  my $top;
  if ( $h->{'arg'}{'-output'} =~ m{/([^/]+).v$}i ) {
    $top = $1;
  }
  else {
    $top = "top";
  }
  my $line = "module $top (";
  my $sep = ", ";
  $line .= join $sep, @{ $ht->{'ports'} };
  $line .= " );";
  push @$af, $line;

  for my $dir ( "input", "output", "inout", "wire" ) {
    next unless exists $ht->{$dir};
    $line = $dir . " ";
    $line .= join $sep, @{ $ht->{$dir} };
    $line .= ";";
    push @$af, $line;
  }

  my $hm = $h->{'mod'} ;
  for my $design ( keys %$hm ) {
    $line = "$design inst_$design ( ";
    $line .= join $sep, map { ".${_}($_)" } @{ $hm->{$design}{'ports'} };
    $line .= " );";
    push @$af, $line;
  }

  push @$af, "endmodule";
  return 0;
} # generate_lines

sub output_verilog {
  my ($h) = @_;

  my $indent = " "x4 ;
  my (@tmps, $toprint);
  open my $foh, '>', $h->{'arg'}{'-output'} or die "$!";
  for my $line ( @{ $h->{'lines'} } ) {
    @tmps = split " ", $line;
    $toprint = shift @tmps;
    for my $t (@tmps) {
      if ( length( "$toprint $t" ) > 78 ) {
        print $foh $toprint, "\n";
        $toprint = $indent . $t;
      }
      else {
        $toprint .= " $t";
      }
    }
    print $foh $toprint, "\n\n";
  }
  close $foh or die "$!";

  return 0;
} # output_verilog
