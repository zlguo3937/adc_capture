#!/usr/local/bin/perl

use strict;
use warnings;

=head1 function
  This is an easy example for pod
=cut
run_sub_1();
run_sub_2();

exit 0;

=head1 subroutine

=head2 run_sub_1()
    Here is some comments for run_sub_1()
=cut
sub run_sub_1 {
  print "pod 1\n";
}

=head2 run_sub_2()
    Here is some comments for run_sub_2()
=cut
sub run_sub_2 {
  print "pod 2\n";
}
