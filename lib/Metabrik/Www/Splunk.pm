#
# $Id: Splunk.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# www::splunk Brik
#
package Metabrik::Www::Splunk;
use strict;
use warnings;

use base qw(Metabrik::Api::Splunk);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable rest api splunk) ],
      attributes_default => {
         uri => 'https://localhost:8089',
         username => 'admin',
         password => 'changeme',
         ssl_verify => 0,
      },
      commands => {
         apps_local => [ ],
      },
   };
}

sub apps_local {
   my $self = shift;

   return $self->SUPER::apps_local;
}

1;

__END__

=head1 NAME

Metabrik::Www::Splunk - www::splunk Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
