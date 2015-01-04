#
# $Id: Psv.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# file::psv Brik
#
package Metabrik::File::Psv;
use strict;
use warnings;

use base qw(Metabrik::File::Csv);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable psv file) ],
      attributes_default => {
         separator => "|",
      },
   };
}

1;

__END__

=head1 NAME

Metabrik::File::Psv - file::psv Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
