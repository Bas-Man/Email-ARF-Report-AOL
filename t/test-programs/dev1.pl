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
my $orig = Email::MIME->new($me->report->original_email->as_string);

my @parts = $orig->parts;
my $parts = @parts;
print "Hello\n";

print $parts[1]->body;
