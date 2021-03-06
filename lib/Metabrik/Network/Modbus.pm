#
# $Id: Modbus.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# network::modbus Brik
#
package Metabrik::Network::Modbus;
use strict;
use warnings;

use base qw(Metabrik::Client::Tcp);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable modbus) ],
      commands => {
         probe => [ qw(host port|OPTIONAL) ],
      },
   };
}

sub probe {
   my $self = shift;
   my ($host, $port) = @_;

   $host ||= $self->host;
   $port ||= 502;

   if (! defined($host)) {
      return $self->log->error($self->brik_help_run('probe'));
   }

   # To port 502/TCP (from plcscan)
   my $probe =
      "\x00\x00\x00\x00\x00\x05\x00\x2b".
      "\x0e\x01\x00";

   $self->host($host);
   $self->port($port);
   $self->connect or return $self->log->error("probe: connect failed");
   $self->write($probe) or return $self->log->error("probe: write failed");
   my $response = $self->read or return $self->log->error("probe: read failed");
   $self->disconnect;

   return $response;
}

1;

__END__

=head1 NAME

Metabrik::Network::Modbus - network::modbus Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
