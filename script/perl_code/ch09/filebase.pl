#!/usr/local/bin/perl

use File::Basename;

my $file = "/a/b/c/d.txt";

my ($name, $path, $suffix) = fileparse($file, qr/\.[^.]*/);
my $basename = basename($file);
my $dirname  = dirname ($file);

print "
name is    : $name
path is    : $path
suffix is  : $suffix
basename is: $basename
dirname is : $dirname
";

exit 0;
