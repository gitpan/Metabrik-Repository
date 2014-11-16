#
# $Id: Build.PL 360 2014-11-16 14:52:06Z gomor $
#
use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
   module_name => 'Metabrik::Repository',
   license => 'bsd',
   dist_author => 'GomoR <gomor_at_metabrik.org>',
   dist_version_from => 'lib/Metabrik/Repository.pm',
   requires => {
      'Metabrik' => '1.00',
   },
);

$builder->create_build_script;
