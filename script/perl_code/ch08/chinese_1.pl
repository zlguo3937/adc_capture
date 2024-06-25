#!/usr/local/bin/perl

if ( $ARGV[0] =~ /长江/ ) {
  print $ARGV[0], " 匹配 长江\n";
}
else {
  print $ARGV[0], " 不匹配 长江\n";
}

exit 0;
