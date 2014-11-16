#
# $Id: Read.pm 360 2014-11-16 14:52:06Z gomor $
#
# file::read Brik
#
package Metabrik::File::Read;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: 360 $',
      tags => [ qw(unstable file) ],
      attributes => {
         input => [ qw(file) ],
         encoding => [ qw(utf8|ascii) ],
         fd => [ qw(file_descriptor) ],
      },
      commands => {
         open => [ ],
         close => [ ],
         readall => [ ],
      },
   };
}

sub brik_use_properties {
   my $self = shift;

   # encoding: see `perldoc Encode::Supported' for other types
   return {
      attributes_default => {
         input => $self->global->input || '/tmp/input.txt',
         encoding => $self->global->encoding || 'utf8',
      },
   };
}

sub open {
   my $self = shift;

   my $input = $self->input;
   if (! defined($input)) {
      return $self->log->error($self->brik_help_set('input'));
   }

   if (! -f $input) {
      return $self->log->error("open: file [$input] not found");
   }

   my $encoding = $self->encoding;
   my $r = open(my $out, "<$encoding", $input);
   if (! defined($r)) {
      return $self->log->error("open: open: file [$input]: $!");
   }

   return $self->fd($out);
}

sub close {
   my $self = shift;

   if (defined($self->fd)) {
      close($self->fd);
   }

   return 1;
}

sub readall {
   my $self = shift;

   my $fd = $self->fd;
   if (! defined($fd)) {
      return $self->log->error($self->brik_help_run('open'));
   }

   my $buf = '';
   while (<$fd>) {
      $buf .= $_;
   }

   return $buf;
}

1;

__END__

=head1 NAME

Metabrik::File::Read - file::read Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut