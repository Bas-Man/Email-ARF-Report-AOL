use 5.008006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Email::ARF::Report::AOL',
    VERSION_FROM      => 'lib/Email/ARF/Report/AOL.pm', # finds $VERSION
    PREREQ_PM         => { Email::ARF::Report => 0.003 }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Email/ARF/Report/AOL.pm', # retrieve abstract from module
       AUTHOR         => 'Adam Spann <baspann@gmail.com>') : ()),
);
