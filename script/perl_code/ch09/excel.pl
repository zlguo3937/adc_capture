#!/usr/local/bin/perl

use Spreadsheet::XLSX;
my $excel = Spreadsheet::XLSX->new($ARGV[0]);
 
for my $sheet (@{$excel->{Worksheet}}) {
  printf("Sheet: %s\n", $sheet->{Name});
  $sheet->{MaxRow} ||= $sheet->{MinRow};
  for my $row ($sheet->{MinRow} .. $sheet->{MaxRow}) {
    $sheet->{MaxCol} ||= $sheet->{MinCol};
    for my $col ($sheet->{MinCol} .. $sheet->{MaxCol}) {
      my $cell = $sheet->{Cells}[$row][$col];
      if ($cell) {
        printf("( %s , %s ) => %s\n", $row, $col, $cell->{Val});
      }
    }
  }
}

exit 0;
