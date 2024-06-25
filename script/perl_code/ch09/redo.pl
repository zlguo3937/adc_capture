#!/usr/local/bin/perl

while (<STDIN>) {
  if ( s{\\\n$}{} and defined ( $nextline = <STDIN> ) ) {
    $_ .= $nextline;
    redo;
  }
  print;
}

exit 0;
