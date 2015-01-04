#
# $Id: Makefile.PL,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
use ExtUtils::MakeMaker;

require v5.6.1;

WriteMakefile(
   NAME => 'Metabrik::Repository',
   VERSION_FROM => 'lib/Metabrik/Repository.pm',
   LICENSE => 'bsd',
   ABSTRACT_FROM => 'lib/Metabrik/Repository.pm',
   AUTHOR => 'GomoR <gomor_at_metabrik.org>',
   PREREQ_PM => {
      'perl' => '5.6.1',
      'Metabrik' => '1.04',
   },
);
