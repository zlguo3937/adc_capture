#!/usr/local/bin/perl

package P1;
$str = "P1 str";

package P2;
$str = "P2 str";

print "P1's \$str is: $P1::str\n";
print "P2's \$str is: $P2::str\n";

exit 0;
