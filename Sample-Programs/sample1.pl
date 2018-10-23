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
if (!$me->is_arf) {
  print "Not an ARF Message\n";
} else {
  print "Report Type   : " . $me->feedbacktype . "\n";
  print "Report Date   : " . $me->reportdate . "\n";
  print "Sending Domain: " . $me->domain . "\n";
  print "Message ID    : " . $me->messageid . "\n";
  print "Distribution ID    : " . $me->distributionid . "\n";
  print "Recipient ID  : " . $me->recipientid . "\n";
  print "Injector Name : " . $me->servername . "\n";
  print "Injector IP   : " . $me->serverip . "\n";
}

