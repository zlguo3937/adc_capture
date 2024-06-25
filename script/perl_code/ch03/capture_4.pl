#!/usr/local/bin/perl

my $str = "To be or not to be, it’s a question.";
if ( $str =~ /^(?<first_two_words>(\S+)\s+(?<second_word>\S+))/ ) {
  print "First two words is: $+{'first_two_words'}\n";
  print "Second word     is: $+{'second_word'}\n";
}

exit 0;
