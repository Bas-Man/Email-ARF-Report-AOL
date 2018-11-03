package Email::ARF::Report::AOL;

use 5.008006;
use strict;
use warnings;
use Email::ARF::Report;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Email::ARF::Report::AOL ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.001';


sub new {
  my ($class, $source) = @_;

  Carp::croak "no report source provided" unless $source;

  my $report;

  eval {
    $report = Email::ARF::Report->new($source);
  };

  my $self = bless {};
  
  ## Catch Exception when Email is not and ARF Format
  if (!$@) {
    ## This is an ARF formated Email
    $self->{report} = $report;
    $self->_getdata;
    $self->{is_ARF} = 1;
  } else {
    ## This is not an ARF formated Email.
    $self->{report} = undef;
    $self->{is_ARF} = 0;
  }
  bless($self,$class);

  return $self;
}

sub report {
  my $self = shift;
  return $self->{report};
}

sub distributionid {
  my $self = shift;
  return $self->{distributionid}
}

sub messageid {
  my $self = shift;
  return $self->{messageid}
}

sub domain {
  my $self = shift;
  return $self->{domain}
}

sub feedbacktype {
  my $self = shift;
  return $self->{feedbacktype}
}

sub reportdate {
  my $self = shift;
  return $self->{reportdate}
}

sub recipientid {
  my $self = shift;
  return $self->{seqid}
}

sub servername {
  my $self = shift;
  return $self->{servername}
}

sub serverip {
  my $self = shift;
  return $self->{serverip}
}

sub returnpath {
  my $self = shift;
  return $self->{returnpath}
}

sub is_arf {
  my $self = shift;
  return $self->{is_ARF}
}

sub _getdata {

  my $self = shift;
  my $returnpath = $self->report->original_email->header('Return-Path');;

  $self->{returnpath} = $returnpath;

  $self->{feedbacktype} = $self->report->field('Feedback-Type');
  $self->{reportdate} = $self->report->field('Received-Date');
  $self->{servername} = $self->report->field('Reported-Domain');
  $self->{serverip} = $self->report->field('Source-IP');
  $self->{messageid} = $self->report->original_email->header('Message-ID');
  &_returnpath(\$self); # Self is passed as a reference in this function
}

sub _returnpath {

  # Note that self is reference and hence needs $$ to dereference within this function.
  my $self = shift;

  ## This test will come back to bite me in the ass. 
  if ($$self->{returnpath} =~ m/\@(ret|bounce)\.sendingdomain\.net/) {
    my ($domain,$distributionid,$seqid) = split (/_/,$$self->{returnpath});
    ## remove the leading < character if present
    $domain =~ s/<//g;
    $$self->{domain} = $domain;
    $$self->{distributionid} = $distributionid;
    ## Get everything before the @ (at mark)
    $seqid =~ s/([^\@]+).*/$1/;
    $$self->{seqid} = $seqid;
  } else {
    $$self->{domain} = undef;
    $$self->{distributionid} = undef;
    $$self->{seqid} = undef;
  }
}

1;

__END__

=head1 NAME

Email::ARF::Report::AOL - Perl extension for processing Abuse Report Formated Emails from AOL

=head1 VERSION

version 0.001

=head1 SYNOPSIS

  use Email::ARF::Report::AOL;

  my $email = Email::ARF::Report::AOL->new($text);

  if(!$email->is_ARF) {
    This is not an ARF Email do someting different
    Forward to postmaster@
  } else {
    my $messageid = $email->messageid;
    my $seq_id = $email->recipientid;
    ...
    ...
  }

=head1 DESCRIPTION

This is an extension to the Email::ARF::Report module and makes use of these methods to access underlying
data. This module has been coded to provide support AOL created ARF Emails. All Email::ARF::Report methods 
can be accessed using the provided method called B<report>.

=head2 EXPORT

None by default.

=head1 METHODS

=head3 new

Given either an Email::MIME object or a string containing the text of an email message,
 this method returns a new Email::ARF::Report::AOL Object. If it is a valid ARF formatted
  Email Object->is_arf will be true and the object will be initiated. if Object->is_arf is
   false then Email::ARF::Report object will also not be valid.

=head3 is_arf

  my $ARF_Email = $email->is_arf;

  This will return 0 if the Email was not an ARF formatted message. It will return 1 if the Email was 
  an ARF formatted email. Note: if is_arf is 0, then $email->report will be undefined.

=head3 report

  $email->report->field('from');
  $email->report->original_email->header('from');

  This gives full access to the underlying Email::ARF::Report module all methods provided through this 
  module are accessable. Note: report will be undefined if is_arf is false.

=head3 distributionid

  $email->distributionid;

  This method returns the message_id (Distribution ID) created by T&T.

=head3 messageid

  $email->messageid

  This method returns the message_id used in the Email for distribution

=head3 recipientid

  $email->recipientid;

  This method returns the recipient id, or seq_id within T&T. By joining messageid and recipientid
  we are able to search T&T database to find the email address associated with the message_id

=head3 domain

  $email->domain;

  This method returns the T&T client domain.
  Examples: support.wir.jp

=head3 reportdate

  $email->reportdate;

  This methods returns the date and time of the abuse report at AOL.

=head3 servername

  $email->servername;

  This method returns the hostname of the server which sent the orginal email as reported by AOL.

=head3 serverip

  $email->serverip

  This method returns the ip address of the server which sen the original Email as reported by AOL.

=head3 returnpath

  $email->returnpath;

  This method returns the FULL Return-Path of the original Email.


=head1 SEE ALSO

For additional functionality please refer to Email::ARF::Report module

=head1 AUTHOR

Adam Spann, E<lt>baspann@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Adam Spann

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut
