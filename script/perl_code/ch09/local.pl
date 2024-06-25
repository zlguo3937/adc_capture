#!/usr/local/bin/perl

print "1 \@ARGV are: ", map( { "$_ " } @ARGV), "\n";
if ( 1 ) {
  local @ARGV = @ARGV;
  unshift @ARGV, "echo";
  print "2 \@ARGV are: ", map( { "$_ " } @ARGV), "\n";
  system @ARGV;
}
print "3 \@ARGV are: ", map( { "$_ " } @ARGV), "\n";

exit 0;
