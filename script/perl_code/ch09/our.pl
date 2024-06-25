#!/usr/local/bin/perl

($str1, $str2) = qw/str1 str2/;
print "before if: \$str1=$str1; \$str2=$str2\n";
if ( 1 ) {
  our   $str1 = "new our str1";
  local $str2 = "new local str2";
  print "in if: \$str1=$str1; \$str2=$str2\n";
}
print "after if: \$str1=$str1; \$str2=$str2\n";

exit 0;
