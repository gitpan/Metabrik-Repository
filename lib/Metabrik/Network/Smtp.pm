#
# $Id: Smtp.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# network::smtp Brik
#
package Metabrik::Network::Smtp;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable network smtp) ],
      attributes => {
         server => [ qw(server) ],
         port => [ qw(port) ],
         _smtp => [ qw(INTERNAL) ],
      },
      attributes_default => {
         server => 'localhost',
         port => 25,
      },
      commands => {
         open => [ ],
         close => [ ],
      },
      require_modules => {
         'Net::SMTP' => [ ],
      },
   };
}

sub open {
   my $self = shift;

   my $server = $self->server;
   if (! defined($server)) {
      return $self->log->error($self->brik_help_set('server'));
   }

   my $port = $self->port;
   if (! defined($port)) {
      return $self->log->error($self->brik_help_set('port'));
   }

   my $smtp = Net::SMTP->new(
      $server,
      Port => $port,
   );
   if (! defined($smtp)) {
      return $self->log->error("open: Net::SMTP new failed for server [$server] port [$port] with [$!]");
   }

   return $self->_smtp($smtp);
}

sub close {
   my $self = shift;

   my $smtp = $self->_smtp;
   if (defined($smtp)) {
      $smtp->quit;
      $self->_smtp(undef);
   }

   return 1;
}

1;

__END__

=head1 NAME

Metabrik::Network::Smtp - network::smtp Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
