#!/usr/bin/perl

system("ls -a");
my $user = `whoami` ;
print $user;