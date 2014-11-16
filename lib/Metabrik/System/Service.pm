#
# $Id: Service.pm 360 2014-11-16 14:52:06Z gomor $
#
# system::service Brik
#
package Metabrik::System::Service;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: 360 $',
      tags => [ qw(unstable system service daemon) ],
      commands => {
         status => [ qw(service_name) ],
         start => [ qw(service_name) ],
         stop => [ qw(service_name) ],
         restart => [ qw(service_name) ],
      },
      require_used => {
         'shell::command' => [ ],
      },
      require_binaries => {
         'service', => [ ],
      },
   };
}

sub status {
   my $self = shift;
   my ($name) = @_;

   if (! defined($name)) {
      return $self->log->error($self->brik_help_run('status'));
   }

   return $self->context->run('shell::command', 'system', "service $name status");
}

sub start {
   my $self = shift;
   my ($name) = @_;

   if (! defined($name)) {
      return $self->log->error($self->brik_help_run('start'));
   }

   return $self->context->run('shell::command', 'system', "sudo service $name start");
}

sub stop {
   my $self = shift;
   my ($name) = @_;

   if (! defined($name)) {
      return $self->log->error($self->brik_help_run('stop'));
   }

   return $self->context->run('shell::command', 'system', "sudo service $name stop");
}

sub restart {
   my $self = shift;
   my ($name) = @_;

   if (! defined($name)) {
      return $self->log->error($self->brik_help_run('restart'));
   }

   $self->stop($name) or return;

   sleep(1);

   return $self->start($name);
}

1;

__END__

=head1 NAME

Metabrik::System::Service - system::service Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut