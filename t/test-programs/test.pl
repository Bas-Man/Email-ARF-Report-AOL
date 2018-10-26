#!/usr/bin/perl

use lib '../lib';
use Email::ARF::Report::AOL;
use strict;

my $String;
my $FileName;
my $NumArgs = $#ARGV + 1;

## Code to demonstrate possible AOL process Funtions only.
## Code requires Error checking on opening file.
## File Locking would also be recommended


open(FH, "< $ARGV[0]") || die "Unable to open file: $!\n";
while(<FH>) {
   $String .= $_;
}
close(FH);

my $me = Email::ARF::Report::AOL->new($String);
if ($me->is_arf) {
  print $me->returnpath . "\n";
} else {
print "Not an ARF Email\n";
}
#print $me->report->original_email->as_string . "\n";
