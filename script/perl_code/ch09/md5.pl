#!/usr/local/bin/perl

use Digest::MD5;

my $filename = $0;
open my $fhi, '<', $filename or die "Can't open '$filename': $!";
binmode ($fhi);
print Digest::MD5->new->addfile($fhi)->hexdigest, " $filename\n";
close $fhi or die "Close file '$filename' failed: $!";

exit 0;
