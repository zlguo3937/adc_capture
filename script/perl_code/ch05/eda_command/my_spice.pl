#!/usr/local/bin/perl

my $readme = "
#################
#
# Usage: $0 -i netlist -o output
#
# Function: simulate a SPICE simulator
#
#################
";

if ( @ARGV != 4 ) {
  print STDERR $readme;
  exit 1;
}

my ( %arg ) = @ARGV;

unless ( exists $arg{'-i'} and exists $arg{'-o'} and -f $arg{'-i'} ) {
  print STDERR $readme;
  exit 1;
}

my (%vof);
get_value($arg{'-i'}, \%vof);
output_result($arg{'-o'}, \%vof);

exit 0;

### subroutine

sub output_result {
  my ($f, $h) = @_;

  $h->{'val_vdda'} ||= 2.5;
  $h->{'temp'}     ||= 0;
  $h->{'sec'}      ||= 'tt';

  my %vofsec = (
    'tt' => 1,
    'ff' => 0.8,
    'ss' => 1.2,
  );
  my $result = ($h->{'val_vdda'} - 2.5)/2.5 * 2 + ($h->{'temp'} + 273)/273 * 4 + ($vofsec{ $h->{'sec'} } - 1.0) * 4 ;
  open my $fh, '>', $f or die "$!";
  printf( $fh "tocheck=%.5f\n", $result );
  close $fh or die "$!";

}

sub get_value {
  my ($f, $h) = @_;
  open my $fh, '<', $f or die "$!";
  while (<$fh>) {
    if ( /^parameters/ and /val_vdda=(\S+)/ ) {
      $h->{'val_vdda'} = $1;
    }
    elsif ( /^\s*temp=(\S+)/ ) {
      $h->{'temp'} = $1;
    }
    elsif ( /include/ and /section=(\S+)/ ) {
      $h->{'sec'} = $1;
    }
  }
  close $fh or die "$!";
  return 0;
} # get_value

